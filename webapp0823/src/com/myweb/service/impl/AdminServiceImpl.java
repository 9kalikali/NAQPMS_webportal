package com.myweb.service.impl;

import com.myweb.dao.AdminDao;
import com.myweb.model.Admin;
import com.myweb.model.PageInfo;
import com.myweb.myutils.SystemInfo;
import com.myweb.service.AdminService;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("adminService")
public class AdminServiceImpl implements AdminService {

    private final static int PAGE_SIZE = 5;

    @Override
    public List<Admin> queryAllAdmin() {
        AdminDao dao = new AdminDao();
        return dao.queryAllAdmin();
    }

    @Override
    public Admin queryAdminByID(int id) {
        AdminDao dao = new AdminDao();
        return dao.queryAdminByID(id);
    }

    @Override
    public boolean queryLogin(Admin admin) {
        AdminDao dao = new AdminDao();
        return dao.queryAdminLogin(admin);
    }

    @Override
    public int deleteAdminByID(int id) {
        AdminDao dao = new AdminDao();
        return dao.deleteAdminByID(id);
    }

    @Override
    public List<Admin> queryAdminByPage(Admin admin, PageInfo pageInfo) {
        Map parameter = new HashMap();
        AdminDao dao = new AdminDao();
        //设置每页显示的数量
        pageInfo.setPageSize(PAGE_SIZE);
        //设置查询的起始位置
        pageInfo.setDbOffset();
        parameter.put("admin",admin);
        parameter.put("pageinfo",pageInfo);
        return dao.queryAdminByPage(parameter);
    }

    @Override
    public int modifyPriority(Admin admin) {
        AdminDao dao = new AdminDao();
        return dao.modifyPriority(admin);
    }

    @Override
    public Admin queryAdminByAid(String adminid) {
        AdminDao dao = new AdminDao();
        return dao.queryAdminByAid(adminid);
    }

    @Override
    public int registAdmin(Admin admin) {
        AdminDao dao = new AdminDao();
        return dao.registAdmin(admin);
    }

    @Override
    public boolean checkPriority(String adminid, int level) {
        AdminDao dao = new AdminDao();
        Admin admin = dao.queryAdminByAid(adminid);
        if(admin.getPriority() > level){
            return false;
        }else{
            return true;
        }
    }

    @Override
    public int getCPUusage() {
        return SystemInfo.CPURatio();
    }

    @Override
    public float getNetWorkDelay() {
        return SystemInfo.NetWorkDelay();
    }

    @Override
    public int getDiskIOUsage() {
        return SystemInfo.IOUsage();
    }

    @Override
    public int getMemoryUsage() {
        return SystemInfo.MemoryUsage();
    }

    @Override
    public float getNetWorkUsage() {
        return SystemInfo.NetWorkUsage();
    }
}
