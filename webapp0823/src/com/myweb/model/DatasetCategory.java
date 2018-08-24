package com.myweb.model;

import java.util.Date;

public class DatasetCategory {
    private String name;
    private int categoryId;
    private int parentId;
    private Boolean isParent;
    private Date created;
    private Date updated;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public Boolean getParent() {
        return isParent;
    }

    public void setParent(Boolean parent) {
        isParent = parent;
    }

    public Date getCreated() {
        return created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public Date getUpdated() {
        return updated;
    }

    public void setUpdated(Date updated) {
        this.updated = updated;
    }

    public String toString(){
        return "目录名：" + this.getName() + " 目录id：" + this.getCategoryId() + " 上一级目录id：" + this.getParentId() + "是否有下一级目录："+ this.getParent();
    }
}
