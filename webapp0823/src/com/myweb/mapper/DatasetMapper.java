package com.myweb.mapper;

import com.myweb.model.Dataset;
import com.myweb.model.DatasetCategory;
import org.apache.ibatis.annotations.Select;

import java.util.ArrayList;
import java.util.List;

public interface DatasetMapper {
    @Select("select * from dataset where categoryid=#{categoryId}")
    public Dataset getDatasetByCategoryId(String categoryId);

    @Select("select count(*) from dataset")
    int getCount();

    @Select("select * from dataset")
    List<Dataset> selectAll();

    @Select("select * from dataset where categoryid=#{categoryId}")
    List<Dataset> selectByCategoryId(String categoryId);

    @Select("select * from dataset_category where parentid = 0")
    ArrayList<DatasetCategory> queryFirstDir();

    @Select("select * from dataset_category where parentid != 0")
    ArrayList<DatasetCategory> querySecondDir();
}
