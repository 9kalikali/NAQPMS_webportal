package com.myweb.dao;

import com.myweb.mapper.DatasetMapper;
import com.myweb.model.Dataset;
import com.myweb.model.DatasetCategory;
import com.myweb.myutils.DBUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.ArrayList;
import java.util.List;

public class DatasetDao {
    public Dataset getDatasetByCategoryId(String categoryId) {
        SqlSession sqlSession = null;
        Dataset result = null;
        try{
            sqlSession = DBUtil.getSqlSession();
            DatasetMapper mapper = sqlSession.getMapper(DatasetMapper.class);
            result = mapper.getDatasetByCategoryId(categoryId);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            sqlSession.rollback();
            result = null;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
            return result;
        }
    }

    public int queryCount() {
        SqlSession sqlSession = null;
        int result = -1;
        try{
            sqlSession = DBUtil.getSqlSession();
            DatasetMapper mapper = sqlSession.getMapper(DatasetMapper.class);
            result = mapper.getCount();
        }catch (Exception e){
            e.printStackTrace();
            sqlSession.rollback();
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
            return result;
        }
    }

    public List<Dataset> selectAll() {
        SqlSession sqlSession = null;
        List<Dataset> result = null;
        try{
            sqlSession = DBUtil.getSqlSession();
            DatasetMapper mapper = sqlSession.getMapper(DatasetMapper.class);
            result = mapper.selectAll();
        }catch (Exception e){
            e.printStackTrace();
            sqlSession.rollback();
            result = null;
        }finally {
            return result;
        }
    }

    public List<Dataset> selectByCategoryId(String categoryId) {
        SqlSession sqlSession = null;
        List<Dataset> result = null;
        try{
            sqlSession = DBUtil.getSqlSession();
            DatasetMapper mapper = sqlSession.getMapper(DatasetMapper.class);
            result = mapper.selectByCategoryId(categoryId);
        }catch (Exception e){
            e.printStackTrace();
            sqlSession.rollback();
            result = null;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
            return result;
        }
    }

    public ArrayList<DatasetCategory> getFirstDir() {
        SqlSession sqlSession = null;
        ArrayList<DatasetCategory> result = null;
        try{
            sqlSession = DBUtil.getSqlSession();
            DatasetMapper mapper = sqlSession.getMapper(DatasetMapper.class);
            result = mapper.queryFirstDir();
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            if(sqlSession != null)
                sqlSession.rollback();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return result;
    }

    public ArrayList getSecondDir() {
        SqlSession sqlSession = null;
        ArrayList<DatasetCategory> result = null;
        try{
            sqlSession = DBUtil.getSqlSession();
            DatasetMapper mapper = sqlSession.getMapper(DatasetMapper.class);
            result = mapper.querySecondDir();
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            if(sqlSession != null)
                sqlSession.rollback();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return result;
    }
}
