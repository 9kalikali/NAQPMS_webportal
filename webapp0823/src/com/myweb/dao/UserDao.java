package com.myweb.dao;

import com.myweb.mapper.UserMapper;
import com.myweb.model.Chart;
import com.myweb.model.User;
import com.myweb.model.UserGroup;
import com.myweb.myutils.DBUtil;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class UserDao {

    public List<User> queryAllUser(){
        SqlSession sqlSession = null;
        List<User> userList = new ArrayList<User>();
        try {
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            userList = mapper.queryAllUser();
            //返回数据
            return userList;
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    public User queryUserByID(int id){
        SqlSession sqlSession = null;
        try {
            sqlSession = DBUtil.getSqlSession();
            //通过sqlSession执行SQL语句
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            User result = mapper.queryUserByID(id);
            //返回数据
            return result;
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    public User queryUserByUid(String userid){
        SqlSession sqlSession = null;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            User resulr = mapper.queryUserByUid(userid);
            return resulr;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    public boolean queryLogin(User user){
        SqlSession sqlSession = null;
        try {
            sqlSession = DBUtil.getSqlSession();
            //获取mapper的SQL语句
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            //查询出的是password
            String result = mapper.queryLogin(user.getUserid());
            //校验返回结果
            if(result != null && !"".equals(result)&& result.equals(user.getPassword())){
                return true;
            }
            return false;
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return false;
    }

    public int registUser(User user){
        SqlSession sqlSession = null;
        int result = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            //通过sqlSession执行SQL语句
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            result = mapper.registUser(user);
            //没有设置自动提交的话需要手动提交
            sqlSession.commit();
        } catch (IOException e) {
            e.printStackTrace();
            sqlSession.rollback();
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        //返回数据
        return result;
    }

    public int deleteUserById(int id){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            result = mapper.deleteUserById(id);
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

    public int checkUserid(String userid){
        SqlSession sqlSession = null;
        int count = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            count = mapper.checkUserid(userid);
        }catch (Exception e){
            e.printStackTrace();
            count = -1;
            return count;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
            return count;
        }
    }

    public int checkEmail(String email){
        SqlSession sqlSession = null;
        int count = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            count = mapper.chekEmail(email);
        }catch (Exception e){
            e.printStackTrace();
            count = -1;
            //return count;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
            return count;
        }
    }

    public int updatePassword(User user){
        SqlSession sqlSession = null;
        int count=0;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            count = mapper.updatePassword(user);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            sqlSession.rollback();
            count = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
            return count;
        }
    }

    public int updateUserInfo(User user){
        SqlSession sqlSession = null;
        int count = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            count = mapper.updateUserInfo(user);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            sqlSession.rollback();
            count = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
            return count;
        }
    }

    /**
     * 按条件分页查询用户
     * @param parameter
     * @return
     */
    public List<User> queryUserByPage(Map<String,Object> parameter){
        SqlSession sqlSession = null;
        List<User> resultList = new ArrayList<User>();
        try{
            sqlSession = DBUtil.getSqlSession();
            resultList = sqlSession.selectList("User.queryUserByPage",parameter);
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

    /**
     * 查询用户数量
     * @return
     */
    public int queryUserCount(){
        SqlSession sqlSession = null;
        int count = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            count = mapper.getUserConut();
        }catch (Exception e){
            e.printStackTrace();
            count = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();

            }
        }
        return count;
    }

    /**
     * 按用户组名称查询用户组
     * @param group
     * @return
     */
    public UserGroup queryUserGroup(String group){
        SqlSession sqlSession = null;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            UserGroup userGroup = mapper.queryUserGroup(group);
            return userGroup;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    /**
     * 添加用户组
     * @param userGroup 用户组实体
     * @return
     */
    public int insertUserGroup(UserGroup userGroup){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            result = mapper.insertUserGroup(userGroup);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            if(sqlSession != null){
                sqlSession.rollback();
            }
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return result;
    }

    /**
     * 更改用户组信息
     * @param userGroup 用户组实体
     * @return
     */
    public int updateUserGroup(UserGroup userGroup){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            result = mapper.updateUserGroup(userGroup);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            if(sqlSession != null){
                sqlSession.rollback();
            }
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return result;
    }

    /**
     * 删除用户组
     * @param id
     * @return
     */
    public int deleteUserGroup(int id){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            result = mapper.deleteUserGroup(id);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            if(sqlSession != null){
                sqlSession.rollback();
            }
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return result;
    }

    /**
     * 分页查询用户组
     * @param parameter
     * @return
     */
    public List<UserGroup> queryUserGroupByPage(Map parameter){
        SqlSession sqlSession = null;
        List<UserGroup> resultList = new ArrayList<UserGroup>();
        try{
            sqlSession = DBUtil.getSqlSession();
            resultList = sqlSession.selectList("User.queryUserGroupByPage",parameter);
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

    /**
     * 后台更改用户信息
     * 可以更改用户的用户组
     * @param user
     * @return
     */
    public int updateUserInfoBack(User user){
        SqlSession sqlSession = null;
        int count = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            count = mapper.updateUserInfoBack(user);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            sqlSession.close();
            sqlSession.rollback();
            count = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return count;
    }

    /**
     *查询当年每月用户新增数量
     * @param year
     * @return
     */
    public List<Chart> queryUserCountByMonth(String year){
        SqlSession sqlSession = null;
        List<Chart> resultlist = null;
        try{
            sqlSession = DBUtil.getSqlSession();
            UserMapper mapper = sqlSession.getMapper(UserMapper.class);
            resultlist = mapper.queryUserCountByMonth(year);
            return resultlist;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return resultlist;
    }

//    public static void main(String[] args){
//        UserDao dao = new UserDao();
//        UserGroup userGroup = new UserGroup();
//        userGroup.setId(4);
//        int r = dao.deleteUserGroup(4);
//        System.out.println(r);
//    }
}
