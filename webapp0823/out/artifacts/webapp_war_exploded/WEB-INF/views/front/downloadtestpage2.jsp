<%--
  Created by IntelliJ IDEA.
  User: Jedreck
  Date: 2018/4/26
  Time: 17:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <style>
        .detail ul {
            list-style:none; /* 将默认的列表符号去掉 */
            padding-left: 0px; /* 将默认的内边距去掉 */
            padding-top: 0px;
            padding-bottom: 0px;
            padding-right: 10px;
            margin:0; /* 将默认的外边距去掉 */
        }
        .detail li {
            list-style:none; /* 将默认的列表符号去掉 */
            padding-left: 0px; /* 将默认的内边距去掉 */
            padding-top: 0px;
            padding-bottom: 0px;
            padding-right: 10px;
            margin:0; /* 将默认的外边距去掉 */
            line-height: 40px;
            child-align: middle;
        }
        .l_title {
            float: left;
            font-size: 17px;
            font-family: serif;
            color: #4599ee;
            font-weight: bold;
            border: 1px solid #eeeeee;
            width: 150px;
            text-align: right;
        }
        .l_content {
            font-family: serif;
            border: 1px solid #eeeeee;
        }
    </style>
</head>
<body>
<div class="container-fluid" style="margin-top: 50px">
    <div class="row">
        <div class="col-md-offset-1">
            <h3 style="color: #2C7EEA;font-weight: bold;">
                <span class="glyphicon glyphicon-globe"></span>${dataset.name}
            </h3>
        </div>
        <hr style="margin-top:0px;height:10px;border:none;border-top:10px skyblue groove;" />
        <div id="row">
            <div class="detail col-md-6">
                <ul>
                    <li class="l_title">数据名称</li>
                    <li class="l_content">${dataset.name} </li>
                </ul>
                <ul>
                    <li class="l_title">关键字</li>
                    <li class="l_content">${dataset.keywords!=null?dataset.keywords: "不详"}</li>
                </ul>
                <ul>
                    <li class="l_title">更新频率</li>
                    <li class="l_content">${dataset.frequency}</li>
                </ul>
                <ul>
                    <li class="l_title">共享级别</li>
                    <li class="l_content">${dataset.shareLevel} </li>
                </ul>
                <ul>
                    <li class="l_title">用户手册</li>
                    <li class="l_content">${dataset.userManual!=null?dataset.userManual.substring(0,12): "不详"} </li>
                </ul>
                <ul>
                    <li class="l_title">数据源</li>
                    <li class="l_content">${dataset.source!=null?dataset.source: "不详"} </li>
                </ul>
            </div>
            <div class="detail col-md-6">
                <ul>
                    <li class="l_title">数据类型</li>
                    <li class="l_content">${dataset.dataType} </li>
                </ul>
                <ul>
                    <li class="l_title">数据起始时间</li>
                    <li class="l_content">${dataset.startTime}</li>
                </ul>
                <ul>
                    <li class="l_title">数据终止时间</li>
                    <li class="l_content">${dataset.endTime}</li>
                </ul>
                <ul>
                    <li class="l_title">数据大小</li>
                    <li class="l_content">${dataset.dataSize}</li>
                </ul>
                <ul>
                    <li class="l_title">分辨率</li>
                    <li class="l_content">${dataset.resolution!=null?dataset.resolution: "不详"}</li>
                </ul>
                <ul>
                    <li class="l_title">预报时长</li>
                    <li class="l_content">${dataset.forecastTime!=null?dataset.forecastTime: "不详"}</li>
                </ul>
                <ul>
                    <li class="l_title">范围</li>
                    <li class="l_content">${dataset.scope!=null?dataset.scope: "不详"}</li>
                </ul>
            </div>
        </div>
    </div>
    <div class="row">
        <button class="btn btn-info btn-block" id="loadTest">加载文件</button>
    </div>
    <div class="row" id="download-data" style="display: none">
        <form id="1" action="/datashare/downloadFiles" onsubmit="return check()" method="post">
            <div class="col-md-6" style="padding: 0px;">
            <table class="table table-condensed table-striped table-bordered table-hover" style="margin-bottom: 0px">
                    <thead>
                    <tr style="background-color: #b5ceff;">
                        <th>文件名</th>
                        <th>大小(Mbytes)</th>
                        <th>数据格式</th>
                        <th>文件内容</th>
                    </tr>
                    </thead>
                    <tbody class="tbody-left">
                    </tbody>
                </table>
            </div>
            <button type="submit" class="btn btn-success btn-block" id="datashare">下载文件</button>
        </form>
    </div>
</div>
</body>
<script>
    var userid= getCookie("userid");
    function isAllowed() {
        //验证是否登录
        if(checkIsLogin()){
            //验证用户组的权限
            if(hasPermission()){
                return true;
            }else {
                alert("用户权限不够！");
                return false;
            }
        }else {
            alert("请先登录！");
            return false;
        }
    }
    function checkIsLogin() {
        return (userid != null && userid !== "");
    }
    /*
    function hasPermission() {
		var dataLevel = "";
        if(dataLevel.match("仅课题内部共享")){
            dataLevel = "1"
        }else if(dataLevel.match("公开")){
            dataLevel= "0";
        }else {
            dataLevel = "2";
        }
        var result;
        var formData = new FormData();
        formData.append("dataLevel", dataLevel);
        formData.append("userId", userid);
        $.ajax({
            type: "POST",
            url: "datashare/checkPermission",
            async: false,
            data: formData,
            cache: false,
            processData: false,  // 不处理数据
            contentType: false,   // 不设置内容类型
            success: function (data) {
                result = data === "true"? true : false;
            }
        });
        return result;
    }
*/
    function showList(path){
        $.ajax({
            type: 'POST',
            url: '/datashare/listFiles/'+path,
            async: 'true',
            success: function (data) {
                document.getElementById('loadTest').setAttribute("disabled", "disabled");
                document.getElementById("download-data").style.display = "";
                if(data != "null"){
                    $.each(JSON.parse(data), function (idx, file) {
                        $('.tbody-left').append(
                            "                    <tr name=\"item\">\n" +
                            "                        <td><label><input type=\"checkbox\" name=\"files\" value=\""+file.filepath + "\">"+ file.filename+ "</label></td>\n" +
                            "                        <td>"+ file.filesize +"</td>\n" +
                            "                        <td>"+ file.filetype +"</td>\n" +
                            "                        <td><a href=\"/datashare/dataextract/"+ file.filename +"\">数据抽取</a></td>\n" +
                            "                    </tr>"
                        );
                    });
                    $('[name="item"]').on('click',function (e) {
                        //console.log(e.target.tagName);
                        if(e.target.tagName == 'TD'){
                            $('.tbody-left').empty();
                            var p = $(this).find('input').val();
                            p = encodeURIComponent(p);
                            showList(p);
                        }
                    });
                }else{
                    alert("没有了哦～");
                }
            }
        });
    }
    /*
    $('#loadTest').click(function () {
        if(isAllowed()){
            $.ajax({
                type: 'POST',
                url: '/datashare/listFiles?path=',
                async: 'true',
                success: function (data) {
                    document.getElementById('loadTest').setAttribute("disabled", "disabled");
                    document.getElementById("download-data").style.display = "";
                    var s = JSON.parse(data);
                    var total = s["total"];
                    var files = JSON.parse(s["files"]);
                    var flag = 0;
                    for(var file in files){
                        flag = flag + 1;
                        $(flag > total/2 ? '.tbody-right' : '.tbody-left').append(
                            "                    <tr>\n" +
                            "                        <td><label><input type=\"checkbox\" name=\"files\" value=\""+files[file] + "\">"+ files[file].substring(15)+ "</label></td>\n" +
                            "                        <td>18.71</td>\n" +
                            "                        <td>WMO GRIB2</td>\n" +
                            "                        <td>353 Grids</td>\n" +
                            "                    </tr>"
                        );
                    }
                }
            });
        }
    });*/



    $('#loadTest').on('click',function () {
        if(checkIsLogin()){
            var dataLevel = "${dataset.shareLevel}";
            if(dataLevel.match("仅课题内部共享")){
                dataLevel = "1"
            }else if(dataLevel.match("公开")){
                dataLevel= "0";
            }else {
                dataLevel = "2";
            }
            var result;
            var formData = new FormData();
            formData.append("dataLevel", dataLevel);
            formData.append("userId", userid);
            $.ajax({
                type: "POST",
                url: "/datashare/checkPermission",
                async: true,
                data: formData,
                cache: false,
                processData: false,  // 不处理数据
                contentType: false,   // 不设置内容类型
                success: function (data) {
                    if(data === 'true'){
                        showList('init')
                    }else{
                        alert("用户权限不够！");
                    }
                },
                error:function () {
                    alert('网络异常！');
                }
            });
        }else{
            alert("请先登录！");
        }
    })
</script>
</html>
