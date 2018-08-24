package com.myweb.model;

/**
 * 作业参数的Model
 * 目前为待定参数
 */
public class JobDetail {

    private String jobid;
    //最大经纬度
    private String maxlon;
    private String maxlat;
    //最小经纬度
    private String minlon;
    private String minlat;
    //中央经纬度
    private String cenlon;
    private String cenlat;
    //分辨率km
    private int steplength;
    //绘制时间跨度
    private String startTime;
    private String endTime;
    //提交参数
    private String stdout;
    private String stderr;
    private String dir;
    private int cpus;
    //提交脚本
    private String scriptfilenames;
    private String scriptfilepath;

    public String getJobid() {
        return jobid;
    }

    public void setJobid(String jobid) {
        this.jobid = jobid;
    }

    public String getMaxlon() {
        return maxlon;
    }

    public void setMaxlon(String maxlon) {
        this.maxlon = maxlon;
    }

    public String getMaxlat() {
        return maxlat;
    }

    public void setMaxlat(String maxlat) {
        this.maxlat = maxlat;
    }

    public String getMinlon() {
        return minlon;
    }

    public void setMinlon(String minlon) {
        this.minlon = minlon;
    }

    public String getMinlat() {
        return minlat;
    }

    public void setMinlat(String minlat) {
        this.minlat = minlat;
    }

    public String getCenlon() {
        return cenlon;
    }

    public void setCenlon(String cenlon) {
        this.cenlon = cenlon;
    }

    public String getCenlat() {
        return cenlat;
    }

    public void setCenlat(String cenlat) {
        this.cenlat = cenlat;
    }

    public int getSteplength() {
        return steplength;
    }

    public void setSteplength(int steplength) {
        this.steplength = steplength;
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

    public String getStdout() {
        return stdout;
    }

    public void setStdout(String stdout) {
        this.stdout = stdout;
    }

    public String getStderr() {
        return stderr;
    }

    public void setStderr(String stderr) {
        this.stderr = stderr;
    }

    public String getDir() {
        return dir;
    }

    public void setDir(String dir) {
        this.dir = dir;
    }

    public int getCpus() {
        return cpus;
    }

    public void setCpus(int cpus) {
        this.cpus = cpus;
    }

    public String getScriptfilenames() {
        return scriptfilenames;
    }

    public void setScriptfilenames(String scriptfilenames) {
        this.scriptfilenames = scriptfilenames;
    }

    public String getScriptfilepath() {
        return scriptfilepath;
    }

    public void setScriptfilepath(String scriptfilepath) {
        this.scriptfilepath = scriptfilepath;
    }
}
