<%--
  Created by IntelliJ IDEA.
  User: renxuanzhengbo
  Date: 2018/4/3
  Time: 上午11:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="UTF-8">
    <title>WebGIS综合展示</title>
    <!-- 相关的CSS文件 -->
    <link rel="stylesheet" href="/css/common.css">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!-- 高德地图API -->
    <script src="http://webapi.amap.com/maps?v=1.4.4&key=f7a6a113e66804aed49457e6223d6516&plugin=AMap.MouseTool,AMap.Scale,AMap.RectangleEditor"></script>
    <!-- UI组件库 1.0 -->
    <script src="//webapi.amap.com/ui/1.0/main.js?v=1.0.11"></script>
    <!-- 模拟风场js -->
    <script src="/js/wind-sim/windy.js"></script>
    <style>
        html,body{
            height:100%;
            margin:0px;
        }
        .data-cursor{
            height: 40px;
            width: 210px;
            background-color: white;
            border: 1px solid rgb(180, 180, 180);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            z-index: 200;
            position: fixed;
            top: 30px;
            left:100px
        }
        .data-cursor p{
            padding-left: 10px;
            padding-top: 7px;
            font-size: 18px;
        }
        .scale{
            height: 240px;
            width: 50px;
            z-index: 200;
            position: fixed;
            bottom: 50px;
            left:50px
        }
    </style>
</head>
<body>
    <div id="mapcontainer" tabindex="0" class="mapcontent">
        <div class="btn-group-vertical" style="z-index: 200;position: fixed;bottom: 50px;right:50px">
            <button type="button" class="btn btn-success">风场模拟</button>
            <button id="wind-start" type="button" class="btn btn-default">开启</button>
            <button id="wind-stop" type="button" class="btn btn-default">关闭</button>
            <button type="button" class="btn btn-success">污染源</button>
            <button name="param" value="pm25" type="button" class="btn btn-default">PM2.5</button>
            <button name="param" value="pm10" type="button" class="btn btn-default">PM10</button>
            <button name="param" value="o3" type="button" class="btn btn-default">O3</button>
            <button name="param" value="no2" type="button" class="btn btn-default">NO2</button>
            <button name="param" value="so2" type="button" class="btn btn-default">SO2</button>
            <button name="param" value="co" type="button" class="btn btn-default">CO</button>
            <button id="clear" type="button" class="btn btn-default">清除</button>
        </div>

        <div class="data-cursor"><p><i class="fa fa-spinner fa-pulse"></i>数据加载中...</p></div>

        <img src="/images/pm25scale.png" class="scale"/>

        <div id="heatmap-control" class="btn-group btn-group-sm" style="z-index: 200;position: fixed;bottom: 50px;left: 45%">
            <button type="button" class="btn btn-default"onclick="refreshheatmap(-1)"><i class="fa fa-step-backward"></i></button>
            <button type="button" class="btn btn-default"onclick="refreshheatmap(0)"><i class="fa fa-refresh"></i></button>
            <button id="datatime" type="button" class="btn btn-default"></button>
            <button type="button" class="btn btn-default" onclick="refreshheatmap(1)"><i class="fa fa-step-forward"></i></button>
        </div>
    </div>

    <script>
        $(function(){
            $('#heatmap-control').hide();
            $('.data-cursor').hide();
            $('.scale').hide();
        });
        var datenow = new Date();
        //转换日期格式
        var formatDate = function (date) {
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            m = m < 10 ? '0' + m : m;
            var d = date.getDate();
            d = d < 10 ? ('0' + d) : d;
            return y + '-' + m + '-' + d;
        };
        var mcanvas;
        var canvasLayer;
        var isStopped = false;
        var curcenter;
        var heatmap;
        var map = new AMap.Map('mapcontainer', {
            resizeEnable: true,
            zoom:4,
            zooms:[4,18],
            center:[108.3,35.0],
            mapStyle: 'amap://styles/normal',
            features:['bg','road','point']
        });
        //添加控件
        AMapUI.loadUI(['control/BasicControl'], function(BasicControl) {
            //添加一个缩放控件
            map.addControl(new BasicControl.Zoom({
                position: 'lt'
            }));
            //图层切换控件
            map.addControl(new BasicControl.LayerSwitcher({
                position: 'rt'
            }));
        });

        //map加载完成事件
        map.on('complete',loadcomplete);
        //缩放事件
        map.on('zoomend',redraw);
        //地图拖拽事件
        map.on('moveend',redraw);
        //加载热力图插件
        map.plugin(["AMap.Heatmap"],function() {      //加载热力图插件
            heatmap = new AMap.Heatmap(map);    //在地图对象叠加热力图
            heatmap.setOptions({
                radius:5,
                opacity:[0,1],
                zooms:[3,18]
            });
        });

        $('#wind-start').on('click',windStart);
        $('#wind-stop').on('click',windStop);
        $('button[name="param"]').on('click',function () {
            $('#heatmap-control').show();
            maxvalue = 0;
            gradient = pm25g;
            sourceValue = $(this).val();
            h = datenow.getHours();
            h = h < 10?('0' + h) : h;
            $('#datatime').text(formatDate(datenow)+" "+h+":00");
            switch ($(this).val()){
                case 'pm25':
                    maxvalue = 350;
                    gradient = pm25g;
                    break;
                case 'pm10':
                    maxvalue = 500;
                    gradient = pm10g;
                    break;
                case 'o3':
                    maxvalue = 1000;
                    gradient = o3g;
                    break;
                case 'so2':
                    maxvalue = 2100;
                    gradient = so2g;
                    break;
                case 'no2':
                    maxvalue = 750;
                    gradient = no2g;
                case 'co':
                    maxvalue = 48;
                    gradient = cog;
                    break;
            }
            heatmap.setOptions({
                gradient:gradient
            });
            $.ajax({
                url:'/displayer/heatmapdata',
                data:{source:sourceValue,time:h},
                dataType:'json',
                beforeSend:function(){
                    var text = '<p><i class="fa fa-spinner fa-pulse"></i>数据加载中...</p>';
                    $('.data-cursor').html(text).show();
                },
                success:function(points){
                    //console.log(points);
                    heatmap.setDataSet({
                        max:maxvalue,
                        data:points
                    });
                    var text = '<p><i class="fa fa-calendar"></i>数据时间:'+formatDate(datenow)+'</p>';
                    $('.data-cursor').html(text);
                },
                error:function () {
                    var text = '<p><i class="fa fa-exclamation-circle"></i>数据获取失败</p>';
                    $('.data-cursor').html(text);
                }
            });
            $('.scale').attr('src','/images/'+$(this).val()+'scale.png').show();
            heatmap.show();
        });
        $('#clear').on('click',function () {
            heatmap.hide();
            $('.scale').hide();
            $('#heatmap-control').hide();
        });

        function refreshheatmap(timeoffset) {
            //heatmap.hide();
            h = parseInt(h) + timeoffset;
            if(h < 0){
                h = 23;
            }
            if(h === 24){
                h = 0;
            }
            h = h < 10?('0' + h) : h;
            $('#datatime').text(formatDate(datenow)+" "+h+":00");
            heatmap.setOptions({
                gradient:gradient
            });
            $.ajax({
                url:'/displayer/heatmapdata',
                data:{source:sourceValue,time:h},
                dataType:'json',
                beforeSend:function(){
                    var text = '<p><i class="fa fa-spinner fa-pulse"></i>数据加载中...</p>';
                    $('.data-cursor').html(text).show();
                },
                success:function(points){
                    //console.log(points);
                    heatmap.setDataSet({
                        max:maxvalue,
                        data:points
                    });
                    var text = '<p><i class="fa fa-calendar"></i>数据时间:'+formatDate(datenow)+'</p>';
                    $('.data-cursor').html(text);
                },
                error:function () {
                    var text = '<p><i class="fa fa-exclamation-circle"></i>数据获取失败</p>';
                    $('.data-cursor').html(text);
                }
            });
            //heatmap.show();
        }

        function loadcomplete(){
            if(isSupportCanvas()){
                curcenter = map.lnglatToPixel(map.getCenter());
                //console.log(curcenter);
                //添加canvas图层
                mcanvas = document.createElement('canvas');
                mcanvas.width = map.getSize().width;
                mcanvas.height = map.getSize().height;
                mcanvas.setAttribute('style','position: absolute; left: 0px; top: 0px;');
                canvasLayer = new AMap.CanvasLayer({
                    canvas:mcanvas,
                    bounds:map.getBounds(),
                    opacity:0.7
                });
                canvasLayer.setMap(map);
                //获取气象数据，开始绘制
                $.ajax({
                    url:'http://47.92.125.215:8080/home/display/gfs/20180420gfs.json',
                    //url:'/display/20180420gfs.json',    //测试用
                    dataType:'json',
                    beforeSend:function(){
                        $('.data-cursor').show()
                    },
                    success:function (data) {
                        //console.log(data);
                        windy = new Windy({canvas:canvasLayer.getElement(),data:data});
                        draw();
                        $('.data-cursor').hide(1500);
                    },
                    error:function () {
                        alert('获取数据失败。');
                    }
                });

            }else{
                $('#mapcontainer').html('This browser doesn\'t support canvas. Visit <a target=\'_blank\' href=\'http://www.caniuse.com/#search=canvas\'>caniuse.com</a> for supported browsers');
            }
        }


        //检查浏览器是否支持canvas
        function isSupportCanvas(){
            return !!document.createElement("canvas").getContext;
        }
        //开始绘制
        function draw(){
            windy.stop();
            var mapsize = map.getSize();
            var mapbounds = map.getBounds();

            setTimeout(function () {
                windy.start(
                    [[0, 0], [mapsize.width,mapsize.height]],
                    mapsize.getWidth(),
                    mapsize.getHeight(),
                    [[mapbounds.getSouthWest().getLng(),mapbounds.getSouthWest().getLat()], [mapbounds.getNorthEast().getLng(),mapbounds.getNorthEast().getLat()]]
                );
            }, 500);
        }
        //地图缩放或平移后重新绘制
        function redraw() {
            if(!isStopped){
                windy.stop();
                canvasLayer.setMap(null);
                var mapsize = map.getSize();
                var mapbounds = map.getBounds();
                //修改canvas位置
                var newcenter = map.lnglatToPixel(map.getCenter());
                var offsetX = newcenter.getX() - curcenter.getX();
                var offsetY = newcenter.getY() - curcenter.getY();
                curcenter = newcenter;
                mcanvas.setAttribute('style','position: absolute; left: '+offsetX+'px; top: '+offsetY+'px;');
                //重新绑定图层
                canvasLayer = new AMap.CanvasLayer({
                    canvas:mcanvas,
                    bounds:mapbounds,
                    opacity:0.7
                });
                canvasLayer.setMap(map);
                setTimeout(function () {
                    windy.start(
                        [[0, 0], [mapsize.width,mapsize.height]],
                        mapsize.getWidth(),
                        mapsize.getHeight(),
                        [[mapbounds.getSouthWest().getLng(),mapbounds.getSouthWest().getLat()], [mapbounds.getNorthEast().getLng(),mapbounds.getNorthEast().getLat()]]
                    );
                }, 500);
            }
            //refreshheatmap(0);
        }

        function windStart(){
            isStopped = false;
            redraw();
        }

        function windStop(){
            windy.stop();
            canvasLayer.setMap(null);
            isStopped = true;
        }

        //------------------热力图色阶参数----------------//
        var pm25g = {
            0.1:'rgb(0,232,190)',
            0.21:'rgb(180,240,0)',
            0.33:'rgb(255,220,0)',
            0.43:'rgb(255,95,0)',
            0.71:'rgb(220,0,100)',
            1.0:'rgb(110,0,160)'
        };

        var pm10g = {
            0.1:'rgb(0,232,190)',
            0.3:'rgb(180,240,0)',
            0.5:'rgb(255,220,0)',
            0.7:'rgb(255,95,0)',
            0.84:'rgb(220,0,100)',
            1.0:'rgb(110,0,160)'
        };

        var o3g = {
            0.16:'rgb(0,232,190)',
            0.2:'rgb(180,240,0)',
            0.3:'rgb(255,220,0)',
            0.4:'rgb(255,95,0)',
            0.8:'rgb(220,0,100)',
            1.0:'rgb(110,0,160)'
        };

        var so2g = {
            0.07:'rgb(0,232,190)',
            0.24:'rgb(180,240,0)',
            0.31:'rgb(255,220,0)',
            0.38:'rgb(255,95,0)',
            0.76:'rgb(220,0,100)',
            1.0:'rgb(110,0,160)'
        };

        var no2g = {
            0.05:'rgb(0,232,190)',
            0.11:'rgb(180,240,0)',
            0.24:'rgb(255,220,0)',
            0.37:'rgb(255,95,0)',
            0.75:'rgb(220,0,100)',
            1.0:'rgb(110,0,160)'
        };

        var cog = {
            0.04:'rgb(0,232,190)',
            0.08:'rgb(180,240,0)',
            0.29:'rgb(255,220,0)',
            0.5:'rgb(255,95,0)',
            0.75:'rgb(220,0,100)',
            1.0:'rgb(110,0,160)'
        };
        //------------------热力图色阶参数end----------------//
    </script>
</body>
</html>
