package com.myweb.service;

import com.myweb.model.Admin;
import com.myweb.model.PageInfo;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface AdminService {

    List<Admin> queryAllAdmin();

    List<Admin> queryAdminByPage(Admin admin, PageInfo pageInfo);

    Admin queryAdminByID(int id);

    Admin queryAdminByAid(String adminid);

    boolean queryLogin(Admin admin);

    boolean checkPriority(String adminid, int level);

    int deleteAdminByID(int id);

    int modifyPriority(Admin admin);

    int registAdmin(Admin admin);

    int getCPUusage();

    float getNetWorkUsage();

    int getMemoryUsage();

    int getDiskIOUsage();

    float getNetWorkDelay();
}
