<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/26
  Time: 9:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>管理员注册</title>
    <meta charset="UTF-8">
    <script>
        $().ready(function () {
           $('#add-form').validate({
               rules:{
                   adminid:{
                     required:true
                   },
                   adminpassword:{
                       required:true,
                       minlength:5
                   },
                   confirm_pwd:{
                       required:true,
                       minlength:5,
                       equalTo:'#adminpassword'
                   }
               },
               messages:{
                   adminpassword: {
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
    <div class="container-fluid">
        <div class="row">
            <h3 style="margin-bottom: 5%;padding-left: 35%">添加新管理员</h3>
            <div class="col-xs-9">
                <form:form id="add-form" modelAttribute="admin" role="form" class="form-horizontal col-md-offset-1">
                    <div class="form-group">
                        <label class="col-xs-4 control-label">管理员账号：</label>
                        <div class="col-xs-6">
                            <form:input path="adminid" id="adminid" name="adminid" type="text" cssClass="form-control" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-4 control-label">密码：</label>
                        <div class="col-xs-6">
                            <form:input path="adminpassword" id="adminpassword" name="adminpassword" type="password" cssClass="form-control"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-4 control-label">确认密码：</label>
                        <div class="col-xs-6">
                            <input id="confirm_pwd" name="confirm_pwd" type="password" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-4 control-label">设置权限：</label>
                        <div class="col-xs-6">
                            <form:select path="priority" id="priority" name="priority" cssClass="form-control">
                                <form:option value="0">超级管理员</form:option>
                                <form:option value="1">普通管理员</form:option>
                                <form:option value="2">次级管理员</form:option>
                            </form:select>
                        </div>
                    </div>
                    <div class="form-group">
                        <button id="btnsubmit" type="submit" class="btn btn-primary col-md-offset-6">提交</button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>

    <script>
        $('#add-form').on('submit',function(){
            $.ajax({
                type:'post',
                data:$('#add-form').serialize(),
                url:'/admin/doregistadmin',
                cache:false,
                success:function (data) {
                    if('success' == data){
                        alert('添加成功！');
                        //loadPage('/user/admin/userlist');
                    }else{
                        alert('添加失败！');
                    }
                }
            });
            return false;
        });
    </script>
</body>
</html>
