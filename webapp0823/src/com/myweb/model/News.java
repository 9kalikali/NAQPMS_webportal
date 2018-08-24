package com.myweb.model;

/**
 * 新闻公告类
 */
public class News {

    private int ID;
    //标题
    private String Ntitle;
    //作者
    private String Nauthor;
    //内容
    private String Ncontent;
    //发布时间
    private String Ndatetime;

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getNtitle() {
        return Ntitle;
    }

    public void setNtitle(String ntitle) {
        Ntitle = ntitle;
    }

    public String getNauthor() {
        return Nauthor;
    }

    public void setNauthor(String nauthor) {
        Nauthor = nauthor;
    }

    public String getNcontent() {
        return Ncontent;
    }

    public void setNcontent(String ncontent) {
        Ncontent = ncontent;
    }

    public String getNdatetime() {
        return Ndatetime;
    }

    public void setNdatetime(String ndatetime) {
        Ndatetime = ndatetime;
    }
}
