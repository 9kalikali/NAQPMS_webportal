<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/21
  Time: 11:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>后台新闻列表</title>
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
                    refreshNewsList(num);
                }
            }
        });
    </script>
</head>
<body>
<div class="container-fluid" style="padding-top: 10%">
    <div class="row" style="padding-bottom: 10px">
        <h2>新闻列表</h2>
        <div class="col-sm-12">
            <form:form id="search-form"  modelAttribute="article" cssClass="form-inline" role="form">
                <div class="form-group">
                    <form:input path="title" type="text" cssClass="form-control " id="title" placeholder="请输入标题"/>
                </div>
                <div class="form-group">
                    <form:input path="author" type="text" cssClass="form-control" id="author" placeholder="请输入作者"/>
                </div>
                <div class="form-group">
                    <form:input path="datetime" type="text" cssClass="form-control" id="time" placeholder="请输入发布时间"/>
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
                    <th>标题</th>
                    <th>作者</th>
                    <th>发布时间</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody id="tbody">
                <c:forEach items='${newsList}' var="news">
                    <tr class="listbody">
                        <td>${news.ID}</td>
                        <td>${news.title}</td>
                        <td>${news.author}</td>
                        <td>${news.datetime}</td>
                        <td><button name="btn-delete" value="${news.ID}" type="button" class="btn btn-success">删除</button></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <ul id="pageination" class="pagination" style="float: right;margin-top: 0px"></ul>
        </div>

    </div>
</div>
<script>
    $('#search-form').on('submit',1,refreshNewsList);
    //绑定事件
    $('button[name="btn-delete"]').on('click',deleteNews);

    /**
     * 删除新闻
     * @param event
     * @returns {boolean}
     */
    function deleteNews(event){
        var newsid = $(event.target).val();
        if(confirm('您确定要删除吗？')){
            $.ajax({
                url:'/platforminfo/admin/deletenews/'+newsid,
                cache:false,
                success:function (data) {
                    if('success' == data){
                        alert("删除成功！");
                        loadPage('/platforminfo/admin/newslist')
                    }else{
                        alert("删除失败！请重试。");
                    }
                }
            });
        }
        return false;
    }

    /**
     * 刷新新闻列表
     * @param event
     * @returns {boolean}
     */
    function refreshNewsList(event){
        var num;
        if(event.data == null || event.data == undefined){
            num = event;
        }else{
            num = event.data;
        }
        $.ajax({
            type: 'post',
            data: $('#search-form').serialize(),
            url:'/platforminfo/searchnews/'+num,
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
                $.each(data.newslist,function (idx,news) {
                    $('#tbody').append("<tr class=\"listbody\">\n" +
                        "                            <td>"+news.id+"</td>\n" +
                        "                            <td>"+news.title+"</td>\n" +
                        "                            <td>"+news.author+"</td>\n" +
                        "                            <td>"+news.datetime+"</td>\n" +
                        "                            <td><button id=\"btn-delete\" value=\""+news.id+"\" type=\"button\" class=\"btn btn-success\">删除</button></td>\n" +
                        "                        </tr>");
                });
                //绑定事件
                $('button[name="btn-delete"]').on('click',deleteNews);
            }
        });
        return false;
    }
</script>
</body>
</html>
