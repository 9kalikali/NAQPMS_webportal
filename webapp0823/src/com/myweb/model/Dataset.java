package com.myweb.model;

public class Dataset {
    private int datasetId;
    private int categoryId;
    private String name;            //数据名称
    private String keywords;        //关键字
    private String datasetDesc;     //数据集描述
    private String userManual;      //用户手册
    private String frequency;       //更新频率
    private String shareLevel;      //共享级别   '0:仅项目内部使用','1:仅课题内部共享','2:公开'
    private String source;          //数据提供
    private String startTime;       //数据开始时间
    private String endTime;         //结束时间
    private String dataType;        //数据类型  'grib2','新Z格式','BZ2'
    private String dataSize;        //数据大小
    private String resolution;      //分辨率
    private String forecastTime;    //预报时长
    private String scope;           //范围
    private String path;            //数据路径

    public int getDatasetId() {
        return datasetId;
    }

    public void setDatasetId(int datasetId) {
        this.datasetId = datasetId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getKeywords() {
        return keywords;
    }

    public void setKeywords(String keywords) {
        this.keywords = keywords;
    }

    public String getDatasetDesc() {
        return datasetDesc;
    }

    public void setDatasetDesc(String datasetDesc) {
        this.datasetDesc = datasetDesc;
    }

    public String getUserManual() {
        return userManual;
    }

    public void setUserManual(String userManual) {
        this.userManual = userManual;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public String getShareLevel() {
        return shareLevel;
    }

    public void setShareLevel(String shareLevel) {
        this.shareLevel = shareLevel;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public String getDataSize() {
        return dataSize;
    }

    public void setDataSize(String dataSize) {
        this.dataSize = dataSize;
    }

    public String getResolution() {
        return resolution;
    }

    public void setResolution(String resolution) {
        this.resolution = resolution;
    }

    public String getForecastTime() {
        return forecastTime;
    }

    public void setForecastTime(String forecastTime) {
        this.forecastTime = forecastTime;
    }

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }
}
