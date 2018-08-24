<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/26
  Time: 13:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>管理员列表</title>
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
                    refreshAdminlist(num);
                }
            }
        });
    </script>
</head>
<body>
    <div class="container-fluid" style="padding-top: 10%">
        <div class="row" style="padding-bottom: 10px">
            <h2>管理员列表</h2>
            <div class="col-sm-12">
                <form:form id="search-form"  modelAttribute="admin" cssClass="form-inline" role="form">
                    <div class="form-group">
                        <form:input path="adminid" type="text" cssClass="form-control " id="title" placeholder="请输入账号"/>
                    </div>
                    <button type="submit" class="btn btn-default">查询</button>
                </form:form>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-11">
                <table class="listborder table table-striped table-hover">
                    <thead>
                    <tr class="listhead">
                        <th>账号</th>
                        <th>权限</th>
                        <th>注册日期</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody id="tbody">
                    <c:forEach items='${adminList}' var="admin">
                        <tr class="listbody">
                            <td>${admin.adminid}</td>
                            <c:choose>
                                <c:when test="${admin.priority == 0}">
                                    <td>超级管理员</td>
                                </c:when>
                                <c:when test="${admin.priority == 1}">
                                    <td>普通管理员</td>
                                </c:when>
                                <c:when test="${admin.priority == 2}">
                                    <td>次级管理员</td>
                                </c:when>
                            </c:choose>
                            <td>${admin.registdate.substring(0,19)}</td>
                            <td>
                                <button id="btn-edit" value="${admin.adminid}" type="button" class="btn btn-success">编辑权限</button>
                                <button id="btn-delete" value="${admin.id}" type="button" class="btn btn-success">删除</button>
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
        $('#search-form').on('submit',1,refreshAdminlist);
        $('button#btn-delete').on('click',deleteAdmin);
        $('button#btn-edit').on('click',editAdmin);

        /**
         * 编辑管理员权限
         * @param event
         */
        function editAdmin(event){
            $('#myModal').modal('show');
            var aid = $(event.target).val();
            $('#aid').val(aid);
        }

        /**
         * 删除管理员
         * @param event
         * @returns {boolean}
         */
        function deleteAdmin(event){
            var id = $(event.target).val();
            //权限检查
            if(checkPriority(0)){
                return;
            }
            if(confirm('您确定要删除吗？')){
                $.ajax({
                    url:'/admin/deleteadmin/'+id,
                    cache:false,
                    success:function (data) {
                        if('success' == data){
                            alert("删除成功！");
                            loadPage('/admin/adminlist');
                        }else{
                            alert("删除失败！请重试。");
                        }
                    }
                });
            }
            return false;
        }

        function refreshAdminlist(event){
            var num;
            if(event.data == null || event.data == undefined){
                num = event;
            }else{
                num = event.data;
            }
            $.ajax({
                type: 'post',
                data: $('#search-form').serialize(),
                url:'/admin/searchadmin/'+num,
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
                    $.each(data.adminlist,function (idx,admin) {
                        var pri;
                        switch(admin.priority){
                            case 0:
                                pri = '超级管理员';
                                break;
                            case 1:
                                pri = '普通管理员';
                                break;
                            case 2:
                                pri = '次级管理员';
                                break;
                            default:
                                pri = '未知';
                                break;
                        }
                        $('#tbody').append("<tr class=\"listbody\">\n" +
                            "                            <td>"+admin.adminid+"</td>\n" +
                            "                            <td>"+pri+"</td>"+
                            "                            <td>"+admin.registdate+"</td>"+
                            "                            <td>\n" +
                            "                                <button id=\"btn-edit\" value=\""+admin.adminid+"\" type=\"button\" class=\"btn btn-success\">编辑权限</button>\n" +
                            "                                <button id=\"btn-delete\" value=\""+admin.id+"\" type=\"button\" class=\"btn btn-success\">删除</button>\n" +
                            "                            </td>\n" +
                            "                        </tr>");
                    });
                    //绑定事件
                    $('button#btn-delete').on('click',deleteAdmin);
                    $('button#btn-edit').on('click',editAdmin);
                }
            });
            return false;
        }

        //模态框点击事件
        $('#sbmt').on('click',function () {
            // if(checkPriority(0)){
            //     alert("您无权进行操作");
            //     return;
            // }
            $.ajax({
                type:'post',
                data:$('#pri-form').serialize(),
                url:'/admin/domodifypri',
                cache:false,
                success:function (data) {
                    if('success' == data){
                        alert('修改成功！');
                        $('#myModal').modal('hide');
                        loadPage('/admin/adminlist');
                    }else{
                        alert('修改失败！');
                        $('#myModal').modal('hide');
                    }
                },
                error:function () {
                    alert("操作异常，请重试。");
                    $('#myModal').modal('hide');
                }
            });
        });
    </script>
</body>
</html>
