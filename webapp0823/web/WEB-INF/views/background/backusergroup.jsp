<%--
  Created by IntelliJ IDEA.
  User: renxuanzhengbo
  Date: 2018/5/10
  Time: 下午2:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>后台用户组管理</title>
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
        <div class="row" style="padding-top: 10px">
            <h2>用户组管理</h2>
            <div class="col-sm-1">
                <button id="btn-add" type="button" class="btn btn-default"><i class="fa fa-plus"></i>添加用户组</button>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-11">
                <table class="listborder table table-striped table-hover">
                    <thead>
                    <tr class="listhead">
                        <th>序号</th>
                        <th>用户组名称</th>
                        <th>公开数据</th>
                        <th>所内共享数据</th>
                        <th>课题内共享数据</th>
                        <th>更新人</th>
                        <th>更新时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody id="tbody">
                    <c:forEach items='${groupList}' var="group">
                        <tr class="listbody">
                            <td>${group.id}</td>
                            <td>${group.groupname}</td>
                            <td>${group.data_public==1?'可以':'不可'}</td>
                            <td>${group.data_protected==1?'可以':'不可'}</td>
                            <td>${group.data_private==1?'可以':'不可'}</td>
                            <td>${group.updater}</td>
                            <td>${group.updatetime.substring(0,19)}</td>
                            <td>
                                <button id="btn-delete" value="${group.id}" type="button" class="btn btn-default">删除</button>
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
        $('button#btn-add').on('click',addGroup);
        $('button#btn-delete').on('click',deleteGroup);
        $('button#btn-edit').on('click',editGroup);

        function addGroup(event) {
            $('#groupModal').modal('show');
        }

        /**
         * 删除用户组
         * @param event
         * @returns {boolean}
         */
        function deleteGroup(event){
            var id = $(event.target).val();
            //权限检查
            if(checkPriority(1)){
                if(confirm('您确定要删除吗？')){
                    $.ajax({
                        url:'/admin/deleteusergroup/'+id,
                        cache:false,
                        success:function (data) {
                            if('success' === data){
                                alert("删除成功！");
                                loadPage('/admin/backusergroup')
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
                url:'/admin/grouplist/'+num,
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
                    $.each(data.grouplist,function (idx,group) {
                        var public = group.data_public===1?'可以':'不可';
                        var protected = group.data_protected===1?'可以':'不可';
                        var private = group.data_private===1?'可以':'不可';
                        $('#tbody').append("<tr class=\"listbody\">\n" +
                            "                            <td>"+group.id+"</td>\n" +
                            "                            <td>"+group.groupname+"</td>\n" +
                            "                            <td>"+public+"</td>\n" +
                            "                            <td>"+protected+"</td>\n" +
                            "                            <td>"+private+"</td>\n" +
                            "                            <td>"+group.updater+"</td>\n" +
                            "                            <td>"+group.updatetime+"</td>\n" +
                            "                            <td>\n" +
                            "                                <button id=\"btn-edit\" value=\""+group.groupname+"\" type=\"button\" class=\"btn btn-success\">编辑</button>\n" +
                            "                                <button id=\"btn-delete\" value=\""+group.id+"\" type=\"button\" class=\"btn btn-success\">删除</button>\n" +
                            "                            </td>\n" +
                            "                        </tr>");
                    });
                    //绑定事件
                    $('button#btn-delete').on('click',deleteGroup);
                    $('button#btn-edit').on('click',editUser);
                }
            });
            return false;
        }
    </script>
</body>
</html>
