<%--
  Created by IntelliJ IDEA.
  User: renxuanzhengbo
  Date: 2018/4/2
  Time: 下午3:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>发送站内信</title>
</head>
<body>
    <div class="container-fluid" style="padding-top: 10%">
        <div class="row">
            <h3>发送站内信</h3>
            <form id="post-form" role="form" method="post" class="form-horizontal">
                <div class="form-group">
                    <label class="col-sm-1 control-label">发信人:</label>
                    <div class="col-sm-3">
                        <p id="sendidp" class="form-control-static"></p>
                        <input type="text" class="form-control" id="sendid" name="sendid" style="display: none">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-1 control-label" for="type">收信人:</label>
                    <div class="col-sm-1">
                        <select id="type" name="type" class="form-control">
                            <option value="specify">个人</option>
                            <option value="0">全体</option>
                        </select>
                    </div>
                    <div class="col-sm-3">
                        <input type="text" class="form-control col-sm-3" id="recid" name="recid" placeholder="请输入收信人ID">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-1 control-label">内容:</label>
                    <div class="col-sm-10">
                        <textarea name="msg-content" class="form-control" rows=15></textarea>
                    </div>
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
            $('#sendidp').html(admin);
            $('#sendid').val(admin);
        })
        $('#type').on('change',function () {
            if($(this).val() == '0'){
                $('#recid').attr('disabled',true);
                $('#recid').val('0');
            }else{
                $('#recid').attr('disabled',false);
                $('#recid').val('');
            }
        });
        $('#post-form').on('submit',function () {
            $.ajax({
                type: 'post',
                data: $('#post-form').serialize(),
                url: '/message/dopostmessage',
                cache: false,
                success: function (data) {
                    if ("success" == data) {
                        alert("发布成功");
                        //跳转到后台的站内信列表
                        loadPage('/message/admin/messagelist/'+admin);
                    }
                    if ("fail" == data){
                        alert("发布失败！请尝试重新登陆。");
                    }
                },
                error:function () {
                    alert("网络异常，请重试");
                }
            });
            return false;
        });
    </script>
</body>
</html>
