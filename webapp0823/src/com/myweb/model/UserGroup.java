package com.myweb.model;

public class UserGroup {

    private int id;
    //用户组名称
    private String groupname;
    //公开数据
    private int data_public;
    //半公开数据
    private int data_protected;
    //非公开数据
    private int data_private;

    private String updater;

    private String updatetime;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUpdater() {
        return updater;
    }

    public void setUpdater(String updater) {
        this.updater = updater;
    }

    public String getUpdatetime() {
        return updatetime;
    }

    public void setUpdatetime(String updatetime) {
        this.updatetime = updatetime;
    }

    public String getGroupname() {
        return groupname;
    }

    public void setGroupname(String groupname) {
        this.groupname = groupname;
    }

    public int getData_public() {
        return data_public;
    }

    public void setData_public(int data_public) {
        this.data_public = data_public;
    }

    public int getData_protected() {
        return data_protected;
    }

    public void setData_protected(int data_protected) {
        this.data_protected = data_protected;
    }

    public int getData_private() {
        return data_private;
    }

    public void setData_private(int data_private) {
        this.data_private = data_private;
    }
}
