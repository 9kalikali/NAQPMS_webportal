<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/13
  Time: 14:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>用户中心首页</title>
    <!-- 相关的CSS文件 -->
    <link rel="stylesheet" href="/css/common.css">
    <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <style>
        .number-box{
            width: 100%;
            height: 80px;
            margin-bottom: 20px;
            border: 1px solid rgb(180, 180, 180);
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
            border-radius: 10px;
        }
        .number-box i{
            margin-top: 20px;
            margin-left: 10px;
        }
        .number-box p{
            margin-top: 25px;
            float: right;
            margin-right: 20px;
            font-size: 25px;
            font-weight: bold;
        }
        .index-table{
            border: 1px solid rgb(180, 180, 180);
            border-radius: 10px;
            overflow: hidden;
        }
    </style>
</head>
<body>
    <div class="container-fluid" style="padding-top: 10%">
        <div class="info-panel">
            <div class="round-img">
                <i class="fa fa-user-circle-o pull-left"></i>
            </div>
            <div class="user-info">
                <p><i class="fa fa-id-card-o"></i>&nbsp;&nbsp;用户ID：${curuser.userid}</p>
                <p><i class="fa fa-user-o"></i>&nbsp;&nbsp;姓名：${curuser.username}</p>
                <p><i class="fa fa-at"></i>&nbsp;&nbsp;Email：${curuser.email}</p>
                <p><i class="fa fa-group"></i>&nbsp;&nbsp;用户组：${curuser.usergroup}</p>
            </div>
        </div>
        <div class="row" style="margin-top: 30px">
            <div class="col-sm-9">
                <div class="index-table">
                    <table class="table table-hover table-striped">
                        <thead>
                        <tr class="listhead">
                            <th>作业ID</th>
                            <th>提交时间</th>
                            <th>提交类型</th>
                            <th>状态</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${joblist}" var="job">
                            <tr class="listbody">
                                <td>${job.jobId}</td>
                                <td>${job.submitTime.substring(0,19)}</td>
                                <td>${job.type}</td>
                                <td>${job.status}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="col-sm-3">
                <div class="number-box">
                    <i class="fa fa-circle-o-notch fa-spin fa-3x"></i>
                    <p>进行中：${runningjobs}</p>
                </div>
                <div class="number-box">
                    <i class="fa fa-check fa-3x"></i>
                    <p>已完成：${completejobs}</p>
                </div>
                <div class="number-box fa-3x">
                    <i class="fa fa-tasks"></i>
                    <p>总量：${jobcount}</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
