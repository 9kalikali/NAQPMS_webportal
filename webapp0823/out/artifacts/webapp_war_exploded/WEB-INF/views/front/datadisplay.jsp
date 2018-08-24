<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/27
  Time: 8:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>数据展示</title>
    <!-- 相关的CSS文件 -->
    <link rel="stylesheet" href="/css/common.css">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
    <div class="container-fluid" style="margin-top: 50px">
        <div class="row" style="margin-left: 50px;margin-right: 50px">
            <!-- 数据选项 -->
            <div class="col-sm-3" style="padding-top: 10%">
                <h2>区域</h2>
                <select id="domain" name="domain" class="form-control">
                    <option value="1">区域1</option>
                    <option value="2">区域2</option>
                </select><br>
                <h2>时间跨度</h2>
                <select id="step" name="step" class="form-control">
                    <option value="hourly">每6小时</option>
                    <option value="daily">每天</option>
                </select><br>
                <h2>污染源</h2>
                <select id="source" name="source" class="form-control">
                    <option value="pm25">PM2.5</option>
                    <option value="pm10">PM10</option>
                    <option value="so2">SO2</option>
                    <option value="co">CO</option>
                    <option value="o3">O3</option>
                    <option value="no2">NO2</option>
                </select>
            </div>
            <!-- 图片展示 -->
            <div class="col-sm-9">
                <!-- 顶部选项条 -->
                <div class="row" style="padding-top: 2%;padding-left: 3%">
                    <!-- 时间选项 -->
                    <div id="datepiker" class="col-sm-4">
                        <label>日期选择：</label>
                        <input id="display-date" name="display-date" class="form-control" readonly="true"/>
                    </div>
                    <!-- 播放按钮 -->
                    <div class="col-sm-4 col-md-offset-4">
                        <!-- 播放按钮组 -->
                        <label>播放选项：</label>
                        <div class="btn-group">
                            <button type="button" class="btn btn-default" onclick="change_speed(delay_step)"><i class="fa fa-fast-backward"></i></button>
                            <button type="button" class="btn btn-default"onclick="manualDecrement(--curImage)"><i class="fa fa-step-backward"></i> </button>
                            <button type="button" class="btn btn-default" onclick="stop()"><i class="fa fa-stop"></i></button>
                            <button type="button" class="btn btn-default" onclick="changeMode(1);playFwd()"><i class="fa fa-play"></i></button>
                            <button type="button" class="btn btn-default" onclick="manualIncrement(++curImage)"><i class="fa fa-step-forward"></i></button>
                            <button type="button" class="btn btn-default" onclick="change_speed(-delay_step)"><i class="fa fa-fast-forward"></i></button>
                        </div>
                    </div>
                </div>
                <!-- 顶部选项条end -->

                <!-- 自制的ImagePlayer -->
                <div class="row">
                    <div class="img-box" style="padding-top: 2%;padding-left: 5%">
                        <img name="animation" id="animation" src="/display/default.png"/>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script>

        var datenow = new Date();
        //转换日期格式
        var getDate = function (date) {
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            m = m < 10 ? '0' + m : m;
            var d = date.getDate();
            d = d < 10 ? ('0' + d) : d;
            return y + '-' + m + '-' + d;
        };
        $(function () {
            $('#display-date').val(getDate(datenow));
            reloadImages();
        });

        //----------------Date-Picker---------------//
        $('#display-date').datepicker({
            changeMonth:true,
            dateFormat:"yy-mm-dd",
            onClose:reloadImages
        });
        
        //----------------为参数绑定事件-------------//
        $('#domain').on('change',reloadImages);
        $('#step').on('change',reloadImages);
        $('#source').on('change',reloadImages);

        function transforDate(strDate){
            var regEx = new RegExp("\\-","gi");
            strDate = strDate.replace(regEx,"/");
            var milliseconds = Date.parse(strDate);
            var date = new Date();
            date.setTime(milliseconds);
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            m = m < 10 ? '0' + m : m;
            //根据数据格式这里是当天日期减1
            var d = date.getDate()-1;
            d = d < 10 ? ('0' + d) : d;
            return y + '-' + m + '-' + d;
        }

        /**
         * 刷新图片源
         * @param event
         */
        function reloadImages(event){
            var domainValue = $('#domain').val();
            var sourceValue = $('#source').val();
            var stepValue = $('#step').val();
            var dateValue = transforDate($('#display-date').val());
            //console.log(dateValue);
            var displaydata = {domain:domainValue,source:sourceValue,step:stepValue,date:dateValue}
            $.ajax({
                type:'post',
                data:displaydata,
                url:'/displayer/showimages',
                cache:false,
                success:function (data) {
                    //check data available
                    if(data == "fail"){
                        stop();
                        $('#animation').attr('src','/display/default.png');
                    }else{
                        //change modImages
                        console.log(1)
                        setModImages(data);
                        //play animation
                        console.log(2)
                        launch();
                    }
                },
                error:function () {
                    stop();
                    $('#animation').attr('src','/display/default.png');
                }
            });
        }
    </script>
</body>
</html>
