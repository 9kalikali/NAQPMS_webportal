package com.myweb.mapper;

import com.myweb.model.Admin;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

public interface AdminMapper {

    /**
     * 查询全部管理员
     * @return
     */
    @Select("SELECT * FROM admin")
    List<Admin> queryAllAdmin();

    /**
     * 按ID查询管理员
     * @param id
     * @return
     */
    @Select("SELECT * FROM admin WHERE ID = #{id}")
    Admin queryAdminByID(int id);

    /**
     * 按adminid查询用户
     * @param adminid
     * @return
     */
    @Select("SELECT * FROM admin WHERE adminid=#{adminid}")
    Admin queryAdminByAid(String adminid);

    /**
     * 登陆查询
     * @param adminid
     * @return
     */
    @Select("SELECT adminpassword FROM admin WHERE adminid = #{adminid}")
    String queryLogin(String adminid);
    /**
     * 管理员注册
     * @param admin
     * @return
     */
    @Insert("INSERT INTO admin(adminid, adminpassword, priority) " +
            "VALUES (#{adminid}, #{adminpassword}, #{priority})")
    int registAdmin(Admin admin);

    /**
     * 删除管理员
     * @param id
     * @return
     */
    @Delete("DELETE FROM admin WHERE ID = #{id}")
    int deleteAdminById(int id);

    /**
     * 更改管理员权限
     * @param admin
     * @return
     */
    @Update("UPDATE admin SET priority = #{priority} WHERE ID= #{id}")
    int modifyPriority(Admin admin);

}
