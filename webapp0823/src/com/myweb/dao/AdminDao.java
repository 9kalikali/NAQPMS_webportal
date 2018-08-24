package com.myweb.dao;

import com.myweb.mapper.AdminMapper;
import com.myweb.model.Admin;
import com.myweb.myutils.DBUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class AdminDao {

    public List<Admin> queryAllAdmin(){
        SqlSession sqlSession = null;
        List<Admin> adminList;
        try{
            sqlSession = DBUtil.getSqlSession();
            AdminMapper mapper = sqlSession.getMapper(AdminMapper.class);
            adminList = mapper.queryAllAdmin();

            return adminList;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    public Admin queryAdminByID(int id){
        SqlSession sqlSession = null;
        Admin admin;
        try{
            sqlSession = DBUtil.getSqlSession();
            AdminMapper mapper = sqlSession.getMapper(AdminMapper.class);
            admin = mapper.queryAdminByID(id);
            return admin;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    public Admin queryAdminByAid(String adminid){
        SqlSession sqlSession = null;
        Admin admin;
        try{
            sqlSession = DBUtil.getSqlSession();
            AdminMapper mapper = sqlSession.getMapper(AdminMapper.class);
            admin = mapper.queryAdminByAid(adminid);
            return admin;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    public boolean queryAdminLogin(Admin admin){
        SqlSession sqlSession = null;
        try{
            sqlSession = DBUtil.getSqlSession();
            AdminMapper mapper = sqlSession.getMapper(AdminMapper.class);
            String result = mapper.queryLogin(admin.getAdminid());
            if(result !=null && !"".equals(result) && result.equals(admin.getAdminpassword())){
                return true;
            }
            return false;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return false;
    }

    public int deleteAdminByID(int id){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            AdminMapper mapper = sqlSession.getMapper(AdminMapper.class);
            result = mapper.deleteAdminById(id);
            sqlSession.commit();
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

    public int modifyPriority(Admin admin){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession  = DBUtil.getSqlSession();
            AdminMapper mapper = sqlSession.getMapper(AdminMapper.class);
            result = mapper.modifyPriority(admin);
            sqlSession.commit();
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

    public List<Admin> queryAdminByPage(Map<String,Object> parameter){
        SqlSession sqlSession = null;
        List<Admin> resultList = new ArrayList<Admin>();
        try{
            sqlSession = DBUtil.getSqlSession();
            resultList = sqlSession.selectList("Admin.queryAdminByPage",parameter);
            return resultList;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    public int registAdmin(Admin admin){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            AdminMapper mapper = sqlSession.getMapper(AdminMapper.class);
            result = mapper.registAdmin(admin);
            sqlSession.commit();
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

}
