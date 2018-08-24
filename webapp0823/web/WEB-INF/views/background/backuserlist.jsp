<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/22
  Time: 13:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>后台用户列表</title>
    <script>
        $('#pageination').jqPaginator({
            totalPages: ${pageinfo.count()},
            visiblePages: 5,
            currentPage: ${pageinfo.pageNum},
            prev: '<li class="prev"><a href="javascript:void(0);">Previous</a></li>',
            next: '<li class="next"><a href="javascript:void(0);">Next</a></li>',
            page: '<li class="page"><a href="javascript:void(0);">{{page}}</a></li>',
            onPageChange: function (num, type) {
                if(type != "init"){
                    refreshList(num);
                }
            }
        });
    </script>
</head>
<body>
<div class="container-fluid" style="padding-top: 10%">
    <div class="row" style="padding-bottom: 10px">
        <h2>用户列表</h2>
        <div class="col-sm-12">
            <form:form id="search-form"  modelAttribute="user" cssClass="form-inline" role="form">
                <div class="form-group">
                    <form:input path="userid" type="text" cssClass="form-control " id="title" placeholder="请输入账号"/>
                </div>
                <div class="form-group">
                    <form:input path="username" type="text" cssClass="form-control" id="author" placeholder="请输入姓名"/>
                </div>
                <div class="form-group">
                    <form:input path="email" type="text" cssClass="form-control" id="time" placeholder="请输入邮箱"/>
                </div>
                <button type="submit" class="btn btn-primary">查询</button>
            </form:form>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-11">
            <table class="listborder table table-striped table-hover">
                <thead>
                <tr class="listhead">
                    <th>序号</th>
                    <th>账号</th>
                    <th>姓名</th>
                    <th>邮箱</th>
                    <th>联系方式</th>
                    <th>单位</th>
                    <th>用户组</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody id="tbody">
                <c:forEach items='${userList}' var="user">
                    <tr class="listbody">
                        <td>${user.id}</td>
                        <td>${user.userid}</td>
                        <td>${user.username}</td>
                        <td>${user.email}</td>
                        <td>${user.phonenum}</td>
                        <td>${user.company}</td>
                        <td>${user.usergroup}</td>
                        <td>
                            <button id="btn-edit" value="${user.userid}" type="button" class="btn btn-success">编辑</button>
                            <button id="btn-delete" value="${user.id}" type="button" class="btn btn-success">删除</button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <ul id="pageination" class="pagination" style="float: right;margin-top: 0px"></ul>
        </div>

    </div>
</div>
<script>
    $('#search-form').on('submit',1,refreshList);
    $('button#btn-delete').on('click',deleteUser);
    $('button#btn-edit').on('click',editUser);

    /**
     * 编辑用户信息
     * @param event
     */
    function editUser(event) {
        if(checkPriority(1)){
            var userid = $(event.target).val();
            loadPage('/user/backmodifyuser/'+userid);
        }else{
            alert("您的账号权限不足");
        }
    }

    /**
     * 删除用户
     * @param event
     * @returns {boolean}
     */
    function deleteUser(event){
        var id = $(event.target).val();
        //权限检查
        if(checkPriority(1)){
            if(confirm('您确定要删除吗？')){
                $.ajax({
                    url:'/user/admin/deleteuser/'+id,
                    cache:false,
                    success:function (data) {
                        if('success' == data){
                            alert("删除成功！");
                            loadPage('/user/admin/userlist')
                        }else{
                            alert("删除失败！请重试。");
                        }
                    }
                });
            }
        }else{
            alert("您的账号权限不足。");
        }
    }

    /**
     * 刷新列表
     * @param event
     * @returns {boolean}
     */
    function refreshList(event){
        var num;
        if(event.data == null || event.data == undefined){
            num = event;
        }else{
            num = event.data;
        }
        $.ajax({
            type: 'post',
            data: $('#search-form').serialize(),
            url:'/user/searchuser/'+num,
            cache:false,
            dataType:'json',
            success:function (data) {
                //修改分页器属性
                $('#pageination').jqPaginator('option',{
                    totalPages:parseInt(data.totalpages),
                    currentPage:parseInt(data.curpage)
                });
                //清空tbody
                $('#tbody').empty();
                //相tbody填充新内容
                $.each(data.userlist,function (idx,user) {
                    $('#tbody').append("<tr class=\"listbody\">\n" +
                        "                        <td>"+user.id+"</td>\n" +
                        "                        <td>"+user.userid+"</td>\n" +
                        "                        <td>"+user.username+"</td>\n" +
                        "                        <td>"+user.email+"</td>\n" +
                        "                        <td>"+user.phonenum+"</td>\n" +
                        "                        <td>"+user.company+"</td>\n" +
                        "                        <td>"+user.usergroup+"</td>\n" +
                        "                        <td>\n" +
                        "                            <button id=\"btn-edit\" value=\""+user.userid+"\" type=\"button\" class=\"btn btn-success\">编辑</button>\n" +
                        "                            <button id=\"btn-delete\" value=\""+user.id+"\" type=\"button\" class=\"btn btn-success\">删除</button>\n" +
                        "                        </td>\n" +
                        "                    </tr>");
                });
                //绑定事件
                $('button#btn-delete').on('click',deleteUser);
                $('button#btn-edit').on('click',editUser);
            }
        });
        return false;
    }
</script>
</body>
</html>
