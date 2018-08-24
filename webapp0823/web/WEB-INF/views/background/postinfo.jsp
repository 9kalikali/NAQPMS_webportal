<%--
  Created by IntelliJ IDEA.
  User: Ren
  Date: 2018/3/20
  Time: 9:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>信息发布</title>
</head>
<body>
    <div class="container-fluid" style="padding-top: 10%">
        <div class="row">
                <form id="post-form" role="form" method="post" class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-1 control-label" for="title">标题</label>
                        <div class="col-sm-5">
                            <input type="text" class="form-control col-xs-5" id="title" name="title" placeholder="请输入标题">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-1 control-label" for="type">类型</label>
                        <div class="col-sm-3">
                            <select id="type" name="type" class="form-control">
                                <option value="NEWS">新闻公告</option>
                                <option value="ARTICLE">专题文章</option>
                                <option value="QUESTION">常见问题</option>
                            </select>
                        </div>
                    </div>
                    <div id="my-editor" class="form-group">
                        <textarea id="md-doc" name="md-doc" class="form-control" style="display: none"></textarea>
                        <textarea id="md-code" name="md-code" class="form-control" style="display: none"></textarea>
                    </div>
                    <div class="form-group">
                        <div class="col-xs-offset-2 col-xs-10">
                            <button type="submit" class="btn btn-default">提交</button>
                        </div>
                    </div>
                </form>
        </div>
    </div>

    <script>
        $(function () {
           editormd('my-editor',{
               width:'100%',
               height:400,
               syncScrolling: 'single',
               path:'/mdeditor/lib/',
               saveHTMLToTextarea:true,
               taskList: true,
               tocm: true, // Using [TOCM]
               tex: true,// 开启科学公式TeX语言支持
               flowChart: true,//开启流程图支持
               sequenceDiagram: true,//开启时序/序列图支持
               dialogLockScreen : false,//设置弹出层对话框不锁屏，全局通用
               dialogShowMask : false,//设置弹出层对话框显示透明遮罩层，全局通用
               dialogDraggable : false,//设置弹出层对话框不可拖动，全局通用
               dialogMaskOpacity : 0.4, //设置透明遮罩层的透明度，全局通用，默认值为0.1
           });
        });
        $('#post-form').on('submit',function () {
            $.ajax({
                type: 'post',
                data: $('#post-form').serialize(),
                url: '/platforminfo/dopostinfo',
                cache: false,
                success: function (data) {
                    if ("success" == data) {
                        alert("发布成功");
                        //跳转到后台的文章列表
                        //loadPage();
                    }
                    if ("fail" == data){
                        alert("发布失败！请尝试重新登陆。");
                    }
                }
            });
            return false;
        });
    </script>
</body>
</html>
