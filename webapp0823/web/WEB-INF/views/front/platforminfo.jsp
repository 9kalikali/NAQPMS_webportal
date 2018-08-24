<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/1
  Time: 9:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>文章公告</title>
    <!-- 相关的CSS文件 -->
    <link rel="stylesheet" href="/css/common.css">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!-- 分页控件 -->
    <script src="/js/jqPaginator.min.js"></script>
    <script src="/js/jqPaginator.js"></script>

    <script>
        function switchNav(infotype) {
            switch (infotype){
                case "newslist":
                    $('#news').addClass("active");
                    $('#article').removeClass("active");
                    $('#question').removeClass("active");
                    break;
                case "articlelist":
                    $('#news').removeClass("active");
                    $('#article').addClass("active");
                    $('#question').removeClass("active");
                    break
                case "questionlist":
                    $('#news').removeClass("active");
                    $('#article').removeClass("active");
                    $('#question').addClass("active");
                    break;
            }
        }
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
            if (user != "" && user != "none"){
                //alert("欢迎 " + user + " 访问");
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
            loadPage("/platforminfo/${infoType}/${para}")
            checkLogin();
            switchNav("${infoType}");
        })
    </script>

    <style>
    /*CustomStyle*/
    ul.nav-tabs{
        border-radius: 4px;
        border: 1px solid #ddd;
        box-shadow: 0 1px 4px rgba(0, 0, 0, 0.067);
    }
    ul.nav-tabs li{
        margin: 0;
        border-top: 1px solid #ddd;
    }
    ul.nav-tabs li:first-child{
        border-top: none;
    }
    ul.nav-tabs li a{
        margin: 0;
        padding: 8px 16px;
        border-radius: 0;
    }
    ul.nav-tabs li.active a{
        color: #fff;
        background: #0088cc;
        border: 1px solid #0088cc;
    }
    ul.nav-tabs li:first-child a{
        border-radius: 4px 4px 0 0;
    }
    ul.nav-tabs li:last-child a{
        border-radius: 0 0 4px 4px;
    }
    </style>
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

    <div class="container" style="min-height: 768px">
        <div class="row">
            <div class="col-md-2 col-md-offset-1">
                <h3>文章公告</h3>
            </div>
            <div class="col-md-7" style="padding-top: 15px">
                <ol class="breadcrumb">
                    <li>文章公告</li>
                    <li>新闻公告</li>
                    <li class="active">文章列表</li>
                </ol>
            </div>
        </div>
        <div class="row" style="padding-bottom: 15%">
            <div class="col-md-2 col-md-offset-1">
                <ul class="nav nav-tabs nav-pills nav-stacked">
                    <li id="news" class="active"><a data-toggle="tab" onclick="loadPage('/platforminfo/newslist/0')">新闻公告</a></li>
                    <li id="article"><a data-toggle="tab" onclick="loadPage('/platforminfo/articlelist/0')">专题文章</a></li>
                    <li id="question"><a data-toggle="tab" onclick="loadPage('/platforminfo/questionlist/0')">常见问题</a></li>
                </ul>
            </div>
            <div class="col-md-7">
                <div class="panel panel-default">
                    <div id="infolist" class="panel-body">

                    </div>
                </div>
            </div>
        </div>
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

                        document.getElementById("infolist").innerHTML=xmlHttp.responseText;    //重设页面中id="content"的div里的内容
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
    </script>
</body>
</html>
