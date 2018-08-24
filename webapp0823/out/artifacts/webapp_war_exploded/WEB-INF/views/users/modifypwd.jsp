<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/14
  Time: 8:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>更改密码</title>
    <script>
        $().ready(function () {
           $('#pwd-form').validate({
               rules:{
                   newpwd:{
                       required:true,
                       minlength:5
                   },
                   confirm_pwd:{
                       required:true,
                       minlength:5,
                       equalTo:'#newpwd'
                   }
               },
               messages:{
                   newpwd: {
                       required: "请输入密码",
                       minlength: "密码长度不能小于 5 个字母"
                   },
                   confirm_pwd: {
                       required: "请输入密码",
                       minlength: "密码长度不能小于 5 个字母",
                       equalTo: "两次密码输入不一致"
                   }
               }
           }) ;
        });
    </script>
</head>
<body>
    <div class="container-fluid" style="padding-top: 10%">
        <div class="row">
            <h3 style="margin-bottom: 5%;padding-left: 35%">更改密码</h3>
            <div class="col-xs-9">
                <form id="pwd-form" role="form" class="form-horizontal col-md-offset-1">
                    <div class="form-group">
                        <label class="col-xs-4 control-label">旧密码：</label>
                        <div class="col-xs-6">
                            <input id="oldpwd" name="oldpwd" type="password" class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-4 control-label">新密码：</label>
                        <div class="col-xs-6">
                            <input path="" id="newpwd" name="newpwd" type="password" class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-4 control-label">确认密码：</label>
                        <div class="col-xs-6">
                            <input id="confirm_pwd" name="confirm_pwd" type="password" class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary col-md-offset-6">提交更改</button>
                    </div>
                </form>
            </div>
        </div>
    </div>


    <script>
        $('#pwd-form').on('submit',function () {
            $.ajax({
                type: 'post',
                data: $('#pwd-form').serialize(),
                url: '/user/domodifypwd/${userid}',
                cache: false,
                success: function (data) {
                    if ("success" == data) {
                        alert("修改成功");
                        window.location.href = '/login'
                    }
                    if ("fail" == data){
                        alert("修改失败");
                    }
                    if("none" == data){
                        alert("旧密码错误")
                    }
                }
            });
            return false;
        });
    </script>
</body>
</html>
