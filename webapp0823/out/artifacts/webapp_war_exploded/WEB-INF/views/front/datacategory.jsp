<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/1/29
  Time: 16:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>数据目录管理</title>
<body>
<div class="container-fluid" style="padding-top: 5%; margin-left: auto; margin-right: auto">
    <div class="row" style="padding-bottom: 10px">
        <div>
            <h2>数据目录管理</h2>
        </div>
        <div class="col-xs-12">
            <div class="row">
                <div class="col-xs-4">
                    <c:forEach items='${dirs}' var="dir">
                        <h4><span class="glyphicon glyphicon-plus"></span> ${dir.firstLevel.name}</h4>
                            <c:forEach items='${dir.secondLevel}' var="secondLevel">
                                <h5 style="margin-left: 18px">
                                    <span class="glyphicon glyphicon-chevron-right"></span>
                                    <button style="background-color: transparent; border-style: none; outline: none;"
                                    onclick="loadDataset(${secondLevel.categoryId}, '${secondLevel.name}')">${secondLevel.name}</button>
                                </h5>
                            </c:forEach>
                            <h5 style="margin-left: 18px">
                                <span class="glyphicon glyphicon-chevron-right"></span>
                                <button style="background-color: transparent; border-style: none; outline: none;"
                                    onclick="addSecondCate()">添加</button>
                            </h5>
                    </c:forEach>
                    <h4><span class="glyphicon glyphicon-plus"></span>
                        <button style="background-color: transparent; border-style: none; outline: none;" onclick="loadDataset(${secondLevel.categoryId}, '${secondLevel.name}')">添加</button>
                    </h4>
                </div>
                <div class="col-xs-8">
                    <div class="panel panel-default">
                        <!-- Default panel contents -->
                        <div class="panel-heading"><label class="DSCtitle"></label></div>
                        <ul class="list-group DSC-DS">
<%--
                            <li class="list-group-item"></li>
--%>
                        </ul>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>




<script>

    loadDataset = function (categoryId, name) {
        $('.DSCtitle').text(name);
        $.ajax({
            url: '/admin/getDSforDSC?categoryId='+categoryId,
            method: 'get',
            async: true,
            cache: false,
            success: function (data) {
                var result = JSON.parse(data);
                var a = $('.DSC-DS');
                a.empty();
                for(var k in result){
                    a.append("<li class=\"list-group-item\">"+result[k].name+"</li>")
            }
            }
        })
    }
    addSecondCate = function () {

    }
</script>
</body>
</html>

