package com.myweb.service.impl;

import com.myweb.dao.UserDao;
import com.myweb.model.Chart;
import com.myweb.model.PageInfo;
import com.myweb.model.User;
import com.myweb.model.UserGroup;
import com.myweb.service.UserService;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("userService")
public class UserServiceImpl implements UserService{

    private final static int PAGE_SIZE = 10;
    private final static int PUBLIC_DATA = 0;
    private final static int PROTECTED_DATA = 1;
    private final static int PRIVATE_DATA = 2;

    @Override
    public List<User> queryAllUser() {
        UserDao userDao = new UserDao();
        return userDao.queryAllUser();
    }

    @Override
    public List<User> queryUserByPage(User user, PageInfo pageInfo) {
        Map parameter = new HashMap();
        UserDao dao = new UserDao();
        //设置每页显示的数量
        pageInfo.setPageSize(PAGE_SIZE);
        //设置查询的起始位置
        pageInfo.setDbOffset();
        parameter.put("user",user);
        parameter.put("pageinfo",pageInfo);
        return dao.queryUserByPage(parameter);
    }

    @Override
    public User queryUserByID(int id) {
        UserDao userDao = new UserDao();
        return userDao.queryUserByID(id);
    }

    @Override
    public boolean queryLogin(User user) {
        UserDao userDao = new UserDao();
        return userDao.queryLogin(user);
    }

    @Override
    public int registUser(User user) {
        UserDao userDao = new UserDao();
        return userDao.registUser(user);
    }

    @Override
    public int checkEmail(String email) {
        UserDao userDao = new UserDao();
        return userDao.checkEmail(email);
    }

    @Override
    public int checkUserid(String userid) {
        UserDao userDao = new UserDao();
        return userDao.checkUserid(userid);
    }

    @Override
    public User queryUserByUid(String userid) {
        UserDao userDao = new UserDao();
        return userDao.queryUserByUid(userid);
    }

    /**
     * 传入的是新的用户信息
     * @param user
     * @return
     */
    @Override
    public int updateUserInfo(User user) {
        UserDao userDao = new UserDao();
        User olduser = userDao.queryUserByUid(user.getUserid());
        //给新用户信息设置id
        user.setId(olduser.getId());
        return userDao.updateUserInfo(user);
    }

    /**
     * 传入的是新密码和userid
     * @param user
     * @return
     */
    @Override
    public int updatePassword(User user) {
        UserDao userDao = new UserDao();
        //根据userid查询到用户
        User newpwd = userDao.queryUserByUid(user.getUserid());
        //设置新密码
        newpwd.setPassword(user.getPassword());
        return userDao.updatePassword(newpwd);
    }

    @Override
    public int deleteUserByID(int id) {
        UserDao userDao = new UserDao();
        return userDao.deleteUserById(id);
    }

    @Override
    public int queryCount() {
        UserDao dao = new UserDao();
        return dao.queryUserCount();
    }

    @Override
    public int updateUserInfoBack(User user) {
        UserDao userDao = new UserDao();
        return userDao.updateUserInfoBack(user);
    }

    @Override
    public List<Chart> queryUserStatistics(String year) {
        UserDao dao = new UserDao();
        List<Chart> chart = dao.queryUserCountByMonth(year);
        if(chart != null){
            for(int i=0; i<chart.size(); i++){
                String temp = chart.get(i).getCategories() + "月";
                chart.get(i).setCategories(temp);
            }
        }

        return chart;
    }


    @Override
    public int addUserGroup(UserGroup userGroup) {
        UserDao dao = new UserDao();
        return dao.insertUserGroup(userGroup);
    }

    @Override
    public int updateUserGroup(UserGroup userGroup) {
        UserDao dao = new UserDao();
        return dao.updateUserGroup(userGroup);
    }

    @Override
    public int deleteUserGroup(int id) {
        UserDao dao = new UserDao();
        return dao.deleteUserGroup(id);
    }

    @Override
    public List<UserGroup> queryUserGroupByPage(UserGroup userGroup, PageInfo pageInfo) {
        Map parameter = new HashMap();
        UserDao dao = new UserDao();
        //设置每页显示的数量
        pageInfo.setPageSize(PAGE_SIZE);
        //设置查询的起始位置
        pageInfo.setDbOffset();
        parameter.put("usergroup",userGroup);
        parameter.put("pageinfo",pageInfo);
        return dao.queryUserGroupByPage(parameter);
    }

    @Override
    public boolean isDataAvaliable(String userid, int datalevel) {
        UserDao userDao = new UserDao();
        User user = userDao.queryUserByUid(userid);
        UserGroup group = userDao.queryUserGroup(user.getUsergroup());
        boolean isAvaliable = false;
        switch (datalevel){
            case PUBLIC_DATA:
                isAvaliable = group.getData_public()==1;
                break;
            case PROTECTED_DATA:
                isAvaliable = group.getData_protected()==1;
                break;
            case PRIVATE_DATA:
                isAvaliable = group.getData_private()==1;
                break;
        }

        return isAvaliable;
    }
}
