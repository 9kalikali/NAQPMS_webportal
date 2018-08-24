<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/1/23
  Time: 12:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>WelcomePage</title>
    <!-- 相关的CSS文件 -->
    <link rel="stylesheet" href="/css/common.css">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!-- jQueryUI DateTimepicker -->
    <script src="/js/jquery-ui.min.js"></script>
    <link href="/css/jquery-ui.min.css" rel="stylesheet" />
    <script src="/jQuery-Timepicker/jquery-ui-timepicker-addon.min.js"></script>
    <script type="text/javascript" src="/jQuery-Timepicker/i18n/jquery-ui-timepicker-zh-CN.js"></script>
    <link href="/jQuery-Timepicker/jquery-ui-timepicker-addon.min.css" rel="stylesheet" />
    <!-- jqueryBanner -->
    <script src="/js/jquery.scrollBanner.js" type="text/javascript"></script>
    <!-- Bootstrap-table表格插件--->
    <link rel="stylesheet" href="/bootstrap-table-master/bootstrap-table.css">
    <script src="/bootstrap-table-master/bootstrap-table.js"></script>
    <script src="/bootstrap-table-master/bootstrap-table-zh-CN.js"></script>

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
                }
            });
        };
        function checkLogin() {
            var user=getCookie("userid");
            if (user != null && user != ""){
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
            loadPage("/welcome");
            checkLogin();
        });
    </script>
</head>
<body>
<!-- 标题栏 -->
<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0px">
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
<!-- 副标题 -->
<div class="subhead">
    <img src="/images/subhead.png">
</div>
<!-- 导航栏 -->
<div class="navi_body">
    <div class="navi_head">
        <div style="width:100%; margin-left:200px; margin-right:auto;">
            <span>
                <p class="navi_title"><a onclick="loadPage('/welcome')">首&nbsp;&nbsp;&nbsp;&nbsp;页</a></p>
            </span>
            <span>
                <p class="navi_title" onclick="checkUser(recid)">计算服务</p>
            </span>
            <span>
                <p class="navi_title" onclick="loadPage('/download')">数据共享</p>
            </span>
            <span>
                <p class="navi_title">在线展示</p>
                <p><a onclick="loadPage('/datadisplay')">数据展示</a></p>
                <p><a onclick="self.location='/webgisdisplay'">综合展示</a></p>
            </span>
            <span>
                <p class="navi_title">用户支持</p>
                <p><a onclick="loadPage('/tutorial')">入门指南</a></p>
                <p><a onclick="self.location='/platforminfo/more/newslist_0'">文章公告</a></p>
            </span>
            <span>
                <p class="navi_title" onclick="loadPage('/aboutus')">关于我们</p>
            </span>
        </div>
    </div>
</div>

<!-- Content! -->
<div id="content" class="maincontent">

</div>

<!-- footer! -->
<footer class="navbar navbar-default navbar-fixde-bottom" style="margin-bottom: 0px;border-radius: 0px;border: 0px">
    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-5" style="padding-left: 15px">
                <div>
                    <p class="navbar-text" style="margin-top: 5px; margin-bottom: 5px">中国的新一代信息技术平台&nbsp;&nbsp;&nbsp;&nbsp;大气污染模式在线交互式系统</p>
                </div>
                <div>
                    <p class="navbar-text" style="margin-top: 5px; margin-bottom: 5px">版权所有：中国科学院计算机网络信息中心&nbsp;&nbsp;&nbsp;&nbsp;备案序号：京ICP备xxxxxxxx-xx</p>
                </div>
            </div>
            <div class="col-xs-7">
                <span class="navbar-text navbar-right" style="padding-right: 15px">电话：xxx-xxxxxxxx&nbsp;&nbsp;&nbsp;&nbsp;邮箱：xxxx@cnic.cn</span>
            </div>
        </div>
    </div>
</footer>

<script>
    function loadDownloadPage(url) {
        var xmlHttp;

        if (window.XMLHttpRequest) {
            // code for IE7+, Firefox, Chrome, Opera, Safari
            xmlHttp=new XMLHttpRequest();    //创建 XMLHttpRequest对象
        }
        else {
            // code for IE6, IE5
            xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
        }

        xmlHttp.onreadystatechange=function() {
            //onreadystatechange — 当readystate变化时调用后面的方法

            if (xmlHttp.readyState == 4) {
                //xmlHttp.readyState == 4    ——    finished downloading response

                if (xmlHttp.status == 200) {
                    //xmlHttp.status == 200        ——    服务器反馈正常

                    document.getElementById("download_content").innerHTML=xmlHttp.responseText;    //重设页面中id="content"的div里的内容
                    executeScript(xmlHttp.responseText);    //执行从服务器返回的页面内容里包含的JavaScript函数
                }
                //错误状态处理
                else if (xmlHttp.status == 404){
                    alert("出错了!   （错误代码：404 Not Found），……！");
                    /* 对404的处理 */
                    return;
                }
                else if (xmlHttp.status == 403) {
                    alert("出错了!   （错误代码：403 Forbidden），……");
                    /* 对403的处理  */
                    return;
                }
                else {
                    alert("出错了!   （错误代码：" + request.status + "），……");
                    /* 对出现了其他错误代码所示错误的处理   */
                    return;
                }
            }

        }

        //把请求发送到服务器上的指定文件（url指向的文件）进行处理
        xmlHttp.open("GET", url, true);        //true表示异步处理
        xmlHttp.send();
    }
    //解决页面含有javascript的问题
    function executeScript(html) {

        var reg = /<script[^>]*>([^\x00]+)$/i;
        //对整段HTML片段按<\/script>拆分
        var htmlBlock = html.split("<\/script>");
        for (var i in htmlBlock)
        {
            var blocks;//匹配正则表达式的内容数组，blocks[1]就是真正的一段脚本内容，因为前面reg定义我们用了括号进行了捕获分组
            if (blocks = htmlBlock[i].match(reg))
            {
                //清除可能存在的注释标记，对于注释结尾-->可以忽略处理，eval一样能正常工作
                var code = blocks[1].replace(/<!--/, '');
                try
                {
                    eval(code) //执行脚本
                }
                catch (e)
                {
                }
            }
        }
    }
    //点击显示相应页面
    function loadPage(url) {
        var xmlHttp;

        if (window.XMLHttpRequest) {
            // code for IE7+, Firefox, Chrome, Opera, Safari
            xmlHttp=new XMLHttpRequest();    //创建 XMLHttpRequest对象
        }
        else {
            // code for IE6, IE5
            xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
        }

        xmlHttp.onreadystatechange=function() {
            //onreadystatechange — 当readystate变化时调用后面的方法

            if (xmlHttp.readyState == 4) {
                //xmlHttp.readyState == 4    ——    finished downloading response

                if (xmlHttp.status == 200) {
                    //xmlHttp.status == 200        ——    服务器反馈正常

                    document.getElementById("content").innerHTML=xmlHttp.responseText;    //重设页面中id="content"的div里的内容
                    executeScript(xmlHttp.responseText);    //执行从服务器返回的页面内容里包含的JavaScript函数
                }
                //错误状态处理
                else if (xmlHttp.status == 404){
                    alert("出错了!   （错误代码：404 Not Found），……！");
                    /* 对404的处理 */
                    return;
                }
                else if (xmlHttp.status == 403) {
                    alert("出错了!   （错误代码：403 Forbidden），……");
                    /* 对403的处理  */
                    return;
                }
                else {
                    alert("出错了!   （错误代码：" + request.status + "），……");
                    /* 对出现了其他错误代码所示错误的处理   */
                    return;
                }
            }

        }

        //把请求发送到服务器上的指定文件（url指向的文件）进行处理
        xmlHttp.open("GET", url, true);        //true表示异步处理
        xmlHttp.send();
    }

    function checkUser(user){
        console.log(user);
        if(user == null || user == "" || user == undefined){
            location.href = '/login';
        }else{
            location.href = '/jobsubmit';
        }
    }

    //*****************图片源的设置*******************//
    modImages = new Array();
    first_image = 0;
    last_image = 0;

    function setModImages(imgList){
        //清空数组
        modImages.splice(0,modImages.length);
        theImages.splice(0,theImages.length);
        imageNum.splice(0,imageNum.length);
        //将数据转化为json
        var list = JSON.parse(imgList);
        for(var i = 0;i < list.length; i++){
            modImages.push(list[i]);
        }
        //对first和last重新赋值
        first_image = 0;
        last_image = modImages.length - 1;
        curImage = first_image;
        //预加载
        if(first_image > last_image){
            var temp = first_image;
            first_image = last_image;
            last_image = temp;
        }
        theImages[0] = new Image();
        theImages[0].src = modImages[0];
        imageNum[0] = true;
    }
    //=================ImagePlayer代码====================

    //全局变量
    theImages = new Array();
    imageNum = new Array();
    default_delay = 300; //默认播放间隔300ms
    delay_step = 150;
    delay_max = 6000;
    delay_min = 50;
    dwell_multipler = 3;
    dwell_step = 1;

    delay = default_delay;
    end_dwellMultipler = dwell_multipler;
    start_dewellMultipler = dwell_multipler;
    curImage = first_image;
    timeID = null;
    status = 0;     //0---停止；1---播放
    playMode = 0;  //0----正常；1----循环；2----快进
    sizeValid = 0;

    if(first_image > last_image){
        var temp = first_image;
        first_image = last_image;
        last_image = temp;
    }
    /**
     * 预加载第一张图片
     * @type {HTMLImageElement}
     */
    theImages[0] = new Image();
    theImages[0].src = modImages[0];
    imageNum[0] = true;

    /**
     * 停止播放
     */
    function stop() {
        if(status == 1){
            clearTimeout(timeID);
        }
        status = 0;
    }

    /**
     * 顺序播放图片
     */
    function animate_fwd(){
        curImage++;
        //判断当前是否播放到最后一张图片
        if(curImage > last_image){
            if(playMode == 1){
                curImage = first_image;
            }
            if(playMode == 2){
                curImage = last_image;
                animate_rev();
                return;
            }
        }

        while(imageNum[curImage - first_image] == false){
            curImage++;
            if(curImage > last_image){
                if(playMode == 1){
                    curImage = first_image;
                }
                if(playMode == 2){
                    curImage = last_image;
                    animate_rev();
                    return;
                }
            }
        }
        //替换图片源
        document.animation.src = theImages[curImage - first_image].src;
        //设置播放间隔
        delay_time = delay;
        if(curImage == first_image)
            delay_time = start_dewellMultipler * delay;
        if(curImage == last_image)
            delay_time = end_dwellMultipler * delay;
        //播放动画
        timeID = setTimeout("animate_fwd()", delay_time);
    }

    /**
     * 倒序播放动画
     */
    function animate_rev(){
        curImage--;

        if(curImage < first_image){
            if(playMode == 1){
                curImage = last_image;
            }
            if(playMode == 2){
                curImage == first_image;
                animate_fwd();
                return;
            }
        }

        while(imageNum[curImage - first_image] == false){
            curImage--;
            if (curImage < first_image) {
                if (play_mode == 1)
                    curImage = last_image;
                if (play_mode == 2) {
                    curImage = first_image;
                    animate_fwd();
                    return;
                }
            }
        }

        //替换图片源
        document.animation.src = theImages[curImage - first_image].src;
        //设置播放间隔
        delay_time = delay;
        if ( current_image == first_image) delay_time = start_dwell_multipler*delay;
        if (current_image == last_image)   delay_time = end_dwell_multipler*delay;

        timeID = setTimeout("animate_rev()", delay_time);
    }

    /**
     * 改变播放速度
     * @param ds
     */
    function change_speed(ds) {
        delay += ds;
        if(delay > delay_max)
            delay = delay_max;
        if(delay < delay_min)
            delay = delay_min;
    }

    /**
     * 改变停留时间
     * @param dv
     */
    function change_end_dwell(ds){
        end_dwellMultipler += ds;
        if(end_dwellMultipler < 1)
            end_dwellMultipler = 0;
    }

    function change_start_dwell(ds){
        start_dewellMultipler += ds;
        if(start_dewellMultipler < 1)
            start_dewellMultipler = 0;
    }

    /**
     * 手动播放下一帧
     * @param number
     */
    function manualIncrement(number) {
        stop();
        if(number > last_image)
            number = first_image;
        while(imageNum[number - first_image] == false){
            number++;
            if(number > last_image)
                number = first_image;
        }

        curImage = number;
        document.animation.src = theImages[curImage - first_image].src;
    }

    /**
     * 手动播放上一帧
     * @param number
     */
    function manualDecrement(number){
        stop();
        if(number < first_image)
            number = last_image;
        while(imageNum[number - first_image] == false){
            number--;
            if(number < first_image)
                number = last_image;
        }

        curImage = number;
        document.animation.src = theImages[curImage - first_image].src;
    }

    function playFwd(){
        stop();
        status = 1;
        playMode = 1;
        animate_fwd();
    }

    function playRev(){
        stop();
        status = 1;
        playMode = 1;
        animate_rev();
    }

    function playSweep(){
        stop();
        status = 1;
        playMode = 2;
        animate_fwd();
    }

    function changeMode(mode) {
        playMode = mode;
    }

    function launch() {
        for(var i = first_image + 1; i <= last_image; i++){
            theImages[i - first_image] = new Image();
            theImages[i - first_image].src = modImages[i-first_image];
            imageNum[i-first_image] = true;
            document.animation.src = theImages[i-first_image].src;
        }
        changeMode(1);
        playFwd();
    }

</script>
</body>
</html>
