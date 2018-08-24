<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/29
  Time: 9:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>通知列表</title>
    <!-- 相关的CSS文件 -->
    <link rel="stylesheet" href="/css/common.css">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script>
        $('#pageination').jqPaginator({
            totalPages: ${pageinfo.count()},
            visiblePages: 5,
            currentPage: ${pageinfo.pageNum},
            prev: '<li class="prev"><a href="javascript:void(0);">Previous</a></li>',
            next: '<li class="next"><a href="javascript:void(0);">Next</a></li>',
            page: '<li class="page"><a href="javascript:void(0);">{{page}}</a></li>',
            onPageChange: function (num, type) {
                $('#p1').text(type + '：' + num);
                if(type != "init"){
                    loadPage("/message/messagelist/"+user+"_"+num);
                }
            }
        });
    </script>
</head>
<body>
    <div class="container-fluid" style="padding-top: 10%">
        <h2 style="margin-bottom: 20px">通知列表</h2>
        <ul id="messagelist" class="list-unstyled message-list">
            <c:forEach items="${messagelist}" var="message">
                <li onclick="messagedetail(${message.ID})" value="${message.status}">
                    <h3 id="${message.ID}">系统通知
                        <small style="float: right;padding-right: 10px"><i class="fa fa-calendar" style="padding-right: 5px"></i>${message.PDate}</small>
                    </h3>
                    <br>
                    <p class="article-abstract limit-length">${message.message}...</p>
                </li>
            </c:forEach>
        </ul>
        <ul id="pageination" class="pagination" style="float: right"></ul>
    </div>

    <script>
        $(function () {
            //将已读信息标题置灰
            $('#messagelist li').each(function () {
                console.log("val="+$(this).val());
                if($(this).val() == 1){
                    $(this).find('h3').css('color','#aaaaaa');
                }
            });
        });
    </script>
</body>
</html>
