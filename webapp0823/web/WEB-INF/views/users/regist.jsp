<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/1/30
  Time: 16:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="UTF-8">
    <title>新用户注册</title>
    <!-- 自定义的CSS文件 -->
    <link rel="stylesheet" href="../css/common.css">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <!-- 表单验证插件 -->
    <script src="/js/validator/jquery.validate.min.js"></script>
    <script src="/js/validator/localization/messages_zh.js"></script>
    <script>
        $(document).ready(function () {
           var msg = "${errmsg.toString()}";
           if(msg != null && msg != undefined && msg == "fail"){
               alert("发生未知错误！注册失败。");
           }
        });
        $().ready(function () {
            $('#rgst-form').validate({
                rules:{
                    userid:{
                        required:true,
                        minlength:2,
                        remote:"/user/checkuserid"
                    },
                    pwd:{
                        required:true,
                        minlength:5
                    },
                    confirm_pwd:{
                        required:true,
                        minlength:5,
                        equalTo:"#pwd"
                    },
                    email:{
                        required:true,
                        email:true,
                        remote:"/user/checkemail"
                    }
                },
                messages:{
                    userid:{
                        remote:"该用户名已存在。"
                    },
                    email:{
                        remote:"该邮箱已被注册。"
                    },
                    pwd: {
                        required: "请输入密码",
                        minlength: "密码长度不能小于 5 个字母"
                    },
                    confirm_pwd: {
                        required: "请输入密码",
                        minlength: "密码长度不能小于 5 个字母",
                        equalTo: "两次密码输入不一致"
                    }
                }
            });
        });
    </script>
</head>
<body>
    <!-- 导航栏 -->
    <nav class="navbar navbar-default navbar-static-top" role="navigation">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="/">NAQPMS在线交互</a>
            </div>
            <div>
                <p class="navbar-text">用户注册</p>
            </div>
        </div>
    </nav>

    <div class="container-fluid" style="margin: auto">
        <div class="row">
            <h3 class="text-center" style="margin-bottom: 2%">新用户注册</h3>
            <div class="col-xs-9 col-md-offset-2">
                <form:form id="rgst-form" action="/user/doregist" method="post" modelAttribute="user" role="form" class="form-horizontal col-md-offset-3">
                    <div class="form-group">
                        <label class="col-xs-2 control-label">用户账号：</label>
                        <div class="col-xs-4">
                            <form:input path="userid" id="userid" name="userid" type="text" cssClass="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-2 control-label">密码：</label>
                        <div class="col-xs-4">
                            <form:input path="password" id="pwd" name="pwd" type="password" cssClass="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-2 control-label">确认密码：</label>
                        <div class="col-xs-4">
                            <input path="" id="confirm_pwd" name="confirm_pwd" type="password" class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-2 control-label">姓名：</label>
                        <div class="col-xs-4">
                            <form:input path="username" id="username" name="username" type="text" cssClass="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-2 control-label">E-mail：</label>
                        <div class="col-xs-4">
                            <form:input path="email" id="email" name="email" type="text" cssClass="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-2 control-label">联系电话：</label>
                        <div class="col-xs-4">
                            <form:input path="phonenum" id="phonenum" name="phonenum" type="text" cssClass="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-2 control-label">工作单位：</label>
                        <div class="col-xs-4">
                            <form:input path="company" id="company" name="company" type="text" cssClass="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-2 control-label">职位：</label>
                        <div class="col-xs-4">
                            <form:input path="position" id="position" name="position" type="text" cssClass="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary col-md-offset-2">提交</button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>

    <!-- footer -->
    <footer class="navbar navbar-default navbar-fixed-bottom" style="margin-top: 10%; margin-bottom: 0px;border-radius: 0px;border: 0px">
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
</body>
</html>
