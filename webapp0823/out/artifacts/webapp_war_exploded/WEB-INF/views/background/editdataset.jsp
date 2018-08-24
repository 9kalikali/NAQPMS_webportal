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
    <title>修改数据集信息</title>
<body>

    <div class="container-fluid">
        <div class="row">
            <div class="col-xs-offset-5">
                <h3 style="margin-bottom: 5%;">修改数据集信息</h3>
            </div>
            <%--modelAttribute="Dataset"--%>
            <div>
                <form id="editDatasetForm" role="form" class="form-horizontal col-md-offset-1">
                  <div class="col-xs-6">
                      <div class="form-group">
                          <label class="col-xs-4 control-label">数据集ID：</label>
                          <div class="col-xs-6">
                              <input id="datasetId" path="datasetId" name="datasetId" type="text" class="form-control" readonly="true" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">关键字：</label>
                          <div class="col-xs-6">
                              <input  id="keywords" name="keywords" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">用户手册：</label>
                          <div class="col-xs-6">
                              <input id="userManual" name="userManual" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">共享级别：</label>
                          <div class="col-xs-6">
                              <input id="shareLevel" name="shareLevel" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">数据开始时间：</label>
                          <div class="col-xs-6">
                              <input id="startTime" name="startTime" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">数据类型：</label>
                          <div class="col-xs-6">
                              <input id="dataType" name="dataType" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">分辨率：</label>
                          <div class="col-xs-6">
                              <input id="resolution" name="resolution" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">数据路径：</label>
                          <div class="col-xs-6">
                              <input id="path" name="path" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                  </div>
                  <div class="col-xs-6">
                      <div class="form-group">
                          <label class="col-xs-4 control-label">数据名称：</label>
                          <div class="col-xs-6">
                              <input  id="name" name="name" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">描述：</label>
                          <div class="col-xs-6">
                              <input  id="datasetDesc" name="datasetDesc" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">更新频率：</label>
                          <div class="col-xs-6">
                              <input id="frequency" name="frequency" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">数据提供：</label>
                          <div class="col-xs-6">
                              <input  id="source" name="source" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">数据结束时间：</label>
                          <div class="col-xs-6">
                              <input id="endTime" name="endTime" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">数据大小：</label>
                          <div class="col-xs-6">
                              <input  id="dataSize" name="dataSize" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">预报时长：</label>
                          <div class="col-xs-6">
                              <input id="forecastTime" name="forecastTime" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                      <div class="form-group">
                          <label class="col-xs-4 control-label">范围：</label>
                          <div class="col-xs-6">
                              <input id="scope" name="scope" type="text" class="form-control" value=""/>
                          </div>
                      </div>
                  </div>
                    <div class="form-group">
<%--
                        <button id="btncancel" type="submit" class="btn btn-primary col-xs-offset-3">取消</button>
--%>
                        <button id="btnEditDataset" type="submit" class="btn btn-primary col-xs-offset-5">提交更改</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
<script>

</script>
</body>
</html>

