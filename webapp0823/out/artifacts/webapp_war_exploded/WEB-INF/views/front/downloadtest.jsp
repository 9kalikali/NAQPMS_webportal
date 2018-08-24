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
<%
    Cookie cookie = null;
    Cookie[] cookies = null;
    // 获取当前域名下的cookies，是一个数组
    cookies = request.getCookies();
    String userid = "";
    if (cookies != null) {
        for (int i = 0; i < cookies.length; i++) {
            cookie = cookies[i];
            if ((cookie.getName().compareTo("userid")) == 0) {
                userid = cookie.getValue();
            }
        }
    }
%>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>文件下载——测试</title>
    <style>
        .panel-group{height: 650px;overflow: hidden;}
        .leftMenu .panel-heading{font-size:14px;padding-left:20px;height:36px;line-height:36px;color: #5f5f5f;position:relative;cursor:pointer;}/*转成手形图标*/
        .leftMenu .panel-heading span{position:absolute;right:10px;top:12px;}
        .leftMenu .menu-item-left{padding: 2px; background: transparent; border:1px solid transparent;border-radius: 6px;}
        /*
                .leftMenu .menu-item-left:hover{background:#C4E3F3;border:1px solid #1E90FF;}
        */
        .list-group-item{background:#cccccc;border:1px solid #666666;}
        .list-group-item:hover{background:#c3c3c3;}
    </style>
<body>

<div class="container-fluid" style="padding-left: 100px; padding-right: 100px; margin-top: 60px">
    <div class="row">
        <div class="col-md-2" style="margin-top: 50px">
            <div class="pinned">
                <div class="panel-group table-responsive" role="tablist">
                <c:forEach items='${dirs}' var="dir">
                    <div class="panel panel-default leftMenu" style="margin-top: 0px;">
                        <!-- 利用data-target指定要折叠的分组列表 -->
                        <div class="panel-heading" id="collapseListGroupHeading${dir.firstLevel.categoryId}" data-toggle="collapse" data-target="#collapseListGroup${dir.firstLevel.categoryId}" role="tab" >
                            <h4 class="panel-title">
                                    ${dir.firstLevel.name}
                                <span class="glyphicon glyphicon-chevron-up right"></span>
                            </h4>
                        </div>
                        <!-- .panel-collapse和.collapse标明折叠元素 .in表示要显示出来 -->
                        <div id="collapseListGroup${dir.firstLevel.categoryId}" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="collapseListGroupHeading${dir.firstLevel.categoryId}">
                            <ul class="list-group">
                                <c:forEach items='${dir.secondLevel}' var="secondLevel">
                                    <li class="list-group-item">
                                        <!-- 利用data-target指定URL -->
                                        <button class="menu-item-left" onclick="loadDownloadPage('/datashare/page2/'+ ${secondLevel.categoryId})" style="text-align: left;">
                                            <span class="glyphicon glyphicon-triangle-right"></span>${secondLevel.name}
                                        </button>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div><!--panel end-->
                </c:forEach>

            </div>
            </div>
        </div>
        <div class="col-md-10">
            <div id="download_content">
            </div>
        </div>
    </div>
</div>
</body>
<script>

    $('#loadTest').click(function () {
        $.ajax({
            type: 'POST',
            url: '/datashare/listFiles',
            async: 'true',
            success: function (data) {
                $(document.getElementsByClassName('checkbox')).remove();
                var s = JSON.parse(data);
                for(var c in s){
                    $('#1').append(
                        "                <div class=\"checkbox\">\n" +
                        "                    <label>\n" +
                        "                        <input type=\"checkbox\" name=\"files\" value=\"" + s[c] +"\">" + s[c].substring(15) + "\n" +
                        "                    </label>\n" +
                        "                </div>"
                    );
                }
            }
        });
    });
    $(function(){
        $(".panel-heading").click(function(e){
            /*切换折叠指示图标*/
            $(this).find("span").toggleClass("glyphicon-chevron-down");
            $(this).find("span").toggleClass("glyphicon-chevron-up");
        });
    });
</script>
</html>

