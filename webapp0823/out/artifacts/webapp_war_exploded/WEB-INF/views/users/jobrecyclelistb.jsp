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
    <title>后台文章列表</title>
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
                    refreshJobs(num);
                }
            }
        });
    </script>
</head>
<body>
<div class="container-fluid" style="padding-top: 10%">
    <div class="row" style="padding-bottom: 10px">
        <h2>回收站</h2>
    </div>
    <div class="row">
        <div class="col-sm-11">
            <table class="listborder table table-striped table-hover">
                <thead>
                <tr class="listhead">
                    <th>序号</th>
                    <th>作业编号</th>
                    <th>提交时间</th>
                    <th>提交类型</th>
                    <th>详细信息</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody id="tbody">
                <c:forEach items='${jobList}' var="job">
                    <tr class="listbody">
                        <td>${job.ID}</td>
                        <td>${job.jobId}</td>
                        <td>${job.submitTime.substring(0,19)}</td>
                        <td>${job.type}</td>
                        <td><a href="#" name="jobdetails">详细信息</a></td>
                        <td><a href="#" title="彻底删除" name="deleteCompletely"><span class="glyphicon glyphicon-trash"></span></a>
                            <a href="#" title="还原至作业列表" name="restore"><span class="glyphicon glyphicon-plus"></span></a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <ul id="pageination" class="pagination" style="float: right;margin-top: 0px"></ul>
        </div>

    </div>
</div>
<script>

    $("body").on('click', 'a[name=jobdetails]', function () {
        var jobid = $(this).parent().parent().find('td').eq(1).text();
        var type = $(this).parent().prev().text();
        if(type == "参数"){
            $.ajax({
                type: "POST",
                url: "/queryJob?jobId="+jobid,
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
                    $('#jobDetailModalArgs').modal('show');
                }
            });
        }else{
            $.ajax({
                type: "POST",
                url: "/queryJob?jobId="+jobid,
                async: "true",
                error: function (request) {
                    alert("Connection error");
                },
                success: function (data) {
                    var v = JSON.parse(data);
                    var files = JSON.parse(v.scriptfilenames);
                    document.getElementById('ddjobId').value = v.jobid;
                    var textareaValue = "";
                    var userid = userid;
                    for(var r in files){
                        textareaValue += files[r].substring(14, files[r].length) + "\r\n";
                    }
                    document.getElementById('duploadedFiles').value = textareaValue;
                    $('#jobDetailModalFile').modal('show');
                }
            });
        }

    });

    $("body").on('click', 'a[name=restore]', function () {
        jobId = $(this).parent().parent().find('td').eq(1).text();
        $.ajax({
            type: "POST",
            url: "/restoreFromRecycleBin?jobId="+jobId,
            async: "true",
            error: function (request) {
                alert("Connection error")
            },
            success: function (data) {
                if(data == "500"){
                    alert(data+ ":还原失败！");
                }else {
                    alert(data+ ":还原成功！");
                }
            }
        });
    });

    $("body").on('click', 'a[name=deleteCompletely]', function () {
        jobId = $(this).parent().parent().find('td').eq(1).text();
        $.ajax({
            type: "POST",
            url: "/deleteCompletely?jobId="+jobId,
            async: "true",
            error: function (request) {
                alert("Connection error")
            },
            success: function (data) {
                alert(data+ ":删除成功！");
            }
        });
    });


    function refreshJobs(event){
        var num;
        if(event.data == null || event.data == undefined){
            num = event;
        }else{
            num = event.data;
        }
        $.ajax({
            type: 'post',
            data: $('#search-form').serialize(),
            url:'/searchrecyclejobs/'+user+"_"+num,
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
                $.each(data.joblist,function (idx,job) {
                    $('#tbody').append("<tr class=\"listbody\">\n" +
                        "                        <td>"+job.id+"</td>\n" +
                        "                        <td>"+job.jobId+"</td>\n" +
                        "                        <td>"+job.submitTime+"</td>\n" +
                        "                        <td>"+job.type+"</td>\n" +
                        "                        <td><a href=\"#\" name=\"jobdetails\">详细信息</a></td>\n" +
                        "                        <td><a href=\"#\" title=\"彻底删除\" name=\"deleteCompletely\"><span class=\"glyphicon glyphicon-trash\"></span></a>" +
                        "<a href=\"#\" title=\"还原至作业列表\" name=\"restore\"><span class=\"glyphicon glyphicon-plus\"></span></a></td>\n" +
                        "                    </tr>");
                });
                //绑定事件
            }
        });
        return false;
    }
</script>
</body>
</html>
