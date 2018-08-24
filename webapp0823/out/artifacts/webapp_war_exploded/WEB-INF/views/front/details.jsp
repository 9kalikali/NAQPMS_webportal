<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/6
  Time: 10:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>文章页面</title>
    <!-- 相关的CSS文件 -->
    <link rel="stylesheet" href="/css/common.css">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/mdeditor/css/editormd.min.css">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!-- 返回顶部插件 -->
    <script src="/js/jquery.scrollUp.min.js"></script>

    <script src="/mdeditor/lib/marked.min.js"></script>
    <script src="/mdeditor/lib/prettify.min.js"></script>
    <script src="/mdeditor/lib/raphael.min.js"></script>
    <script src="/mdeditor/lib/underscore.min.js"></script>
    <script src="/mdeditor/lib/sequence-diagram.min.js"></script>
    <script src="/mdeditor/lib/flowchart.min.js"></script>
    <script src="/mdeditor/lib/jquery.flowchart.min.js"></script>
    <script src="/mdeditor/editormd.min.js"></script>

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
            var user=getCookie("userid");
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

    <div class="container" style="padding-top: 2%">
        <div class="row">
            <div class="col-sm-6 col-sm-offset-3">
                <!-- 标题 -->
                <h1 class="text-center">${detail.title}</h1><br>
                <small class="col-sm-offset-3">作者：${detail.author}</small>
                <small>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;发布时间：${detail.datetime}</small>
                <c:if test='${type.equals("article")}'>
                    <small>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;浏览量：${detail.views}</small>
                </c:if>
            </div>
        </div>
        <div class="row">
            <div id="doc-content" class="col-md-10 col-md-offset-1">
                <!-- 转换的html在这里显示 -->
                <textarea id="htmlview" style="display: none">${detail.content}</textarea>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        var testEditorView;
        $(function () {
            testEditorView = editormd.markdownToHTML("doc-content", {
                htmlDecode: "style,script,iframe",
                emoji: true,
                taskList: true,
                tex: true, // 默认不解析
                flowChart: true, // 默认不解析
                sequenceDiagram: true, // 默认不解析
                codeFold: true,
            });

            $.scrollUp({
                animation: 'fade',
                activeOverlay: '#00FFFF',
                scrollImg: {
                    active: true,
                    type: 'background',
                    src: 'images/top.png'
                }
            });
        });
    </script>
</body>
</html>
