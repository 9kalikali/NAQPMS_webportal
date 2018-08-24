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
<%--<%--%>
    <%--Cookie cookie = null;--%>
    <%--Cookie[] cookies = null;--%>
    <%--// 获取当前域名下的cookies，是一个数组--%>
    <%--cookies = request.getCookies();--%>
    <%--String adminid = "";--%>
    <%--if(cookies != null){--%>
        <%--for (int i = 0; i < cookies.length; i++) {--%>
            <%--cookie = cookies[i];--%>
            <%--if((cookie.getName().compareTo("adminid")) == 0){--%>
                <%--adminid = cookie.getValue();--%>
            <%--}--%>
        <%--}--%>
    <%--}--%>
<%--%>--%>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>作业列表</title>
<body>
<div class="container-fluid" style="padding-top: 5%; margin-left: auto; margin-right: auto">
    <div class="row">
        <div>
            <h2>任务列表</h2>
        </div>
        <div class="col-xs-11">
            <div id="toolbar">
                <form id="formSearch" class="form-inline" role="form">
                    <div class="form-group">
                        <label class="sr-only" for="txt_search_jobname">作业名称</label>
                        <input type="text" class="form-control" id="txt_search_jobname" placeholder="作业名称">
                    </div>
                    <div class="form-group">
                        <label class="sr-only" for="txt_search_status">状态</label>
                        <input type="text" class="form-control" id="txt_search_status" placeholder="状态">
                    </div>
                    <button type="button" class="btn btn-primary">查询</button>
                </form>
            </div>
            <table class="table table-no-bordered table-striped" id="resultTable"></table>
        </div>

    </div>
</div>




<script>
    /*
    查询作业
     */
    var workid;
    $('#resultTable').bootstrapTable({
        method: 'get',
        url: '<%=request.getContextPath() %>/admin/queryJobsAdmin',
        toolbar : '#toolbar',                                                   // 工具按钮用哪个容器
        striped : true,                                                         // 是否显示行间隔色
        pagination : true,                                                      // 是否显示分页
        cache: false,
        sidePagination : "server",                                              // 分页方式：client客户端分页，server服务端分页
        pageSize : 10,                                                           // 每页的记录行数
        showRefresh : true,                                                    // 是否显示刷新按钮
        queryParamsType:'',
/*        queryParams : function (params) {                                       //得到查询的参数
            //这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
            var temp = {
                pageSize: params.limit,                                         //页面大小
                pageNumber: (params.offset / params.limit) + 1,                 //页码
                sort: params.sort,                                              //排序列名
                sortOrder: params.order,                                        //排位命令（desc，asc）
                name: $("#txt_search_jobname").val()
            };
            return temp;
        },*/
/*        searchOnEnterKey: true,*/
        columns: [{
            field: 'iD',
            title: 'ID',
            align: 'center'
        }, {
            field: 'jobId',
            title: '作业编号',
            align: 'center'
        }, {
            field: 'userId',
            title: '用户',
            align: 'center'
        }, {
            field: 'status',
            title: '状态',
            align: 'center',
            width: '12%',
            formatter: function (value, row, index) {
                return (value == "2") ? "<span class=\"glyphicon glyphicon-ok\" style='color: #1DC116'></span> 已完成" :
                    ((value == "0") ? "<span class=\"glyphicon glyphicon-minus\" style='color: #070580'></span> 排队中" :
                        "<i class=\"fa fa-spinner fa-spin\"></i> 运行中");
            }
        }, {
            field: 'submitTime',
            title: '提交时间',
            align: 'center',
            formatter: function (value, row, index) {
                var t;
                if(value != null){
                    t = value.substring(0, 19);
                    return t;
                }
            }
        },  {
            field: 'type',
            title: '提交类型',
            align: 'center',
            formatter: function (value, row, index) {
                return value=="args"? "参数" : "脚本";
            }
        },{
            title: '详细信息',
            align: 'center',
            class: 'detail',
            formatter: function (value, row, index) {
                return "<button class=\"btn btn-success\">详细信息</button>";
            }
        }],
        sortName : 'workID',
        sortOrder : 'desc'
    });
    $("body").on('click', '.detail', function () {
        jobId = $(this).parent().find('td').eq(1).text();
        var type = $(this).prev().text();
        if(type == "参数"){
            $.ajax({
                type: "POST",
                url: "/queryJob?jobId="+jobId,
                async: "true",
                error: function (request) {
                    alert("Connection error");
                },
                success: function (data) {
                    var v = JSON.parse(data);
                    /*                var files = JSON.parse(v.scriptFileNames);*/
                    document.getElementById('djobId').value = v.jobid;
                    document.getElementById('dminlon').value = v.minlon;
                    document.getElementById('dmaxlon').value = v.maxlon;
                    document.getElementById('dminlat').value = v.minlat;
                    document.getElementById('dmaxlat').value = v.maxlat;
                    document.getElementById('dstart-time').value = v.startTime;
                    document.getElementById('dend-time').value = v.endTime;
                    document.getElementById('dstep-length').value = v.steplength;
                    document.getElementById('dstdout').value = v.stdout;
                    document.getElementById('dstderr').value = v.stderr;
                    document.getElementById('ddir').value = v.dir;
                    document.getElementById('dnumbersOfCPU').value = v.cpus;
                    /*                var textareaValue = "";
                                    for(var r in files){
                                        textareaValue += files[r].substring(14, files[r].length) + "\r\n";
                                    }
                                    document.getElementById('duploadedFiles').value = textareaValue;*/
                    $('#jobDetailModalArgs').modal('show');
                }
            });
        }else{
            $.ajax({
                type: "POST",
                url: "/queryJob?jobId="+jobId,
                async: "true",
                error: function (request) {
                    alert("Connection error");
                },
                success: function (data) {
                    var v = JSON.parse(data);
                    var files = JSON.parse(v.scriptfilenames);
                    document.getElementById('ddjobId').value = v.jobid;
                    var textareaValue = "";
                    for(var r in files){
                        textareaValue += files[r].substring(14, files[r].length) + "\r\n";
                    }
                    document.getElementById('duploadedFiles').value = textareaValue;
                    $('#jobDetailModalFile').modal('show');
                }
            });
        }

    });
</script>
</body>
</html>

