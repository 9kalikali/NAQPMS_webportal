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
    <title>数据集管理</title>
<body>
<div class="container-fluid" style="padding-top: 5%; margin-left: auto; margin-right: auto">
    <div class="row" style="padding-bottom: 10px">
        <div>
            <h2>数据集管理</h2>
        </div>
        <div class="col-xs-11">
            <button class="btn btn-default">添加</button>
            <table class="table table-no-bordered table-striped" id="datasetTable"></table>
        </div>
    </div>
</div>
<script>
    $('#datasetTable').bootstrapTable({
        method: 'get',
        url: '/admin/getDatasetList',
        striped : true,                                                         // 是否显示行间隔色
        pagination : true,                                                      // 是否显示分页
        cache: false,
        sidePagination : "server",                                              // 分页方式：client客户端分页，server服务端分页
        pageSize : 10,                                                           // 每页的记录行数
        queryParamsType: '',
        columns: [{
            field: 'datasetId',
            title: '数据集ID',
            align: 'center'
        }, {
            field: 'name',
            title: '名称',
            align: 'center'
        }, {
            field: 'frequency',
            title: '更新频率',
            align: 'center'
        }, {
            field: 'shareLevel',
            title: '共享级别',
            align: 'center',
            width: '12%',
            formatter: function (value, row ,index) {
                return value.substring(2);
            }
        },  {
            title: '详细信息',
            align: 'center',
            class: 'detail',
            formatter: function (value, row, index) {
                return "<a href=\"javascript:void(0)\">详细信息</a>";
            }
        }, {
            title: '操作',
            align: 'center',
            formatter: function (value, row, index) {
                return "<button class=\"btn btn-success editDataset\" onclick=\"loadPage('editDataset')\">编辑</button>\n"+
                    "<button class=\"btn btn-success deleteDataset\">删除</button>\n";
            }
        }]
    });
</script>
</body>
</html>

