<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/6
  Time: 14:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%--<%--%>
    <%--Cookie cookie = null;--%>
    <%--Cookie[] cookies = null;--%>
    <%--// 获取当前域名下的cookies，是一个数组--%>
    <%--cookies = request.getCookies();--%>
    <%--String userid = "";--%>
    <%--if(cookies != null){--%>
        <%--for (int i = 0; i < cookies.length; i++) {--%>
            <%--cookie = cookies[i];--%>
            <%--if((cookie.getName().compareTo("userid")) == 0){--%>
                <%--userid = cookie.getValue();--%>
            <%--}--%>
        <%--}--%>
    <%--}--%>
<%--%>--%>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="UTF-8">
    <title>计算任务</title>
    <!-- 相关的CSS文件 -->
    <link rel="stylesheet" href="/css/common.css">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!-- 表单验证插件 -->
    <script src="/js/validator/jquery.validate.min.js"></script>
    <script src="/js/validator/localization/messages_zh.js"></script>
    <!-- 高德地图API -->
    <script src="http://webapi.amap.com/maps?v=1.4.4&key=f7a6a113e66804aed49457e6223d6516&plugin=AMap.MouseTool,AMap.Scale,AMap.RectangleEditor"></script>
    <!-- jQueryUI DateTimepicker -->
    <script src="/js/jquery-ui.min.js"></script>
    <link href="/css/jquery-ui.min.css" rel="stylesheet" />
    <script src="/jQuery-Timepicker/jquery-ui-timepicker-addon.min.js"></script>
    <script type="text/javascript" src="/jQuery-Timepicker/i18n/jquery-ui-timepicker-zh-CN.js"></script>
    <link href="/jQuery-Timepicker/jquery-ui-timepicker-addon.min.css" rel="stylesheet" />

    <style>
        html,body{
            height:100%;
            margin:0px;
        }
    </style>
    <script>
        var recid;
        function getCookie(cname){
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for(var i=0; i<ca.length; i++) {
                var c = ca[i].trim();
                if (c.indexOf(name)==0) { return c.substring(name.length,c.length); }
            }
            return "";
        }
        var checkmessage = function (recid){
            $.ajax({
                type:'post',
                url:'/message/unreadcount/'+recid,
                cache:false,
                success:function (data) {
                    $('#mcount').html(data);
                    console.log(data);
                }
            });
        }
        function checkLogin() {
            user=getCookie("userid");
            if (user != null && user != ""){
                //alert("欢迎 " + user + " 访问");
                /*                  document.getElementById("loginbar")
                                      .innerHTML="<ul class=\"nav navbar-nav navbar-right\">\n" +
                                      "                  <li><a href=\"/usercenter/userindex\"><span class=\"glyphicon glyphicon-user\"></span>你好！"+user+"</a></li>\n" +
                                      "                  <li><a href=\"#\"><span class=\"glyphicon glyphicon-envelope\"></span> 通知<span id=\"mcount\" class=\"badge\"></span></a></li>\n" +
                                      "                  <li><a href=\"/user/dologout\"><span class=\"glyphicon glyphicon-log-out\"></span>登出</a></li>\n" +
                                      "              </ul>";*/
                document.getElementById("loginbar")
                    .innerHTML="<ul class=\"nav navbar-nav navbar-right\">\n" +
                    "                  <li><a href=\"/usercenter/userindex\"><span class=\"glyphicon glyphicon-user\"></span>你好！"+user+"</a></li>\n" +
                    "                  <li><a href=\"/usercenter/userindex\" style=\"padding-left: 0px; padding-right: 0px\"><span class=\"glyphicon glyphicon-hand-right\"></span>   用户中心</a></li>\n" +
                    "                  <li><a href=\"#\"><span class=\"glyphicon glyphicon-envelope\"></span> 通知<span id=\"mcount\" class=\"badge\"></span></a></li>\n" +
                    "                  <li><a href=\"/user/dologout\"><span class=\"glyphicon glyphicon-log-out\"></span>登出</a></li>\n" +
                    "              </ul>";
                recid = user;
                checkmessage(recid);
                //定时每30min查一次
                setInterval("checkmessage(recid)",30*60*1000);
            }
        }
        $(function () {
            checkLogin();
            $('#myModal').modal('hide');
            $('#argsform').validate({
                rules:{
                    minlon:{
                        required:true,
                        number:true
                    },
                    minlat:{
                        required:true,
                        number:true
                    },
                    maxlon:{
                        required:true,
                        number:true
                    },
                    maxlat:{
                        required:true,
                        number:true
                    },
                    step_length:{
                        required:true,
                        digits:true
                    },
                    startTime:{
                        required:true
                    },
                    endTime:{
                        required:true
                    }
                }
            });
        });
    </script>
</head>
<body>
<!-- 标题栏 -->
<nav class="navbar navbar navbar-static-top" role="navigation" style="margin-bottom: 0px">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="/">NAQPMS在线交互</a>
        </div>
        <div id="loginbar">
            <ul class="nav navbar-nav navbar-right">
                <li><a href="/regist"><span class="glyphicon glyphicon-user"></span> 注册</a></li>
                <li><a href="/login"><span class="glyphicon glyphicon-log-in"></span> 登录</a></li>
            </ul>
        </div>
    </div>
</nav>
<!-- 地图 -->
<div id="mapcontainer" tabindex="0" class="mapcontent">

    <!-- 选择提交类型 -->
    <div id="selectSubmit" class="col-md-3 draw-panel" style="z-index: 200; padding-bottom: 2%">
        <h4 class="text-center">选择提交类型</h4>
        <button id="toShSubmit" class="btn btn-block btn-primary">提交脚本</button>
        <button id="toArgsSubmit" class="btn btn-block btn-primary">提交参数</button>
    </div>

    <!-- 提交参数 -->
    <div id="ArgsSubmit" class="col-md-3 draw-panel" style="z-index: 200; display: none">
        <h4 class="text-center">
            <a href="javascript:void(0)" onclick="backToSelectSubmit()" style="text-decoration: none">
                <span class="glyphicon glyphicon-arrow-left"></span>
            </a> 提交参数
        </h4>
        <form id="argsform" role="form">
            <div class="form-group">
                <label>最小经纬度</label>
                <div class="row">
                    <div class="col-xs-6"><label>经度：</label><input id="minlon" name="minlon" class="form-control" value="0.00" /></div>
                    <div class="col-xs-6"><label>纬度：</label><input id="minlat" name="minlat" class="form-control" value="0.00" /></div>
                </div>
            </div>
            <div class="form-group">
                <label>最大经纬度</label>
                <div class="row">
                    <div class="col-xs-6"><label>经度：</label><input id="maxlon" name="maxlon" class="form-control" value="0.00" /></div>
                    <div class="col-xs-6"><label>纬度：</label><input id="maxlat" name="maxlat" class="form-control" value="0.00" /></div>
                </div>
            </div>
            <div class="form-group">
                <label>分辨率/km</label>
                <div class="row">
                    <div class="col-xs-6"><input id="step_length" name="step_length" class="form-control" value="10" /></div>
                    <input id="cenlon" type="hidden"/>
                    <input id="cenlat" type="hidden"/>
                </div>
            </div>
            <div class="form-group">
                <label>起始时间：</label>
                <input path="startTime" id="start-time" name="startTime" class="form-control" placeholder="点击选择时间" readonly="true"/>
                <label>结束时间：</label>
                <input path="endTime" id="end-time" name="endTime" class="form-control" placeholder="点击选择时间" readonly="true"/>
            </div>
            <button id="nextstep" type="button" class="btn btn-block btn-primary">下一步</button>
        </form>

    </div>
    <!-- 编辑选项 -->
    <div id="ArgsSubmitEdit" class="col-md-1 edit-panel" style="z-index:200;float: right; display: none">
        <button type="button" class="btn btn-primary" data-toggle="collapse" data-target="#btngroup">框选区域</button>

        <div id="btngroup" class="collapse">
            <div class="btn-group-vertical">
                <button id="btn1" type="button" class="btn btn-info">鼠标框选</button>
                <button id="btn3" type="button" class="btn btn-info">确认选区</button>
            </div>
        </div>
    </div>
    <!-- 提交脚本-->
    <div id="ShSubmit" class="col-md-3 draw-panel" style="z-index: 200; display: none; padding-bottom: 2%">
        <h4 class="text-center">
            <a href="javascript:void(0)" onclick="backToSelectSubmit()" style="text-decoration: none">
                <span class="glyphicon glyphicon-arrow-left"></span>
            </a> 提交脚本
        </h4>
        <form id="filesForm" role="form">
            <div class="file-module">
                <input type="file" class="form-control" name="inputFiles" style="display: none;">
                <div class="form-group">
                    <div class="input-group">
                        <span class="input-group-btn">
                            <button class="btn btn-primary choose-file" type="button">选择文件</button>
                        </span>
                        <input type="text" class="form-control show-file" id="show-file:1" name="showFiles" readonly="true" maxlength="100">
                        <div class="input-group-addon" style="padding-left: 0px; padding-right: 0px;">
                            <span class="glyphicon glyphicon-minus" title="删除该文件"></span>
                        </div>
                        <div class="input-group-addon" style="padding-left: 0px; padding-right: 0px;">
                            <span class="glyphicon glyphicon-plus" title="更多文件"></span>
                        </div>
                    </div>
                    <div class="col-sm-1"></div>
                </div>
            </div>
        </form>
        <button class="btn btn-block btn-primary" id="filesSubmit">提交</button>
    </div>
</div>

<!--  提交作业模态框 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content container-fluid">
            <div class="modal-body row">
                <div class="panel" style="border: none">
                    <div class="panel-heading text-center">
                        <h3 class="panel-title">作业提交</h3>
                    </div>
                    <div class="panel-body">
                        <form class="form-horizontal" id="submitForm" enctype="multipart/form-data">
                            <fieldset>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label" for="jobName">作业名称：</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="jobName" name="jobName" readonly="readonly">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">经度范围：</label>
                                    <div class="col-sm-8 input-group" style="padding-left: 14px; padding-right: 14px;">
                                        <input type="text" class="form-control" id="m_minlon" name="minlon" readonly="readonly"><div class="input-group-addon">~</div><input type="text" class="form-control" id="m_maxlon" name="maxlon" readonly="readonly">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">纬度范围：</label>
                                    <div class="col-sm-8 input-group"  style="padding-left: 14px; padding-right: 14px;">
                                        <input type="text" class="form-control" id="m_minlat" name="minlat" readonly="readonly"><div class="input-group-addon">~</div><input type="text" class="form-control" id="m_maxlat" name="maxlat" readonly="readonly">
                                        <input type="hidden" id="m_cenlon" name="cenlon">
                                        <input type="hidden" id="m_cenlat" name="cenlat">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">时间范围：</label>
                                    <div class="col-sm-8 input-group"  style="padding-left: 14px; padding-right: 14px;">
                                        <input type="text" class="form-control" id="m_start-time" name="starttime" readonly="readonly"><div class="input-group-addon">~</div><input type="text" class="form-control" id="m_end-time" name="endtime" readonly="readonly">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label" for="input02">分辨率：</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="m_step_length" name="steplength" readonly="readonly">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label" for="input02">标准输出：</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" placeholder="stdout" id="input02"
                                               name="stdout">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label" for="input03">标准错误：</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" placeholder="stderr" id="input03"
                                               name="stderr">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label" for="input04">工作目录：</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="input04" name="dir">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label" for="input05">CPU个数：</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="input05" name="CPUs">
                                    </div>
                                </div>
                            </fieldset>
                        </form>
                        <div class="col-xs-offset-5">
                            <button class="btn btn-primary" id="submit">提交</button>
                        </div>
                    </div>
                </div>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal -->
</div>

<script>
    $('body').on('click', '#toArgsSubmit', function () {
        $('#ArgsSubmit').show();
        $('#ArgsSubmitEdit').show();
        $('#selectSubmit').hide();
    });
    $('body').on('click', '#toShSubmit', function () {
        $('#ShSubmit').show();
        $('#selectSubmit').hide();
    });

    function backToSelectSubmit() {
        $('#ArgsSubmit').hide();
        $('#ArgsSubmitEdit').hide();
        $('#ShSubmit').hide();
        $('#selectSubmit').show();
    }

    var fileNumber = 1;
    var txt = "            <div class=\"file-module\">\n" +
        "                <input type=\"file\" class=\"form-control\" name=\"inputFiles\" style=\"display: none;\">\n" +
        "                <div class=\"form-group\">\n" +
        "                    <div class=\"input-group\">\n" +
        "                        <span class=\"input-group-btn\">\n" +
        "                            <button class=\"btn btn-primary choose-file\" type=\"button\">选择文件</button>\n" +
        "                        </span>\n" +
        "                        <input type=\"text\" class=\"form-control show-file\" id=\"show-file:1\" name=\"showFiles\" readonly=\"readonly\" maxlength=\"100\">\n" +
        "                        <div class=\"input-group-addon\" style=\"padding-left: 0px; padding-right: 0px;\">\n" +
        "                            <span class=\"glyphicon glyphicon-minus\" title=\"删除该文件\"></span>\n" +
        "                        </div>\n" +
        "                        <div class=\"input-group-addon\" style=\"padding-left: 0px; padding-right: 0px;\">\n" +
        "                            <span class=\"glyphicon glyphicon-plus\" title=\"更多文件\"></span>\n" +
        "                        </div>\n" +
        "                    </div>\n" +
        "                    <div class=\"col-sm-1\"></div>\n" +
        "                </div>\n" +
        "            </div>";

    /**
     *浏览选择文件
     */
    $("body").on('click', '.choose-file', function () {
        var tmp_inputfile = $(this).closest('.form-group').prev('input');
        var tmp_showfile = $(this).closest('.file-module').find('.show-file');
        tmp_inputfile.click();
        $(tmp_inputfile).change(function () {
            document.getElementById($(tmp_showfile).attr("id")).value = tmp_inputfile.val();
        });
    })

    /**
     *添加选择文件选项
     */
    $("body").on('click', '.glyphicon-plus', function () {
        fileNumber = fileNumber + 1;
        $('#filesForm')/*.children()*/.append(txt);
        $('.show-file').last().attr("id", "show-file:"+ fileNumber);
    });

    /**
     *删除文件
     */
    $("body").on('click', '.glyphicon-minus', function () {
            $(this).closest('.file-module').remove();
    });

    /**
     *提交参数表单（需验证登录）——ajax formdata
     */
    $('#submit').click(function () {
        //var formdata = new FormData(document.getElementById("submitForm"));
        if(user != null && user != undefined){
            $.ajax({
                type: "POST",
                url: "/dosubmitargs",
                data: $('#submitForm').serialize(),
                cache: "false",
                error: function (request) {
                    alert("Connection error");
                },
                success: function (data) {
                    alert(data);
                    $('#submitForm')[0].reset();
                    $('#argsform')[0].reset();
                    $('#myModal').modal('hide');l
                }
            });
        } else {
            alert("页面已过期，请重新登录！");
        }
    });

    /**
     *提交文件表单（需验证登录）——ajax formdata
     */
    $('#filesSubmit').click(function () {
        var formdata = new FormData(document.getElementById("filesForm"));

        //自动生成作业名称jobName; 如： admin:20180409123443    用户ID:当前时间
        var date = new Date();
        this.year = date.getFullYear();
        this.month = (date.getMonth() + 1) < 10 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1);
        this.date = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
        this.hour = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
        this.minute = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
        this.second = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
        var currentTime = "" + this.year + this.month + this.date + this.hour + this.minute + this.second;
        var jobName = user+ "_" + currentTime;

        formdata.append("jobName", jobName);
        if(user != null && user != undefined){
            $.ajax({
                type: "POST",
                url: "/dosubmitfile",
                data: formdata,
                async: "true",
                cache: "false",
                contentType: false,
                processData: false,
                error: function (request) {
                    alert("Connection error");
                },
                success: function (data) {
                    $('#filesForm')[0].reset();
                    alert('提交成功！');
                }
            });
        } else {
            alert("页面已过期，请重新登录！");
        }
    });

    var map;
    var myrect = new AMap.Rectangle();
    var once = true;
    var drawListener;
    //框选按钮
    var rectangle = document.getElementById("btn1");
    var confirm = document.getElementById("btn3");
    //最大、小经纬度输入框
    var args1 = document.getElementById("minlon");
    var args2 = document.getElementById("minlat");
    var args3 = document.getElementById("maxlon");
    var args4 = document.getElementById("maxlat");
    //步长输入框
    var argsStepLength = document.getElementById("step_length");
    //中央经纬度
    var args5 = document.getElementById("cenlon");
    var args6 = document.getElementById("cenlat");
    //地图图层
    var satelliteLayer = new AMap.TileLayer.Satellite();
    var roadnetLayer = new AMap.TileLayer.RoadNet();
    var defaultRectOpt = {
        strokeStyle: "solid",
        strokeColor: "#efe700",
        fillColor: "#ffffff",
        fillOpacity: 0.0,
        strokeOpacity: 1,
        strokeWeight: 2
    }
    var editRectOpt = {
        strokeStyle: "dashed",
        strokeColor: "#efe700",
        fillColor: "#ffffff",
        fillOpacity: 0.0,
        strokeOpacity: 1,
        strokeWeight: 2
    }

    map = new AMap.Map('mapcontainer',{
        zoom: 4,
        layers:[satelliteLayer,roadnetLayer],
        center: [116.39,39.9]//new AMap.LngLat(116.39,39.9)
    });
    map.plugin(["AMap.Scale"],function () {
        var scale = new AMap.Scale({
            position:'LB'
        });
        map.addControl(scale);
    });

    var mouseTool = new AMap.MouseTool(map);
    //添加画图事件
    AMap.event.addDomListener(rectangle, 'click',function () {
        mouseTool.rectangle(editRectOpt);
        map.setDefaultCursor("crosshair");
        map.clearMap();
        disableInput();
        drawListener =  AMap.event.addListener(mouseTool,'draw',function(e){
            if(! once){
                overlays = map.getAllOverlays();
                overlays.slice(0,(overlays.length - 1)).forEach(function (item) {
                    map.remove(item);
                });
            }else{
                once = false;
            }
        });
    }, false);

    //添加确认区域事件
    AMap.event.addDomListener(confirm,'click',function () {
        map.setDefaultCursor("pointer");
        AMap.event.removeListener(drawListener);
        result = map.getAllOverlays()[0];
        mouseTool.close(true);
        result.setOptions(defaultRectOpt);
        map.add(result);
        setInputArgs(result.getBounds());
        once = true;
        enableInput();
        $('#btngroup').toggleClass('in');
    },false);

    function drawRecByInput(){
        southWest = new AMap.LngLat(parseFloat(args1.value),parseFloat(args2.value));
        northEast = new AMap.LngLat(parseFloat(args3.value),parseFloat(args4.value));
        mybounds = new AMap.Bounds(southWest,northEast);
        array = map.getAllOverlays();
        if(array.length == 0){
            myrect.setBounds(mybounds);
            myrect.setOptions(defaultRectOpt);
            myrect.setMap(map);
        }else{
            map.clearMap();
            myrect.setBounds(mybounds);
            myrect.setOptions(defaultRectOpt);
            myrect.setMap(map);
        }

    }

    args1.oninput = function (ev) { drawRecByInput() };
    args2.oninput = function (ev) { drawRecByInput() };
    args3.oninput = function (ev) { drawRecByInput() };
    args4.oninput = function (ev) { drawRecByInput() };

    function disableInput(){
        args1.readOnly = true;
        args2.readOnly = true;
        args3.readOnly = true;
        args4.readOnly = true;
    }

    function enableInput(){
        args1.readOnly = false;
        args2.readOnly = false;
        args3.readOnly = false;
        args4.readOnly = false;
    }

    function setInputArgs(bounds){
        args1.value = bounds.getSouthWest().getLng().toFixed(2);
        args2.value = bounds.getSouthWest().getLat().toFixed(2);
        args3.value = bounds.getNorthEast().getLng().toFixed(2);
        args4.value = bounds.getNorthEast().getLat().toFixed(2);
        args5.value = bounds.getCenter().getLng().toFixed(2);
        args6.value = bounds.getCenter().getLat().toFixed(2);
    }


    $('#start-time').datetimepicker({
        timeText: '时间',
        hourText: '小时',
        minuteText: '分钟',
        currentText: '现在',
        closeText: '完成',
        dateFormat:'yy-mm-dd',//格式化日期
        timeFormat: 'HH:mm' //格式化时间
    });
    $('#end-time').datetimepicker({
        timeText: '时间',
        hourText: '小时',
        minuteText: '分钟',
        currentText: '现在',
        closeText: '完成',
        dateFormat:'yy-mm-dd',//格式化日期
        timeFormat: 'HH:mm' //格式化时间
    });

    $('#nextstep').on('click',function () {
        if(user == null || user == ""){
            alert('页面已过期请重新登录。');
            location.href = "/login";
        }
        var start = $('#start-time').val();
        var end = $('#end-time').val();
        if(checkTime(start,end)){
            //自动生成作业名称jobName; 如： admin:20180409123443    用户ID:当前时间
            var date = new Date();
            this.year = date.getFullYear();
            this.month = (date.getMonth() + 1) < 10 ? "0" + (date.getMonth() + 1) : (date.getMonth() + 1);
            this.date = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
            this.hour = date.getHours() < 10 ? "0" + date.getHours() : date.getHours();
            this.minute = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
            this.second = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
            var currentTime = "" + this.year + this.month + this.date + this.hour + this.minute + this.second;
            var jobName = user+ ":" + currentTime;

            document.getElementById('jobName').value = jobName;
            document.getElementById('m_minlon').value = args1.value;
            document.getElementById('m_maxlon').value = args3.value;
            document.getElementById('m_minlat').value = args2.value;
            document.getElementById('m_maxlat').value = args4.value;
            document.getElementById('m_cenlon').value = args5.value;
            document.getElementById('m_cenlat').value = args6.value;
            document.getElementById('m_start-time').value = $('#start-time').val();
            document.getElementById('m_end-time').value = $('#end-time').val();
            document.getElementById('m_step_length').value = argsStepLength.value;
            $('#myModal').modal('show');
        }else{
            alert('结束时间小于开始时间，请检查参数。');
        }

    });

    //让模态框居中
    $('#myModal').on('show.bs.modal', function (e) {
        // 关键代码，如没将modal设置为 block，则$modala_dialog.height() 为零
        $(this).css('display', 'block');
        var modalHeight=$(window).height() / 2 - $('#myModal .modal-dialog').height() / 2;
        $(this).find('.modal-dialog').css({
            'margin-top': modalHeight
        });
    });

    function str2Date(str){
        var val=Date.parse(str);
        var newDate=new Date(val);
        return newDate;
    }

    function checkTime(start ,end){
        if(start != "" && end != ""){
            var starttime = str2Date(start);
            var endtime = str2Date(end);
            if(endtime < starttime){
                return false;
            }else{
                return true;
            }
        }else{
            //alert("请选择日期。");
            return false
        }
    }
</script>
</body>
</html>
