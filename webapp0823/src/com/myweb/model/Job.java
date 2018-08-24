package com.myweb.model;

public class Job {
    private int ID;
    private String jobId;
    private String userId;
    //作业状态 ！！有默认值0！！
    private String status;
    //提交的类型:参数或者文件，"args"\"file"
    private String type;
    //作业提交时间 ！！有默认值！！
    private String submitTime;
    //作业完成的时间
    private String finishTime;
    //结果存放的路径
    private String resultsPath;
    //是否在回收站中！！有默认值！！
    private String isRecycled;

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getJobId() {
        return jobId;
    }

    public void setJobId(String jobId) {
        this.jobId = jobId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSubmitTime() {
        return submitTime;
    }

    public void setSubmitTime(String submitTime) {
        this.submitTime = submitTime;
    }

    public String getFinishTime() {
        return finishTime;
    }

    public void setFinishTime(String finishTime) {
        this.finishTime = finishTime;
    }

    public String getResultsPath() {
        return resultsPath;
    }

    public void setResultsPath(String resultsPath) {
        this.resultsPath = resultsPath;
    }

    public String getIsRecycled() {
        return isRecycled;
    }

    public void setIsRecycled(String isRecycled) {
        this.isRecycled = isRecycled;
    }
}
