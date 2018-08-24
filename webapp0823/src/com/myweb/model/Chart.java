package com.myweb.model;

/**
 *用于接受用户表或计算任务表的统计信息
 */
public class Chart {

    //横轴坐标轴
    private String categories;
    //数据
    private int ydata;

    public int getYdata() {
        return ydata;
    }

    public void setYdata(int ydata) {
        this.ydata = ydata;
    }

    public String getCategories() {
        return categories;
    }

    public void setCategories(String categories) {
        this.categories = categories;
    }


}
