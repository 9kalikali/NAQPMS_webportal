package com.myweb.mapper;

import com.myweb.model.Chart;
import com.myweb.model.User;
import com.myweb.model.UserGroup;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

/**
 * 常用的查询方法
 * 特殊方法如动态sql放在xml中
 */
public interface UserMapper {
    /**
     * 查询全部用户
     * @return
     */
    @Select("SELECT * FROM user")
    List<User> queryAllUser();

    /**
     * 按ID查询用户
     * @param id
     * @return
     */
    @Select("SELECT * FROM user WHERE ID = #{id}")
    User queryUserByID(int id);

    /**
     * 按userid查询用户
     * @param userid
     * @return
     */
    @Select("SELECT * FROM user WHERE userid=#{userid}")
    User queryUserByUid(String userid);

    /**
     * 登陆查询
     * @param userid
     * @return
     */
    @Select("SELECT password FROM user WHERE userid = #{userid}")
    String queryLogin(String userid);

    /**
     * 账户验证
     * @param userid
     * @return
     */
    @Select("SELECT COUNT(*) FROM user WHERE userid = #{userid}")
    int checkUserid(String userid);

    /**
     * 邮箱验证
     * @param email
     * @return
     */
    @Select("SELECT COUNT(*) FROM user WHERE email = #{email}")
    int chekEmail(String email);

    /**
     * 用户注册
     * @param user
     * @return
     */
    @Insert("INSERT INTO user(userid, password, username, email, phonenum, company, position) " +
            "VALUES (#{userid}, #{password}, #{username}, #{email}, #{phonenum}, #{company}, #{position})")
    int registUser(User user);

    /**
     * 删除用户
     * @param id
     * @return
     */
    @Delete("DELETE FROM user WHERE ID = #{id}")
    int deleteUserById(int id);

    /**
     * 获取用户数量
     * @return
     */
    @Select("SELECT COUNT(*) FROM user")
    int getUserConut();

    /**
     * 更改密码
     * @param user
     * @return
     */
    @Update("UPDATE user SET password=#{password} WHERE ID=#{id}")
    int updatePassword(User user);

    /**
     * 更改用户信息
     * @param user
     * @return
     */
    @Update("UPDATE user SET username=#{username},email=#{email},phonenum=#{phonenum},company=#{company},position=#{position} WHERE ID=#{id}")
    int updateUserInfo(User user);

    /**
     *更改用户的信息和用户组
     * @param user
     * @return
     */
    @Update("UPDATE user SET username=#{username},email=#{email},phonenum=#{phonenum},company=#{company},position=#{position},usergroup=#{usergroup} WHERE ID=#{id}")
    int updateUserInfoBack(User user);

    /**
     * 查询用户的用户组
     * @param usergroup
     * @return
     */
    @Select("SELECT * FROM usergroup WHERE groupname=#{usergroup}")
    UserGroup queryUserGroup(String usergroup);

    /**
     * 添加用户组
     * @param userGroup
     * @return
     */
    @Insert("INSERT INTO usergroup(groupname, data_public, data_protected, data_private, updater) VALUES(#{groupname}, #{data_public}, #{data_protected}, #{data_private}, #{updater})")
    int insertUserGroup(UserGroup userGroup);

    /**
     * 更新用户组
     * @param userGroup
     * @return
     */
    @Update("UPDATE usergroup SET groupname=#{groupname}, data_public=#{data_public}, data_protected=#{data_protected}, data_private=#{data_private}, updater=#{updater} WHERE ID=#{id}")
    int updateUserGroup(UserGroup userGroup);

    /**
     * 删除用户组
     * @param id
     * @return
     */
    @Delete("DELETE FROM usergroup WHERE ID = #{id}")
    int deleteUserGroup(int id);
    /**
     * 查询当年每个月用户的注册数量
     * @param year
     * @return
     */
    @Select("SELECT DATE_FORMAT(registdate,'%m') AS categories, COUNT(*) AS ydata FROM user WHERE DATE_FORMAT(registdate,'%Y')=#{year} GROUP BY DATE_FORMAT(registdate,'%m') ORDER BY categories")
    List<Chart> queryUserCountByMonth(String year);
}
