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
    <title>编辑用户信息</title>
    <script>

        $().ready(function(){
           $('#email').on('input',function(){
               $('#update-form').validate({
                   rules:{
                       email:{
                           required:true,
                           email:true,
                           remote:'/user/checkemail'
                       }
                   },
                   messages:{
                       email:{
                           remote:'该邮箱已被注册'
                       }
                   }
               });
           });
        });

    </script>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <h3 style="margin-bottom: 5%;padding-left: 35%">更改用户信息</h3>
            <div class="col-xs-9">
                <form:form id="update-form" modelAttribute="user" role="form" class="form-horizontal col-md-offset-1">
                    <div class="form-group">
                        <label class="col-xs-4 control-label">用户账号：</label>
                        <div class="col-xs-6">
                            <form:input path="userid" id="userid" name="userid" type="text" cssClass="form-control" readonly="true" value="${oldinfo.userid}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-4 control-label">姓名：</label>
                        <div class="col-xs-6">
                            <form:input path="username" id="username" name="username" type="text" cssClass="form-control" value="${oldinfo.username}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-4 control-label">E-mail：</label>
                        <div class="col-xs-6">
                            <form:input path="email" id="email" name="email" type="text" cssClass="form-control" value="${oldinfo.email}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-4 control-label">联系电话：</label>
                        <div class="col-xs-6">
                            <form:input path="phonenum" id="phonenum" name="phonenum" type="text" cssClass="form-control" value="${oldinfo.phonenum}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-4 control-label">工作单位：</label>
                        <div class="col-xs-6">
                            <form:input path="company" id="company" name="company" type="text" cssClass="form-control" value="${oldinfo.company}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-4 control-label">职位：</label>
                        <div class="col-xs-6">
                            <form:input path="position" id="position" name="position" type="text" cssClass="form-control" value="${oldinfo.position}"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-xs-4 control-label">用户组：</label>
                        <div class="col-xs-6">
                            <form:select path="usergroup" id="usergroup" name="usergroup" cssClass="form-control">
                                <form:option value="normal">普通用户</form:option>
                                <form:option value="advanced">中级用户</form:option>
                                <form:option value="senior">高级用户</form:option>
                            </form:select>
                            <form:input path="id" id="ID" type="hidden" value="${oldinfo.id}"/>
                        </div>
                    </div>
                    <div class="form-group">
                         <button id="btnsubmit" type="submit" class="btn btn-primary col-md-offset-6">提交更改</button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
    <script>
        $(function () {
            //groupname =
            $('#usergroup').val('${oldinfo.usergroup}');
            //console.log('group='+groupname);
        });
        $('#update-form').on('submit',function(){
           $.ajax({
               type:'post',
               data:$('#update-form').serialize(),
               url:'/user/domodifyuserback',
               cache:false,
               success:function (data) {
                   if('200' == data){
                       alert('修改成功！');
                       loadPage('/user/admin/userlist');
                   }else{
                       alert(data+':修改失败！');
                   }
               }
           });
           return false;
        });
    </script>
</body>
</html>
