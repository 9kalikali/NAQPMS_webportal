<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/2/27
  Time: 8:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="UTF-8">
    <title>首页</title>
    <!-- 自定义的CSS文件 -->
    <link rel="stylesheet" href="../css/common.css">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <style>
        .border-box{
            border-radius: 10px;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
        }
    </style>
</head>
<body>
    <div id="banner" style="margin-top: 50px;margin-left: 0;margin-right: 0">

    </div>
    <div class="container-fluid" style="padding-top: 2%;padding-bottom: 2%">
        <div class="row" style="padding-top: 20px">
            <div class="col-md-3 col-md-offset-1 border-box">
                <table class="table">
                    <thead>
                    <tr>
                        <th>新闻公告<span style="float: right;"><a href="/platforminfo/more/newslist_0">更多</a></span></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items='${modelMap.get("newslist")}' var='news' >
                        <tr><td><a href="/platforminfo/details/news_${news.ID}">${news.getTitle()}</a></td></tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="col-md-3 border-box" style="margin-left: 40px">
                <table class="table">
                    <thead>
                    <tr>
                        <th>专题文章 <span style="float: right;"><a href="/platforminfo/more/articlelist_0">更多</a></span></th>
                    </tr>
                    </thead>
                    <tbody>
                        <c:forEach items='${modelMap.get("articlelist")}' var='article' >
                            <tr><td><a href="/platforminfo/details/article_${article.getID()}">${article.getTitle()}</a></td></tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            <div class="col-md-3 border-box" style="margin-left: 40px">
                <table class="table">
                    <thead>
                    <tr>
                        <th>常见问题 <span style="float: right;"><a href="/platforminfo/more/questionlist_0">更多</a></span></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items='${modelMap.get("questionlist")}' var='question' >
                        <tr><td><a href="/platforminfo/details/question_${question.getID()}">${question.getTitle()}</a></td></tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script>
        $("#banner").scrollBanner({
            images : [
                {src:"/images/banner2.png",title:"banner1",href:"#"},
                {src:"/images/banner1.png",title:"banner2",href:"#"},
                {src:"/images/banner3.png",title:"banner3",href:"#"}
            ],
            scrollTime:3000,
            bannerHeight:"550px",
            iconColor: "#FFFFFF",
            iconHoverColor : "#82C900",
            iconPosition : "center"
        });
    </script>
</body>
</html>
