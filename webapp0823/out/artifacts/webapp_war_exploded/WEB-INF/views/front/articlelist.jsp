<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/1
  Time: 16:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>专题列表</title>
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
                    loadPage("/platforminfo/articlelist/"+num);
                }
            }
        });
    </script>
</head>
<body>
    <div>
        <ul class="list-unstyled article-list">
            <c:forEach items='${articleList}' var="article">
                <li onclick="self.location='/platforminfo/details/article_${article.ID}'">
                    <h3>${article.title}
                        <small style="float: right"><span class="glyphicon glyphicon-calendar"></span>${article.datetime.substring(0,19)}</small>
                    </h3>
                    <br>
                    <p class="article-abstract limit-length">${article.content}...</p>
                </li>
            </c:forEach>
        </ul>
        <ul id="pageination" class="pagination" style="float: right"></ul>
    </div>
</body>
</html>
