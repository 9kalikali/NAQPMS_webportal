<%--
  Created by IntelliJ IDEA.
  User: renxuanzhengbo
  Date: 2018/4/27
  Time: 下午4:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>常见问题列表</title>
    <script>
        $('#pageination').jqPaginator({
            totalPages: ${pageinfo.count()},
            visiblePages: 5,
            currentPage: ${pageinfo.pageNum},
            prev: '<li class="prev"><a href="javascript:void(0);">Previous</a></li>',
            next: '<li class="next"><a href="javascript:void(0);">Next</a></li>',
            page: '<li class="page"><a href="javascript:void(0);">{{page}}</a></li>',
            onPageChange: function (num, type) {
                //$('#p1').text(type + '：' + num);
                if(type != "init"){
                    loadPage("/platforminfo/questionlist/"+num);
                }
            }
        });
    </script>
</head>
<body>
<div>
    <ul class="list-unstyled article-list">
        <c:forEach items='${questionList}' var="question">
            <li onclick="self.location='/platforminfo/details/question_${question.ID}'">
                <h3>${question.title}
                    <small style="float: right"><span class="glyphicon glyphicon-calendar"></span>${question.datetime.substring(0,19)}</small>
                </h3>
                <br>
                <p class="article-abstract limit-length">${question.content}...</p>
            </li>
        </c:forEach>
    </ul>
    <ul id="pageination" class="pagination" style="float: right"></ul>
</div>
</body>
</html>
