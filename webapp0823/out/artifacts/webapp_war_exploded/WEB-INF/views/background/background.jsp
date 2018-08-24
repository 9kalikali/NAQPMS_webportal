<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/19
  Time: 13:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>后台管理界面</title>
    <!-- 相关的CSS文件 -->
    <link rel="stylesheet" href="/css/common.css">
    <link rel="stylesheet" href="/css/jquery-sidebar.css">
    <link href="//netdna.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    
    <script src="/jQuery-Timepicker/jquery-ui-timepicker-addon.min.js"></script>
    <script type="text/javascript" src="/jQuery-Timepicker/i18n/jquery-ui-timepicker-zh-CN.js"></script>
    <link href="/jQuery-Timepicker/jquery-ui-timepicker-addon.min.css" rel="stylesheet" />
    <!-- 表单验证插件 -->
    <script src="/js/validator/jquery.validate.min.js"></script>
    <script src="/js/validator/localization/messages_zh.js"></script>
    <!-- Markdown编辑器插件 -->
    <link rel="stylesheet" href="/mdeditor/css/editormd.min.css">
    <script src="/mdeditor/editormd.min.js"></script>
    <!-- 分页控件 -->
    <script src="/js/jqPaginator.min.js"></script>
    <script src="/js/jqPaginator.js"></script>
    <!-- Echarts插件 -->
    <script src="/js/echarts.min.js"></script>
    <!-------------------------------------ZMZ-START--------------------------->
    <!-- Bootstrap-table表格插件--->
    <link rel="stylesheet" href="/bootstrap-table-master/bootstrap-table.css">
    <script src="/bootstrap-table-master/bootstrap-table.js"></script>
    <script src="/bootstrap-table-master/bootstrap-table-zh-CN.js"></script>
    <!-------------------------------------ZMZ-END--------------------------->

    <script>
        var admin;
        function getCookie(cname){
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for(var i=0; i<ca.length; i++) {
                var c = ca[i].trim();
                if (c.indexOf(name) === 0) { return c.substring(name.length,c.length); }
            }
            return "";
        }
        function checkLogin() {
            admin = getCookie("adminid");
            if (admin !== null && admin !== ""){
                document.getElementById("loginbar")
                    .innerHTML="<ul class=\"nav navbar-nav navbar-right\">\n" +
                    "                  <li><a href=\"#\"><span class=\"glyphicon glyphicon-user\"></span>你好！"+admin+"</a></li>\n" +
                    "                  <li><a href=\"/admin/dologout\"><span class=\"glyphicon glyphicon-log-out\"></span>登出</a></li>\n" +
                    "              </ul>"
            }
        }
        function checkPriority(level){
            var result = false;
            $.ajax({
                type:'post',
                async:false,
                data:{'adminid':admin,'level':level},
                url:'/admin/chekpri',
                success:function (data) {
                    //alert(data);
                    if(data === 'true'){
                        result = true;
                    }
                },
                error:function () {
                    alert('网络异常。');
                }
            });
            return result;
        }
        $(function () {
            loadPage('/admin/backindex');
            checkLogin();
            if(checkPriority(0)){
                $("#adminmanage").attr('style','');
            }
        });
    </script>
</head>
<body>
    <!-- 标题栏 -->
    <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation" style="margin-bottom: 0">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="/">NAQPMS在线交互后台管理系统</a>
            </div>
            <div id="loginbar">
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="/admin/backgroundlogin"><span class="glyphicon glyphicon-log-in"></span> 未登录</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 侧边栏菜单-->
    <div class="sidebar">
        <h3><i class="fa fa-bars push"></i>后台管理 <span class="color">菜单</span></h3>
        <ul style="padding-left: 30px">
            <li><a onclick="loadPage('/admin/backindex')"><i class="fa fa-dashboard push"></i>首页<i class="fa fa-angle-right"></i></a><span class="hover"></span>
            </li>
            <li><a href="#"><i class="fa fa-folder-o push"></i>平台信息管理<i class="fa fa-angle-right"></i></a><span class="hover"></span>
                <ul class="sub-menu">
                    <li><a onclick="loadPage('/platforminfo/admin/postinfo')">信息发布<i class="fa fa-send pull-right"></i></a><span class="hover"></span></li>
                    <li><a onclick="loadPage('/platforminfo/admin/newslist')">新闻列表<i class="fa fa-newspaper-o pull-right"></i></a><span class="hover"></span></li>
                    <li><a onclick="loadPage('/platforminfo/admin/articlelist')">文章列表<i class="fa fa-file-o pull-right"></i></a><span class="hover"></span></li>
                    <li><a onclick="loadPage('/platforminfo/admin/questionlist')">常见问题列表<i class="fa fa-file-o pull-right"></i></a><span class="hover"></span></li>
                </ul>
            </li>
            <li><a href="#"><i class="fa fa-envelope-o push"></i>站内信<i class="fa fa-angle-right"></i></a><span class="hover"></span>
                <ul class="sub-menu">
                    <li><a onclick="loadPage('/message/admin/postmessage')">发送站内信<i class="fa fa-send pull-right"></i></a><span class="hover"></span></li>
                    <li><a onclick="loadPage('/message/admin/messagelist/'+admin)">站内信列表<i class="fa fa-file-o pull-right"></i></a><span class="hover"></span></li>
                </ul>
            </li>
            <li><a href="#"><i class="fa fa-users push"></i>用户管理<i class="fa fa-angle-right"></i></a><span class="hover"></span>
                <ul class="sub-menu">
                    <li><a onclick="loadPage('/user/admin/userlist')">用户<i class="fa fa-user pull-right"></i></a><span class="hover"></span></li>
                    <li><a onclick="loadPage('/admin/backusergroup')">用户组<i class="fa fa-group pull-right"></i></a><span class="hover"></span></li>
                </ul>
            </li>
            <li><a href="#" onclick="loadPage('/admin/backjoblist/')"><i class="fa fa-tasks push"></i>计算任务管理<i class="fa fa-angle-right"></i></a><span class="hover"></span>
            </li>
            <li id="datamanage"><a href="#"><i class="fa fa-cog push"></i>数据管理<i class="fa fa-angle-right"></i></a><span class="hover"></span>
                <ul class="sub-menu">
                    <li><a onclick="loadPage('/admin/datacategorylist')">数据目录管理<i class="fa fa-send pull-right"></i></a><span class="hover"></span></li>
                    <li><a onclick="loadPage('/admin/datasetlist')">数据集管理<i class="fa fa-file-o pull-right"></i></a><span class="hover"></span></li>
                </ul>
            </li>
            <li id="adminmanage" style="display: none"><a href="#"><i class="fa fa-cog push"></i>管理员管理<i class="fa fa-angle-right"></i></a><span class="hover"></span>
                <ul class="sub-menu">
                    <li><a onclick="loadPage('/admin/adminlist')">管理员列表<i class="fa fa-send pull-right"></i></a><span class="hover"></span></li>
                    <li><a onclick="registadmin()">添加管理员<i class="fa fa-file-o pull-right"></i></a><span class="hover"></span></li>
                </ul>
            </li>
            <li><a href="/admin/dologout"><i class="fa fa-sign-out push"></i>注销<i class="fa"></i></a><span class="hover"></span></li>
        </ul>
    </div>

    <!-- 内容 -->
    <div id="ucontent" class="col-xs-9" style="z-index: -1;margin-left: 300px">
        <h1>Content</h1>
    </div>

    <!-- 修改管理员权限modal -->
    <div class="modal fade" id="myModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title" id="myModalLabel">修改权限</h4>
                </div>
                <div class="modal-body">
                    <form id="pri-form" role="form" class="form-horizontal col-md-offset-1">
                        <div class="form-group">
                            <label class="col-xs-2 control-label">管理员账号：</label>
                            <div class="col-xs-4">
                                <input id="aid" name="aid" type="text" class="form-control" readonly="true"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-xs-2 control-label">设置权限：</label>
                            <div class="col-xs-4">
                                <select id="priority" name="priority" class="form-control">
                                    <option value="0">超级管理员</option>
                                    <option value="1">普通管理员</option>
                                    <option value="2">次级管理员</option>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="sbmt" type="button" class="btn btn-primary">提交更改</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div>
    <!-- 修改管理员权限modal end -->

    <!-- 添加用户组modal -->
    <div class="modal fade" id="groupModal" role="dialog" aria-labelledby="groupModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                    <h4 class="modal-title" id="groupModalLabel">添加用户组</h4>
                </div>
                <div class="modal-body">
                    <form id="groupform" role="form" class="form-horizontal col-md-offset-1">
                        <div class="form-group">
                            <label class="col-xs-3 control-label">用户组名称：</label>
                            <div class="col-xs-4">
                                <input id="groupname" name="groupname" type="text" class="form-control"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-xs-3 control-label">用户组权限：</label>
                            <label class="checkbox-inline">
                                <input type="checkbox" name="checkbox" value="public"> 公开共享
                            </label>
                            <label class="checkbox-inline">
                                <input type="checkbox" name="checkbox" value="protected"> 所内共享
                            </label>
                            <label class="checkbox-inline">
                                <input type="checkbox" name="checkbox" value="private"> 课题组共享
                            </label>
                            <input type="hidden" name="checkbox">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="addbtn" type="button" class="btn btn-primary">添加</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div>
    <!-- 添加用户组modal end -->

    <!--------------------------------------------ZMZ-START------------------------------------------------->
    <!-- 作业详细信息modal -->
    <!-- 作业详细信息参数modal -->
    <div class="modal fade" id="jobDetailModalArgs" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content container-fluid">
                <div class="modal-body row">
                    <div class="panel" style="border: none">
                        <div class="panel-heading text-center">
                            <h3 class="panel-title">详细信息</h3>
                        </div>
                        <div class="panel-body">
                            <form class="form-horizontal" enctype="multipart/form-data">
                                <fieldset>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label" for="djobId">作业ID：</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="djobId" name="djobId" readonly="true">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">经度范围：</label>
                                        <div class="col-sm-8 input-group" style="padding-left: 14px; padding-right: 14px;">
                                            <input type="text" class="form-control" id="dminlon" name="dminlon" readonly="true"><div class="input-group-addon">~</div><input type="text" class="form-control" id="dmaxlon" name="dmaxlon" readonly="true">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">纬度范围：</label>
                                        <div class="col-sm-8 input-group"  style="padding-left: 14px; padding-right: 14px;">
                                            <input type="text" class="form-control" id="dminlat" name="dminlat" readonly="true"><div class="input-group-addon">~</div><input type="text" class="form-control" id="dmaxlat" name="dmaxlat" readonly="true">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label">时间范围：</label>
                                        <div class="col-sm-8 input-group"  style="padding-left: 14px; padding-right: 14px;">
                                            <input type="text" class="form-control" id="dstart-time" name="dstartTime" readonly="true"><div class="input-group-addon">~</div><input type="text" class="form-control" id="dend-time" name="dendTime" readonly="true">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label" for="dstep-length">步长：</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="dstep-length" name="dstepLength" readonly="true">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label" for="dstdout">标准输出：</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" placeholder="dstdout" id="dstdout" name="stdout" readonly="true">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label" for="dstderr">标准错误：</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" placeholder="stderr" id="dstderr" name="dstderr" readonly="true">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label" for="ddir">工作目录：</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="ddir" name="ddir" readonly="true">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label" for="dnumbersOfCPU">CPU个数：</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="dnumbersOfCPU" name="dnumbersOfCPU" readonly="true">
                                        </div>
                                    </div>
                                        <%--                                    <div class="form-group">
                                                                                <label class="col-sm-3 control-label" for="duploadedFiles">上传的文件：</label>
                                                                                <div class="col-sm-8">
                                                                                    <textarea class="form-control" rows="3" id="duploadedFiles" name="duploadedFiles" readonly="true"></textarea>
                                                                                </div>
                                                                            </div>--%>
                                    <button class="btn btn-primary col-sm-offset-1" data-dismiss="modal" style="width: 83%;">关闭</button>
                                </fieldset>
                            </form>
                        </div>
                    </div>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>

    <!-- 作业详细信息脚本modal -->
    <div class="modal fade" id="jobDetailModalFile" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content container-fluid">
                <div class="modal-body row">
                    <div class="panel" style="border: none">
                        <div class="panel-heading text-center">
                            <h3 class="panel-title">详细信息</h3>
                        </div>
                        <div class="panel-body">
                            <form class="form-horizontal" id="submitForm" enctype="multipart/form-data">
                                <fieldset>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label" for="ddjobId">作业ID：</label>
                                        <div class="col-sm-8">
                                            <input type="text" class="form-control" id="ddjobId" name="ddjobId" readonly="true">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-3 control-label" for="duploadedFiles">上传的文件：</label>
                                        <div class="col-sm-8">
                                            <textarea class="form-control" rows="3" id="duploadedFiles" name="duploadedFiles" readonly="true"></textarea>
                                        </div>
                                    </div>
                                    <button class="btn btn-primary col-sm-offset-1" data-dismiss="modal" style="width: 83%;">关闭</button>
                                </fieldset>
                            </form>
                        </div>
                    </div>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal -->
    </div>

    <!--------------------------------------------ZMZ-END------------------------------------------------->

    <!-- 侧边栏js -->
    <script src="/js/usercenter-index.js"></script>

    <script>

        function registadmin(){
            if(checkPriority(0))
                loadPage('/admin/adminregist');
            else
                alert("您无权进行操作");
        }
        //解决页面含有javascript的问题
        function executeScript(html) {

            var reg = /<script[^>]*>([^\x00]+)$/i;
            //对整段HTML片段按<\/script>拆分
            var htmlBlock = html.split("<\/script>");
            for (var i in htmlBlock)
            {
                var blocks;//匹配正则表达式的内容数组，blocks[1]就是真正的一段脚本内容，因为前面reg定义我们用了括号进行了捕获分组
                if (blocks = htmlBlock[i].match(reg))
                {
                    //清除可能存在的注释标记，对于注释结尾-->可以忽略处理，eval一样能正常工作
                    var code = blocks[1].replace(/<!--/, '');
                    try
                    {
                        eval(code) //执行脚本
                    }
                    catch (e)
                    {
                    }
                }
            }
        }
        //点击显示相应页面
        function loadPage(url) {
            var xmlHttp;

            if (window.XMLHttpRequest) {
                // code for IE7+, Firefox, Chrome, Opera, Safari
                xmlHttp=new XMLHttpRequest();    //创建 XMLHttpRequest对象
            }
            else {
                // code for IE6, IE5
                xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
            }

            xmlHttp.onreadystatechange=function() {
                //onreadystatechange — 当readystate变化时调用后面的方法

                if (xmlHttp.readyState == 4) {
                    //xmlHttp.readyState == 4    ——    finished downloading response

                    if (xmlHttp.status == 200) {
                        //xmlHttp.status == 200        ——    服务器反馈正常

                        document.getElementById("ucontent").innerHTML=xmlHttp.responseText;    //重设页面中id="content"的div里的内容
                        executeScript(xmlHttp.responseText);    //执行从服务器返回的页面内容里包含的JavaScript函数
                    }
                    //错误状态处理
                    else if (xmlHttp.status == 404){
                        alert("出错了!   （错误代码：404 Not Found），……！");
                        /* 对404的处理 */
                        return;
                    }
                    else if (xmlHttp.status == 403) {
                        alert("出错了!   （错误代码：403 Forbidden），……");
                        /* 对403的处理  */
                        return;
                    }
                    else {
                        alert("出错了!   （错误代码：" + request.status + "），……");
                        /* 对出现了其他错误代码所示错误的处理   */
                        return;
                    }
                }

            }

            //把请求发送到服务器上的指定文件（url指向的文件）进行处理
            xmlHttp.open("GET", url, true);        //true表示异步处理
            xmlHttp.send();
        }

        $('#addbtn').on('click',function () {
            $.ajax({
                type:'post',
                url:'/admin/addusergroup/'+admin,
                cache:false,
                data:$('#groupform').serialize(),
                success:function(data){
                    if(data === "success"){
                        alert("添加成功");
                        loadPage('/admin/backusergroup');
                        $('#groupform')[0].reset();
                        $('#groupModal').modal('hide');
                    }else{
                        alert("添加失败");
                        $('#groupform')[0].reset();
                        $('#groupModal').modal('hide');
                    }
                },
                error:function (data) {
                    alert('添加失败');
                }
            });
        });
    </script>

</body>
</html>
