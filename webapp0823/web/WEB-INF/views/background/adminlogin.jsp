<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/19
  Time: 13:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="UTF-8">
    <title>管理员登陆</title>
    <!-- 自定义的CSS文件 -->
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="/css/verifycode.css">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!-- 验证码js -->
    <script src="/js/verify.js"></script>
    <script>
        $(document).ready(function () {
            var msg = "${errmsg.toString()}"
            if(msg != null && msg == "fail" &&  "" != msg){
                //alert("msg="+msg);
                $('.lginalert-default').css('display','block');
            }
        });
    </script>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="/">后台管理</a>
            </div>
            <div>
                <p class="navbar-text">管理员登录</p>
            </div>
        </div>
    </nav>

    <div class="container-fluid" style="margin-top: 13%">
        <div class="row">
            <div class="col-md-4 col-md-offset-3 login-left">
                <b style="font-size: x-large;">欢迎来到后台管理页面</b><br>
                <p style="font-size: large">管理员登陆后可以对用户信息、计算任务、</p>
                <p style="font-size: large">  平台信息等进行相应的操作</p>
            </div>
            <div class="col-md-3 center-border">
                <div id="lgin-alert" class="alert alert-danger alert-dismissable lginalert-default">
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                    <strong>登录失败!</strong> 账号或密码错误。
                </div>
                <form:form action="/admin/dologin" id="lgin-form" method="post" modelAttribute="admin" role="form">
                    <div class="form-group">
                        <span class="glyphicon glyphicon-user" style="margin-bottom: 10px; font-size: large"><b>账号：</b></span>
                        <form:input path="adminid" type="text" class="form-control" placeholder="Account"/>
                    </div>
                    <br>
                    <div class="form-group">
                        <span class="glyphicon glyphicon-lock" style="margin-bottom: 10px; font-size: large"><b>密码：</b></span>
                        <form:input path="adminpassword" type="password" class="form-control" placeholder="Password"/>
                    </div>
                    <br>
                    <!-- 验证码 -->
                    <div id="mpanel2"></div>
                    <br>
                    <div class="form-group">
                        <button id="btn-lgin" type="button" class="btn btn-block btn-primary">登陆</button>
                    </div>
                    <br>
                </form:form>
            </div>
        </div>

    </div>


    <!-- footer -->
    <footer class="navbar navbar-inverse navbar-fixed-bottom" >
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
        $('#mpanel2').codeVerify({
            type : 1,
            width : '100px',
            height : '40px',
            fontSize : '20px',
            codeLength : 4,
            btnId : 'btn-lgin',
            ready : function() {
            },
            success : function() {
                $('#lgin-form').submit();
                //alert('验证码匹配！');
            },
            error : function() {
                alert('验证码不匹配！');
            }
        });
    </script>
</body>
</html>
