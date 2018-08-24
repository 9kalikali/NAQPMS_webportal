package com.myweb.model;

public class Question {

    private int ID;
    private String Qtitle;
    private String Qauthor;
    private String Qcontent;
    private String Qdatetime;

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getQtitle() {
        return Qtitle;
    }

    public void setQtitle(String qtitle) {
        Qtitle = qtitle;
    }

    public String getQauthor() {
        return Qauthor;
    }

    public void setQauthor(String qauthor) {
        Qauthor = qauthor;
    }

    public String getQcontent() {
        return Qcontent;
    }

    public void setQcontent(String qcontent) {
        Qcontent = qcontent;
    }

    public String getQdatetime() {
        return Qdatetime;
    }

    public void setQdatetime(String qdatetime) {
        Qdatetime = qdatetime;
    }


}
