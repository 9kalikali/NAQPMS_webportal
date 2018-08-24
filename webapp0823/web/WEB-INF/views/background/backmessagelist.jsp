<%--
  Created by IntelliJ IDEA.
  User: renxuanzhengbo
  Date: 2018/4/2
  Time: 上午10:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>后台站内信列表</title>
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
                    refreshMessage(num);
                }
            }
        });
    </script>
</head>
<body>
    <div class="container-fluid" style="padding-top: 10%">
        <div class="row" style="padding-bottom: 10px">
            <h2>站内信列表</h2>
            <div class="col-sm-12">
                <form:form id="search-form"  modelAttribute="message" cssClass="form-inline" role="form">
                    <div class="form-group">
                        <form:input path="recID" type="text" cssClass="form-control " id="title" placeholder="请输入收信人"/>
                    </div>
                    <div class="form-group">
                        <form:input path="PDate" type="text" cssClass="form-control" id="time" placeholder="请输入发布时间"/>
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
                        <th>编号</th>
                        <th>站内信ID</th>
                        <th>发信人</th>
                        <th>收信人</th>
                        <th>内容</th>
                        <th>发信日期</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody id="tbody">
                    <c:forEach items='${messageList}' var="message">
                        <tr class="listbody">
                            <td>${message.ID}</td>
                            <td>${message.messageID}</td>
                            <td>${message.sendID}</td>
                            <td>${message.recID == '0' ? "全体":message.recID}</td>
                            <td>${message.message}</td>
                            <td>${message.PDate}</td>
                            <td><button id="btn-delete" value="${message.ID}" type="button" class="btn btn-success">删除</button></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <ul id="pageination" class="pagination" style="float: right;margin-top: 0px"></ul>
            </div>

        </div>
    </div>
    <script>
        $('#search-form').on('submit',1,refreshMessage);
        $('button#btn-delete').on('click',deleteMsg);

        function deleteMsg(event){
            var mid = $(event.target).val();
            if(confirm("您确定要删除吗？")){
                $.ajax({
                    url:'/message/admin/deletemessage/'+mid,
                    cache:false,
                    success:function (data) {
                        if('success' == data){
                            alert("删除成功！");
                            loadPage('/message/admin/messagelist/'+admin)
                        }else{
                            alert("删除失败！请重试。");
                        }
                    }
                });
            }
            return false;
        }

        function refreshMessage(event) {
            var num;
            if(event.data == null || event.data == undefined){
                num = event;
            }else{
                num = event.data;
            }
            $.ajax({
                type: 'post',
                data: $('#search-form').serialize(),
                url:'/message/searchmessages/'+admin+'_'+num,
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
                    $.each(data.messagelist,function (idx,message) {
                        var reciever;
                        if(message.recID == '0'){
                            reciever = '全体';
                        }else{
                            reciever = message.recID;
                        }
                        $('#tbody').append("<tr class=\"listbody\">\n" +
                            "                            <td>"+message.id+"</td>\n" +
                            "                            <td>"+message.messageID+"</td>\n" +
                            "                            <td>"+message.sendID+"</td>\n" +
                            "                            <td>"+reciever+"</td>\n" +
                            "                            <td>"+message.message+"</td>\n" +
                            "                            <td>"+message.pdate+"</td>\n" +
                            "                            <td><button id=\"btn-delete\" value=\""+message.id+"\" type=\"button\" class=\"btn btn-success\">删除</button></td>\n" +
                            "                        </tr>");
                    });
                    //绑定事件
                    $('button#btn-delete').on('click',deleteMsg);
                }
            });
            return false;
        }

    </script>
</body>
</html>
