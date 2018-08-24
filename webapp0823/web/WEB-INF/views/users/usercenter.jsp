<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/13
  Time: 9:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>用户中心</title>
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
    <!-- 表单验证插件 -->
    <script src="/js/validator/jquery.validate.min.js"></script>
    <script src="/js/validator/localization/messages_zh.js"></script>
    <!-- 分页控件 -->
    <script src="/js/jqPaginator.min.js"></script>
    <script src="/js/jqPaginator.js"></script>
    <!---------------------------ZMZ-START -------------------------------->
    <!-- 表格插件--->
    <link rel="stylesheet" href="/bootstrap-table-master/bootstrap-table.css">
    <script src="/bootstrap-table-master/bootstrap-table.js"></script>
    <script src="/bootstrap-table-master/bootstrap-table-zh-CN.js"></script>
    <!---------------------------ZMZ-END------------------------------------->
    <script>
        var user;
        function getCookie(cname){
            var name = cname + "=";
            var ca = document.cookie.split(';');
            for(var i=0; i<ca.length; i++) {
                var c = ca[i].trim();
                if (c.indexOf(name)==0) { return c.substring(name.length,c.length); }
            }
            return "";
        }
        function checkLogin() {
            user=getCookie("userid");
            if (user != null && user != ""){
                loadPage("/user/${section}/"+user);
            }
        }
        $(function () {
            checkLogin();
        });
    </script>
</head>
<body>
<!-- 图片标题 -->
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation" style="margin-bottom: 0px">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">用户中心</a>
        </div>
    </div>
</nav>
<!-- 侧边栏菜单-->
<div class="sidebar" style="margin-top: 50px">
    <h3><i class="fa fa-bars push"></i>用户中心 <span class="color">菜单</span></h3>
    <ul style="padding-left: 30px">
        <li><a href="#" onclick="loadPage('/user/userindex/'+user)"><i class="fa fa-dashboard push"></i>首页<i class="fa fa-angle-right"></i></a><span class="hover"></span>
        </li>
        <li><a href="#"><i class="fa fa-tasks push"></i>计算任务<i class="fa fa-angle-right"></i></a><span class="hover"></span>
            <ul class="sub-menu">
                <li><a href="#" onclick="loadPage('/joblist/'+ user)">任务列表<i class="fa fa-tasks pull-right"></i></a><span class="hover"></span>
                </li>
                <li><a href="#" onclick="loadPage('/jobrecyclelist/'+user)">回收站<i class="fa fa-trash-o pull-right"></i></a><span class="hover"></span></li>
            </ul>
        </li>
        <li><a onclick="loadPage('/user/initmsglist/'+user)"><i class="fa fa-envelope push"></i>通知中心<i class="fa fa-angle-right"></i></a><span class="hover"></span>
        </li>
        <li><a href="#"><i class="fa fa-cog push"></i>设置<i class="fa fa-angle-right"></i></a><span class="hover"></span>
            <ul class="sub-menu">
                <li><a href="#" onclick="loadPage('/user/modifyuser/'+user)">编辑信息<i class="fa fa-edit pull-right"></i></a><span class="hover"></span></li>
                <li><a href="#" onclick="loadPage('/user/modifypwd/'+user)">修改密码<i class="fa fa-unlock-alt pull-right"></i></a><span class="hover"></span></li>
            </ul>
        </li>
        <li><a href="/user/dologout"><i class="fa fa-sign-out push"></i>注销<i class="fa"></i></a><span class="hover"></span></li>
    </ul>
</div>
<!-- 内容 -->
<div id="ucontent" class="col-xs-9" style="z-index: -1;margin-left: 300px">
    <h1>Content</h1>
</div>


<!-- 站内信modal -->
<div class="modal fade" id="msgModal" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title" id="myModalLabel">消息详情</h4>
            </div>
            <div id="msgbody" class="modal-body"></div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<!--------------------------------------------ZMZ-START------------------------------------------------->
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
                        <form class="form-horizontal" id="submitForm" enctype="multipart/form-data">
                            <fieldset>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label" for="djobId">作业ID：</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="djobId" name="dworkName" readonly="true">
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
                        <form class="form-horizontal" enctype="multipart/form-data">
                            <fieldset>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label" for="ddjobId">作业ID：</label>
                                    <div class="col-sm-8">
                                        <input type="text" class="form-control" id="ddjobId" name="djobId" readonly="true">
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


<!-- 作业结果展示modal -->
<div class="modal fade text-center" id="jobResultModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog" <%--style="display: inline-block; width: auto; height: 90%;"--%>>
        <div class="modal-content container-fluid">
            <div class="modal-body <%--row--%>">
                <div class="container-fluid">
                    <!-- 图片展示 -->
                    <div <%--class="col-sm-10 col-sm-offset-1"--%> style="padding-right: auto; padding-left: auto;">
                        <!-- 自制的ImagePlayer -->
                        <div class="row">
                            <div class="img-box" style="padding-left: 5%; padding-bottom: 0px">
                                <img name="animation" id="animation" src="/display/rain72_0_so2.png"/>
                            </div>
                        </div>
                        <div class="row" style="padding-left: auto;padding-right: auto">
                            <!-- 播放按钮 -->
                            <div class="">
                                <!-- 播放按钮组 -->
                                <div class="btn-group">
                                    <button type="button" class="btn btn-default" onclick="change_speed(delay_step)"><i class="fa fa-fast-backward"></i></button>
                                    <button type="button" class="btn btn-default"onclick="manualDecrement(--curImage)"><i class="fa fa-step-backward"></i> </button>
                                    <button type="button" class="btn btn-default" onclick="stop()"><i class="fa fa-stop"></i></button>
                                    <button type="button" class="btn btn-default" onclick="changeMode(1);playFwd()"><i class="fa fa-play"></i></button>
                                    <button type="button" class="btn btn-default" onclick="manualIncrement(++curImage)"><i class="fa fa-step-forward"></i></button>
                                    <button type="button" class="btn btn-default" onclick="change_speed(-delay_step)"><i class="fa fa-fast-forward"></i></button>
                                </div>
                            </div>
                        </div>
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

    var messagedetail = function (id) {
        //将该条信息标记为已读并获取详细信息
        $.ajax({
            type:'post',
            cache:false,
            url:'/message/readmessage/'+id,
            success:function (data) {
                $('#msgbody').html("<p>"+data+"</p>");
                //消息标题置灰
                $('#'+id).css('color','#aaaaaa');
            },
            error:function () {
                alert("网络异常！数据库同步失败！");
            }
        });
        //获取站内信内容
        $('#msgModal').modal('show').on('show.bs.modal',function (e) {
            // 设置居中关键代码，如没将modal设置为 block，则$modala_dialog.height() 为零
            $(this).css('display', 'block');
            var modalHeight=$(window).height() / 2 - $('#msgModal .modal-dialog').height() / 2;
            $(this).find('.modal-dialog').css({'margin-top': modalHeight});
        });
    }

    <!---------------------------------------------------ZMZ-START----------------------------->
    //***********************播放图片——START********************************
    first_image = 0;
    last_image = 0;
    modImages = new Array();
    //*****************图片源的设置**********************
    $("body").on('click', '.showResult', function () {
        jobId = $(this).parent().parent().parent().find('td').eq(0).text();
        $.ajax({
            type: "POST",
            url: "<%=request.getContextPath() %>/queryResult?jobId=" + jobId,
            async: "true",
            success: function (data) {
                setModImages(data);
                launch();
                $('#jobResultModal').modal('show');
            },
            error: function(xhr){alert(xhr.responseText)}
        });
    });

    function setModImages(imgList){
        //清空数组
        modImages.splice(0,modImages.length);
        theImages.splice(0,theImages.length);
        imageNum.splice(0,imageNum.length);
        //将数据转化为json
        var list = JSON.parse(imgList);
        for(var i = 0;i < list.length; i++){
            modImages.push(list[i]);
        }
        //对first和last重新赋值
        first_image = 0;
        last_image = modImages.length - 1;
        curImage = first_image;
        //预加载
        if(first_image > last_image){
            var temp = first_image;
            first_image = last_image;
            last_image = temp;
        }
        theImages[0] = new Image();
        theImages[0].src = modImages[0];
        imageNum[0] = true;
    }
    //=================ImagePlayer代码====================

    //全局变量
    theImages = new Array();
    imageNum = new Array();
    default_delay = 300; //默认播放间隔300ms
    delay_step = 150;
    delay_max = 6000;
    delay_min = 50;
    dwell_multipler = 3;
    dwell_step = 1;

    delay = default_delay;
    end_dwellMultipler = dwell_multipler;
    start_dewellMultipler = dwell_multipler;
    curImage = first_image;
    timeID = null;
    status = 0;     //0---停止；1---播放
    playMode = 0;  //0----正常；1----循环；2----快进
    sizeValid = 0;

    if(first_image > last_image){
        var temp = first_image;
        first_image = last_image;
        last_image = temp;
    }
    /**
     * 预加载第一张图片
     * @type {HTMLImageElement}
     */
    theImages[0] = new Image();
    theImages[0].src = modImages[0];
    imageNum[0] = true;

    /**
     * 停止播放
     */
    function stop() {
        if(status == 1){
            clearTimeout(timeID);
        }
        status = 0;
    }

    /**
     * 顺序播放图片
     */
    function animate_fwd(){
        curImage++;
        //判断当前是否播放到最后一张图片
        if(curImage > last_image){
            if(playMode == 1){
                curImage = first_image;
            }
            if(playMode == 2){
                curImage = last_image;
                animate_rev();
                return;
            }
        }

        while(imageNum[curImage - first_image] == false){
            curImage++;
            if(curImage > last_image){
                if(playMode == 1){
                    curImage = first_image;
                }
                if(playMode == 2){
                    curImage = last_image;
                    animate_rev();
                    return;
                }
            }
        }
        //替换图片源
        document.animation.src = theImages[curImage - first_image].src;
        //设置播放间隔
        delay_time = delay;
        if(curImage == first_image)
            delay_time = start_dewellMultipler * delay;
        if(curImage == last_image)
            delay_time = end_dwellMultipler * delay;
        //播放动画
        timeID = setTimeout("animate_fwd()", delay_time);
    }

    /**
     * 倒序播放动画
     */
    function animate_rev(){
        curImage--;

        if(curImage < first_image){
            if(playMode == 1){
                curImage = last_image;
            }
            if(playMode == 2){
                curImage == first_image;
                animate_fwd();
                return;
            }
        }

        while(imageNum[curImage - first_image] == false){
            curImage--;
            if (curImage < first_image) {
                if (play_mode == 1)
                    curImage = last_image;
                if (play_mode == 2) {
                    curImage = first_image;
                    animate_fwd();
                    return;
                }
            }
        }

        //替换图片源
        document.animation.src = theImages[curImage - first_image].src;
        //设置播放间隔
        delay_time = delay;
        if ( current_image == first_image) delay_time = start_dwell_multipler*delay;
        if (current_image == last_image)   delay_time = end_dwell_multipler*delay;

        timeID = setTimeout("animate_rev()", delay_time);
    }

    /**
     * 改变播放速度
     * @param ds
     */
    function change_speed(ds) {
        delay += ds;
        if(delay > delay_max)
            delay = delay_max;
        if(delay < delay_min)
            delay = delay_min;
    }

    /**
     * 改变停留时间
     * @param dv
     */
    function change_end_dwell(ds){
        end_dwellMultipler += ds;
        if(end_dwellMultipler < 1)
            end_dwellMultipler = 0;
    }

    function change_start_dwell(ds){
        start_dewellMultipler += ds;
        if(start_dewellMultipler < 1)
            start_dewellMultipler = 0;
    }

    /**
     * 手动播放下一帧
     * @param number
     */
    function manualIncrement(number) {
        stop();
        if(number > last_image)
            number = first_image;
        while(imageNum[number - first_image] == false){
            number++;
            if(number > last_image)
                number = first_image;
        }

        curImage = number;
        document.animation.src = theImages[curImage - first_image].src;
    }

    /**
     * 手动播放上一帧
     * @param number
     */
    function manualDecrement(number){
        stop();
        if(number < first_image)
            number = last_image;
        while(imageNum[number - first_image] == false){
            number--;
            if(number < first_image)
                number = last_image;
        }

        curImage = number;
        document.animation.src = theImages[curImage - first_image].src;
    }

    function playFwd(){
        stop();
        status = 1;
        playMode = 1;
        animate_fwd();
    }

    function playRev(){
        stop();
        status = 1;
        playMode = 1;
        animate_rev();
    }

    function playSweep(){
        stop();
        status = 1;
        playMode = 2;
        animate_fwd();
    }

    function changeMode(mode) {
        playMode = mode;
    }

    function launch() {
        for(var i = first_image + 1; i <= last_image; i++){
            theImages[i - first_image] = new Image();
            theImages[i - first_image].src = modImages[i-first_image];
            imageNum[i-first_image] = true;
            document.animation.src = theImages[i-first_image].src;
        }
        changeMode(1);
        playFwd();
    }

    function checkImage(status, i) {
        if(status == true)
            imageNum[i] = false;
        else imageNum[i] = true;
    }

    function animation() {
        count = first_image;
    }
    //***********************播放图片——END********************************
    <!---------------------------ZMZ-END----------------------------------->
</script>
</body>
</html>
