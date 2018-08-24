package com.myweb.model;

/**
 * 分页相关信息
 */
public class PageInfo {
    /**
     * 页码
     */
    private int pageNum;
    /**
     * 一页显示的数量
     */
    private int pageSize;
    /**
     * 查询时起始位置
     */
    private int dbOffset;
    /**
     * 总记录数
     */
    private int totalNum;


    public int getPageNum() {
        return pageNum;
    }

    public void setPageNum(int pageNum) {
        this.pageNum = pageNum;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getDbOffset() {
        return dbOffset;
    }

    public void setDbOffset() {
        int offset = 0;
        if(pageNum != 0)
            offset = (pageNum - 1) * pageSize;
        this.dbOffset = offset;
    }

    public int getTotalNum() {
        return totalNum;
    }

    public void setTotalNum(int totalNum) {
        this.totalNum = totalNum;
    }

    /**
     * 获取总页数
     * @return
     */
    public int count(){
        int pages = totalNum / pageSize;
        int odd = totalNum%pageSize == 0 ? 0 : 1;
        int totalPages = pages + odd;

        return totalPages;
    }
}
