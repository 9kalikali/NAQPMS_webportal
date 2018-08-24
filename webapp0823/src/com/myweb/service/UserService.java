package com.myweb.service;

import com.myweb.model.Chart;
import com.myweb.model.PageInfo;
import com.myweb.model.User;
import com.myweb.model.UserGroup;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface UserService {

    List<User> queryAllUser();

    List<User> queryUserByPage(User user, PageInfo pageInfo);

    List<Chart> queryUserStatistics(String year);

    User queryUserByID(int id);

    User queryUserByUid(String userid);

    boolean queryLogin(User user);

    int registUser(User user);

    int checkEmail(String email);

    int checkUserid(String userid);

    int updateUserInfo(User user);

    int updatePassword(User user);

    int deleteUserByID(int id);

    int queryCount();

    int updateUserInfoBack(User user);

    /**
     * 添加用户组
     * @param userGroup
     * @return
     */
    int addUserGroup(UserGroup userGroup);

    /**
     * 更新用户组
     * @param userGroup
     * @return
     */
    int updateUserGroup(UserGroup userGroup);

    /**
     * 删除用户组
     * @param id
     * @return
     */
    int deleteUserGroup(int id);

    /**
     * 分页查询用户组
     * @param userGroup
     * @param pageInfo
     * @return
     */
    List<UserGroup> queryUserGroupByPage(UserGroup userGroup, PageInfo pageInfo);

    /**
     * 查询数据下载权限
     * @param userid
     * @param datalevel
     * @return
     */
    boolean isDataAvaliable(String userid, int datalevel);
}
