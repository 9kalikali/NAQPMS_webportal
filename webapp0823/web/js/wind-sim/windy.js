/**
 * 模拟风场js
 * 数据源(1km GFS from http://www.emc.ncep.noaa.gov/index.php?branch=GFS)
 * 利用js和html5的canvas元素进行风场绘制，并用双线性插值进行平滑处理
 * @param params
 * @returns {{params: *, start: start, stop: stop}}
 * @constructor
 */
var Windy = function( params ){
    //粒子运动速率
    var VELOCITY_SCALE = 0.011;
    //粒子颜色变化步长
    var INTENSITY_SCALE_STEP = 10;
    //最大风速
    var MAX_WIND_INTENSITY = 40;
    //粒子生命周期
    var MAX_PARTICLE_AGE = 100;
    //粒子宽度
    var PARTICLE_LINE_WIDTH = 2;
    //决定粒子数量的因子 last:1/30
    var PARTICLE_MULTIPLIER = 1/300;
    //用于移动设备减少粒子数目
    var PARTICLE_REDUCTION = 0.75;
    //帧率
    var FRAME_RATE = 20;
    //var BOUNDARY = 0.45;
    //未定义风向量[u,v,m]分别为南北风、东西风、风的强度
    var NULL_WIND_VECTOR = [NaN, NaN, null];
    //var TRANSPARENT_BLACK = [255, 0, 0, 0];

    // var τ = 2 * Math.PI;
    // var H = Math.pow(10, -5.2);

    /**
     * 双线性插值方法
     * 对点(x,y)的风向量进行求解
     * @param x
     * @param y
     * @param g00
     * @param g10
     * @param g01
     * @param g11
     * @returns {*[]}
     */
    var bilinearInterpolateVector = function(x, y, g00, g10, g01, g11) {
        var rx = (1 - x);
        var ry = (1 - y);
        var a = rx * ry,  b = x * ry,  c = rx * y,  d = x * y;
        var u = g00[0] * a + g10[0] * b + g01[0] * c + g11[0] * d;
        var v = g00[1] * a + g10[1] * b + g01[1] * c + g11[1] * d;
        return [u, v, Math.sqrt(u * u + v * v)];
    };

    /**
     * 从u,v数据中获取[u,v]
     * @param uComp
     * @param vComp
     * @returns {{header: *, data: function(*): *[], interpolate: function(*, *, *, *, *, *): *[]}}
     */
    var createWindBuilder = function(uComp, vComp) {
        var uData = uComp.data, vData = vComp.data;
        return {
            header: uComp.header,
            //recipe: recipeFor("wind-" + uComp.header.surface1Value),
            data: function(i) {
                return [uData[i], vData[i]];
            },
            interpolate: bilinearInterpolateVector
        }
    };

    /**
     * 从json数据中提取出header和u,v数据
     * @param data
     * @returns {{header: *, data: function(*): *[], interpolate: function(*, *, *, *, *, *): *[]}}
     */
    var createBuilder = function(data) {
        var uComp = null, vComp = null, scalar = null;

        data.forEach(function(record) {
            switch (record.header.parameterCategory + "," + record.header.parameterNumber) {
                case "2,2": uComp = record; break;
                case "2,3": vComp = record; break;
                default:
                    scalar = record;
            }
        });

        return createWindBuilder(uComp, vComp);
    };

    /**
     * 根据数据构建网格
     * @param data
     * @param callback
     */
    var buildGrid = function(data, callback) {
        var builder = createBuilder(data);

        var header = builder.header;
        var λ0 = header.lo1, φ0 = header.la1;  // 网格基准线(e.g., 0.0E, 90.0N)
        var Δλ = header.dx, Δφ = header.dy;    // 格点之间的距离(e.g., 2.5 deg lon, 2.5 deg lat)
        var ni = header.nx, nj = header.ny;    // 格点数量东经到西经，南纬到北纬(e.g., 360 x 181)
        var date = new Date(header.refTime);
        date.setHours(date.getHours() + header.forecastTime);

        var grid = [], p = 0;
        var isContinuous = Math.floor(ni * Δλ) >= 360;
        for (var j = 0; j < nj; j++) {
            var row = [];
            for (var i = 0; i < ni; i++, p++) {
                row[i] = builder.data(p);
            }
            if (isContinuous) {
                row.push(row[0]);
            }
            grid[j] = row;
        }

        /**
         * 对某点进行插值
         * @param λ
         * @param φ
         * @returns {*}
         */
        function interpolate(λ, φ) {
            var i = floorMod(λ - λ0, 360) / Δλ;  // 计算[0, 360)范围内经度下标
            var j = (φ0 - φ) / Δφ;                 // 计算【+90, -90]的纬度下标

            var fi = Math.floor(i), ci = fi + 1;
            var fj = Math.floor(j), cj = fj + 1;

            var row;
            if ((row = grid[fj])) {
                var g00 = row[fi];
                var g10 = row[ci];
                if (isValue(g00) && isValue(g10) && (row = grid[cj])) {
                    var g01 = row[fi];
                    var g11 = row[ci];
                    if (isValue(g01) && isValue(g11)) {
                        // All four points found, so interpolate the value.
                        return builder.interpolate(i - fi, j - fj, g00, g10, g01, g11);
                    }
                }
            }
            return null;
        }
        callback( {
            date: date,
            interpolate: interpolate
        });
    };



    /**
     * 判断变量是否为null或为定义
     * @returns {Boolean}
     */
    var isValue = function(x) {
        return x !== null && x !== undefined;
    }

    /**
     * 地板除取模，对负数取模很有效果
     * @returns {Number}
     */
    var floorMod = function(a, n) {
        return a - n * Math.floor(a / n);
    }

    /**
     * @returns {Number} the value x clamped to the range [low, high].
     */
    var clamp = function(x, range) {
        return Math.max(range[0], Math.min(x, range[1]));
    }

    /**
     * 判断设备类型
     * @returns {Boolean}
     */
    var isMobile = function() {
        return (/android|blackberry|iemobile|ipad|iphone|ipod|opera mini|webos/i).test(navigator.userAgent);
    }

    /**
     * 修正投影造成的失真
     * @param projection
     * @param λ
     * @param φ
     * @param x
     * @param y
     * @param scale
     * @param wind
     * @param windy
     * @returns {*}
     */
    var distort = function(projection, λ, φ, x, y, scale, wind, windy) {
        var u = wind[0] * scale;
        var v = wind[1] * scale;
        var d = distortion(projection, λ, φ, x, y, windy);

        // Scale distortion vectors by u and v, then add.
        wind[0] = d[0] * u + d[2] * v;
        wind[1] = d[1] * u + d[3] * v;
        return wind;
    };

    var distortion = function(projection, λ, φ, x, y, windy) {
        var τ = 2 * Math.PI;
        var H = Math.pow(10, -5.2);
        var hλ = λ < 0 ? H : -H;
        var hφ = φ < 0 ? H : -H;

        var pλ = project(φ, λ + hλ,windy);
        var pφ = project(φ + hφ, λ, windy);

        // Meridian scale factor (see Snyder, equation 4-3), where R = 1. This handles issue where length of 1º λ
        // changes depending on φ. Without this, there is a pinching effect at the poles.
        var k = Math.cos(φ / 360 * τ);
        return [
            (pλ[0] - x) / hλ / k,
            (pλ[1] - y) / hλ / k,
            (pφ[0] - x) / hφ,
            (pφ[1] - y) / hφ
        ];
    };



    var createField = function(columns, bounds, callback) {

        /**
         * 返回(x, y)点的风向向量
         * @returns {Array}
         */
        function field(x, y) {
            var column = columns[Math.round(x)];
            return column && column[Math.round(y)] || NULL_WIND_VECTOR;
        }


        field.release = function() {
            columns = [];
        };

        /**
         * 随机选取风向向量部位空的点
         * 在上面放置粒子
         * @param o
         * @returns {*}
         */
        field.randomize = function(o) {  // UNDONE: this method is terrible
            var x, y;
            var safetyNet = 0;
            do {
                x = Math.round(Math.floor(Math.random() * bounds.width) + bounds.x);
                y = Math.round(Math.floor(Math.random() * bounds.height) + bounds.y)
            } while (field(x, y)[2] === null && safetyNet++ < 30);
            o.x = x;
            o.y = y;
            return o;
        };

        //field.overlay = mask.imageData;
        //return field;
        callback( bounds, field );
    };

    /**
     * 当地图未充满或超出浏览器大小时确定canvas绘制的范围
     * 因为webgis综合展示页面的地图是充满浏览器的，所以不用担心这个问题
     * 一般（x,y）是（0,0）；（xmax,ymax）是（mapWidth,mapHeight）
     * @param bounds
     * @param width
     * @param height
     * @returns {{x: number, y: number, xMax: *, yMax: number, width: *, height: *}}
     */
    var buildBounds = function( bounds, width, height ) {
        var upperLeft = bounds[0];
        var lowerRight = bounds[1];
        var x = Math.round(upperLeft[0]); //Math.max(Math.floor(upperLeft[0], 0), 0);
        var y = Math.max(Math.floor(upperLeft[1], 0), 0);
        var xMax = Math.min(Math.ceil(lowerRight[0], width), width - 1);
        var yMax = Math.min(Math.ceil(lowerRight[1], height), height - 1);
        return {x: x, y: y, xMax: width, yMax: yMax, width: width, height: height};
    };

    var deg2rad = function( deg ){
        return (deg / 180) * Math.PI;
    };

    var rad2deg = function( ang ){
        return ang / (Math.PI/180.0);
    };

    /**
     * 将像素坐标转化为经纬度坐标
     * @param x
     * @param y
     * @param windy
     * @returns {*[]}
     */
    var invert = function(x, y, windy){
        var mapLonDelta = windy.east - windy.west;
        var worldMapRadius = windy.width / rad2deg(mapLonDelta) * 360/(2 * Math.PI);
        var mapOffsetY = ( worldMapRadius / 2 * Math.log( (1 + Math.sin(windy.south) ) / (1 - Math.sin(windy.south))  ));
        var equatorY = windy.height + mapOffsetY;
        var a = (equatorY-y)/worldMapRadius;

        var lat = 180/Math.PI * (2 * Math.atan(Math.exp(a)) - Math.PI/2);
        var lon = rad2deg(windy.west) + x / windy.width * rad2deg(mapLonDelta);
        return [lon, lat];
    };

    /**
     * 纬度的墨卡托投影
     * @param lat
     * @returns {number}
     */
    var mercY = function( lat ) {
        return Math.log( Math.tan( lat / 2 + Math.PI / 4 ) );
    };

    /**
     * 利用墨卡托投影将经纬度坐标转化为浏览器像素坐标
     * @param lat
     * @param lon
     * @param windy
     * @returns {*[]}
     */
    var project = function( lat, lon, windy) { // both in radians, use deg2rad if neccessary
        var ymin = mercY(windy.south);
        var ymax = mercY(windy.north);
        var xFactor = windy.width / ( windy.east - windy.west );
        var yFactor = windy.height / ( ymax - ymin );

        var y = mercY( deg2rad(lat) );
        var x = (deg2rad(lon) - windy.west) * xFactor;
        var y = (ymax - y) * yFactor; // y points south
        return [x, y];
    };


    var interpolateField = function( grid, bounds, extent, callback ) {

        var projection = {};
        var velocityScale = VELOCITY_SCALE;

        var columns = [];
        var x = bounds.x;

        function interpolateColumn(x) {
            var column = [];
            for (var y = bounds.y; y <= bounds.yMax; y += 2) {
                var coord = invert( x, y, extent );
                if (coord) {
                    var λ = coord[0], φ = coord[1];
                    if (isFinite(λ)) {
                        var wind = grid.interpolate(λ, φ);
                        if (wind) {
                            wind = distort(projection, λ, φ, x, y, velocityScale, wind, extent);
                            column[y+1] = column[y] = wind;

                        }
                    }
                }
            }
            columns[x+1] = columns[x] = column;
        }

        (function batchInterpolate() {
            var start = Date.now();
            while (x < bounds.width) {
                interpolateColumn(x);
                x += 2;
                if ((Date.now() - start) > 1000) { //MAX_TASK_TIME) {
                    setTimeout(batchInterpolate, 25);
                    return;
                }
            }
            createField(columns, bounds, callback);
        })();
    };


    /**
     * 计算并绘制每一帧
     * @param bounds
     * @param field
     */
    var animate = function(bounds, field) {

        function asColorStyle(r, g, b, a) {
            return "rgba(" + 243 + ", " + 243 + ", " + 238 + ", " + a + ")";
        }

        function hexToR(h) {return parseInt((cutHex(h)).substring(0,2),16)}
        function hexToG(h) {return parseInt((cutHex(h)).substring(2,4),16)}
        function hexToB(h) {return parseInt((cutHex(h)).substring(4,6),16)}
        function cutHex(h) {return (h.charAt(0)=="#") ? h.substring(1,7):h}

        /**
         * 根据强度设定粒子颜色
         * @param step
         * @param maxWind
         * @returns {*[]}
         */
        function windIntensityColorScale(step, maxWind) {
            //颜色梯度
            var result = [
                "rgba(" + hexToR('#00ffff') + ", " + hexToG('#00ffff') + ", " + hexToB('#00ffff') + ", " + 0.5 + ")",
                "rgba(" + hexToR('#64f0ff') + ", " + hexToG('#64f0ff') + ", " + hexToB('#64f0ff') + ", " + 0.5 + ")",
                "rgba(" + hexToR('#87e1ff') + ", " + hexToG('#87e1ff') + ", " + hexToB('#87e1ff') + ", " + 0.5 + ")",
                "rgba(" + hexToR('#a0d0ff') + ", " + hexToG('#a0d0ff') + ", " + hexToB('#a0d0ff') + ", " + 0.5 + ")",
                "rgba(" + hexToR('#b5c0ff') + ", " + hexToG('#b5c0ff') + ", " + hexToB('#b5c0ff') + ", " + 0.5 + ")",
                "rgba(" + hexToR('#c6adff') + ", " + hexToG('#c6adff') + ", " + hexToB('#c6adff') + ", " + 0.5 + ")",
                "rgba(" + hexToR('#d49bff') + ", " + hexToG('#d49bff') + ", " + hexToB('#d49bff') + ", " + 0.5 + ")",
                "rgba(" + hexToR('#e185ff') + ", " + hexToG('#e185ff') + ", " + hexToB('#e185ff') + ", " + 0.5 + ")",
                "rgba(" + hexToR('#ec6dff') + ", " + hexToG('#ec6dff') + ", " + hexToB('#ec6dff') + ", " + 0.5 + ")",
                "rgba(" + hexToR('#ff1edb') + ", " + hexToG('#ff1edb') + ", " + hexToB('#ff1edb') + ", " + 0.5 + ")"
            ]
            result.indexFor = function(m) {  // map wind speed to a style
                return Math.floor(Math.min(m, maxWind) / maxWind * (result.length - 1));
            };
            return result;
        }

        var colorStyles = windIntensityColorScale(INTENSITY_SCALE_STEP, MAX_WIND_INTENSITY);
        var buckets = colorStyles.map(function() { return []; });

        var particleCount = Math.round(bounds.width * bounds.height * PARTICLE_MULTIPLIER);
        if (isMobile()) {
            particleCount *= PARTICLE_REDUCTION;
        }

        var fadeFillStyle = "rgba(0, 0, 0, 0.97)";

        var particles = [];
        for (var i = 0; i < particleCount; i++) {
            particles.push(field.randomize({age: Math.floor(Math.random() * MAX_PARTICLE_AGE) + 0}));
        }

        /**
         * 计算下一帧
         */
        function evolve() {
            buckets.forEach(function(bucket) { bucket.length = 0; });
            particles.forEach(function(particle) {
                if (particle.age > MAX_PARTICLE_AGE) {
                    field.randomize(particle).age = 0;
                }
                var x = particle.x;
                var y = particle.y;
                var v = field(x, y);  // vector at current position
                var m = v[2];
                if (m === null) {
                    particle.age = MAX_PARTICLE_AGE;  // particle has escaped the grid, never to return...
                }
                else {
                    var xt = x + v[0];
                    var yt = y + v[1];
                    if (field(xt, yt)[2] !== null) {
                        // Path from (x,y) to (xt,yt) is visible, so add this particle to the appropriate draw bucket.
                        particle.xt = xt;
                        particle.yt = yt;
                        buckets[colorStyles.indexFor(m)].push(particle);
                    }
                    else {
                        // Particle isn't visible, but it still moves through the field.
                        particle.x = xt;
                        particle.y = yt;
                    }
                }
                particle.age += 1;
            });
        }

        var g = params.canvas.getContext("2d");
        g.lineWidth = PARTICLE_LINE_WIDTH;
        g.fillStyle = fadeFillStyle;

        /**
         * 绘制一帧
         */
        function draw() {
            // 粒子轨迹淡入淡出
            var prev = g.globalCompositeOperation;
            g.globalCompositeOperation = "destination-in";
            g.fillRect(bounds.x, bounds.y, bounds.width, bounds.height);
            g.globalCompositeOperation = prev;

            // 绘制粒子轨迹
            buckets.forEach(function(bucket, i) {
                if (bucket.length > 0) {
                    g.beginPath();
                    g.strokeStyle = colorStyles[i];
                    bucket.forEach(function(particle) {
                        g.moveTo(particle.x, particle.y);
                        g.lineTo(particle.xt, particle.yt);
                        particle.x = particle.xt;
                        particle.y = particle.yt;
                    });
                    g.stroke();
                }
            });
        }

        (function frame() {
            try {
                windy.timer = setTimeout(function() {
                    requestAnimationFrame(frame);
                    evolve();
                    draw();
                }, 1000 / FRAME_RATE);
            }
            catch (e) {
                console.error(e);
            }
        })();
    }

    var start = function( bounds, width, height, extent ){

        var mapBounds = {
            south: deg2rad(extent[0][1]),
            north: deg2rad(extent[1][1]),
            east: deg2rad(extent[1][0]),
            west: deg2rad(extent[0][0]),
            width: width,
            height: height
        };

        stop();

        // 构建网格
        buildGrid( params.data, function(grid){
            // 对可视区域插值
            interpolateField( grid, buildBounds( bounds, width, height), mapBounds, function( bounds, field ){
                // 播放动画
                windy.field = field;
                animate( bounds, field );
            });

        });
    };

    var stop = function(){
        if (windy.field) windy.field.release();
        if (windy.timer) clearTimeout(windy.timer)
    };


    var windy = {
        params: params,
        start: start,
        stop: stop
    };

    return windy;
}



// shim layer with setTimeout fallback
window.requestAnimationFrame = (function(){
    return  window.requestAnimationFrame       ||
        window.webkitRequestAnimationFrame ||
        window.mozRequestAnimationFrame    ||
        window.oRequestAnimationFrame ||
        window.msRequestAnimationFrame ||
        function( callback ){
            window.setTimeout(callback, 1000 / 20);
        };
})();
