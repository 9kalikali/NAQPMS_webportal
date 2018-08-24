package com.myweb.controller;

import com.alibaba.fastjson.JSON;
import com.myweb.model.*;
import com.myweb.service.*;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping(value = "/admin")
public class AdminController {

    private static Logger log = LoggerFactory.getLogger(AdminController.class);

    @Autowired
    private AdminService adminService;
    @Autowired
    private JobService jobService;
    @Autowired
    private UserService userService;
    @Autowired
    private DataShareService dataShareService;
    /**
     * 管理员登陆界面
     * @return
     */
    @RequestMapping(value = "/backgroundlogin")
    public ModelAndView pageAdminLogin(){
        return new ModelAndView("background/adminlogin").addObject(new Admin());
    }

    /**
     * 登陆
     * @param admin
     * @param response
     * @param model
     * @return
     */
    @RequestMapping(value = "/dologin", method = RequestMethod.POST)
    public ModelAndView adminloginControl(@ModelAttribute Admin admin, HttpServletResponse response, Model model){
        if(adminService.queryLogin(admin)){
            Cookie cookie = setCookie("adminid",admin.getAdminid(),30);
            Admin a = adminService.queryAdminByAid(admin.getAdminid());
            Cookie cookie2 = setCookie("priority",""+a.getPriority(),30);
            response.addCookie(cookie);
            response.addCookie(cookie2);
            return new ModelAndView("background/background").addObject("adminid",admin.getAdminid());
        }else{
            model.addAttribute("errmsg","fail");
            return new ModelAndView("background/adminlogin");
        }
    }

    /**
     * 登出
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/dologout")
    public ModelAndView adminlogoutControl(HttpServletRequest request, HttpServletResponse response){
        Cookie[] cookies = request.getCookies();
        if (null==cookies) {
            log.debug("=============没有cookie==============");
        } else {
            for(Cookie cookie : cookies){
                if(cookie.getName().equals("adminid")){
                    cookie.setValue(null);
                    cookie.setMaxAge(0);// 立即销毁cookie
                    cookie.setPath("/");
                    System.out.println("被删除的cookie名字为:"+cookie.getName());
                    response.addCookie(cookie);
                    break;
                }
            }
            for(Cookie cookie : cookies){
                if(cookie.getName().equals("priority")){
                    cookie.setValue(null);
                    cookie.setMaxAge(0);// 立即销毁cookie
                    cookie.setPath("/");
                    System.out.println("被删除的cookie名字为:"+cookie.getName());
                    response.addCookie(cookie);
                    break;
                }
            }
        }
        return new ModelAndView("background/adminlogin").addObject(new Admin());
    }

    @RequestMapping(value = "/adminregist")
    public ModelAndView pageAdminRegist(){
        return new ModelAndView("background/backadminregist").addObject(new Admin());
    }

    @ResponseBody
    @RequestMapping(value = "/chekpri",method = RequestMethod.POST,produces = "plain/text;charset=UTF-8" )
    public String checkPriority(HttpServletRequest request){
        String adminid = request.getParameter("adminid");
        int level = Integer.parseInt(request.getParameter("level"));
        if(adminService.checkPriority(adminid,level)){
            return "true";
        }else{
            return "false";
        }
    }

    @ResponseBody
    @RequestMapping(value = "/doregistadmin", method = RequestMethod.POST)
    public String registAdminControl(@ModelAttribute Admin admin, HttpServletRequest request){
        int result = adminService.registAdmin(admin);
        if(result == 1){
            return "success";
        }else{
            return "fail";
        }
    }

    @RequestMapping(value = "/adminlist")
    public ModelAndView pageAdminList(Model model){
        //初始化用户列表
        List<Admin> adminList = new ArrayList<Admin>();
        PageInfo pageInfo = new PageInfo();
        pageInfo.setPageNum(1);
        adminList = adminService.queryAdminByPage(new Admin(),pageInfo);
        model.addAttribute("pageinfo",pageInfo);
        model.addAttribute("adminList",adminList);
        return new ModelAndView("background/backadminlist").addObject(new Admin());
    }

    /**
     * 后台首页
     * @return
     */
    @RequestMapping(value = "/backindex")
    public String pageBackIndex(Model model){
        int usercount = userService.queryCount();
        int jobcount = jobService.getJobCount();
        int runningjob = jobService.getRunningJobCount();
        //float hpcping = adminService.getNetWorkDelay();
        model.addAttribute("usercount",usercount);
        model.addAttribute("jobcount",jobcount);
        model.addAttribute("runningjob",runningjob);
        return "background/backindex";
    }

    @ResponseBody
    @RequestMapping(value = "/deleteadmin/{id}")
    public String deleteAdminControl(@PathVariable(value = "userid")String id){
        //Need Test
        int result = adminService.deleteAdminByID(Integer.parseInt(id));
        if(result == 1){
            return "success";
        }else{
            return "fail";
        }
    }

    @ResponseBody
    @RequestMapping(value = "/domodifypri", method = RequestMethod.POST)
    public String modifyPriorityControl(HttpServletRequest request){
        String adminid = request.getParameter("aid");
        String level = request.getParameter("priority");
        Admin admin = adminService.queryAdminByAid(adminid);
        admin.setPriority(Integer.parseInt(level));
        int result = adminService.modifyPriority(admin);
        if(result == 1){
            return "success";
        }else{
            return "fail";
        }
    }

    @ResponseBody
    @RequestMapping(value = "/searchadmin/{pagenum}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    public String searchUserControl(@ModelAttribute Admin admin, @PathVariable(value = "pagenum")String pagenum){
        List<Admin> adminList = new ArrayList<Admin>();
        PageInfo pageInfo = new PageInfo();
        String jsonString = "";
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        adminList = adminService.queryAdminByPage(admin,pageInfo);
        Map map = new HashMap();
        map.put("adminlist",adminList);
        map.put("totalpages",pageInfo.count());
        map.put("curpage",pageInfo.getPageNum());
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            jsonString = objectMapper.writeValueAsString(map);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jsonString;
    }

    /**
     * 添加Cookies
     * @param name
     * @param value
     * @param extime
     * @return
     */
    public Cookie setCookie(String name, String value, int extime){
        Cookie cookie = new Cookie(name.trim(),value.trim());
        cookie.setMaxAge(extime * 60); //设置为？？分钟
        cookie.setPath("/");
        log.debug("cookie has been set");
        return cookie;
    }

    /**
     * 跳转至adminjoblist.jsp
     * @return
     */
    @RequestMapping("/backjoblist")
    public String listAllJobs(){
        return "background/backjoblist";
    }

    /**
     * 获取CPU使用率
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/cpuratio", method = RequestMethod.GET)
    public String getCPURatio(){
        return String.valueOf(adminService.getCPUusage());
    }

    /**
     * 获取网络带宽使用量
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/networkusage", method = RequestMethod.GET)
    public String getNetWorkUsage(){
        return String.valueOf(adminService.getNetWorkUsage());
    }

    /**
     * 获取内存使用量
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/memoryusage", method = RequestMethod.GET)
    public String getMemoryUsage(){
        return String.valueOf(adminService.getMemoryUsage());
    }

    /**
     * 获取磁盘使用量
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/diskiousage", method = RequestMethod.GET)
    public String getDiskIOsUsage(){
        return String.valueOf(adminService.getDiskIOUsage());
    }

    /**
     * 获取与hpc的网络延迟
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/hpcping", method = RequestMethod.GET)
    public String getNetWorkDelay(){
        if(adminService.getNetWorkDelay() < 0){
            return "连接异常";
        }
        return String.valueOf(adminService.getNetWorkDelay()) + "ms";
    }

    /**
     * 获取用户统计
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/userstatistics", method = RequestMethod.GET, produces = "plain/text;charset=UTF-8")
    public String getUserStatistics(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
        Date date = new Date();
        String jsonString = "";
        List<Chart> charts = userService.queryUserStatistics(sdf.format(date));
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            jsonString = objectMapper.writeValueAsString(charts);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jsonString;
    }

    /**
     * 获取计算任务统计
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/jobstatistics", method = RequestMethod.GET, produces = "plain/text;charset=UTF-8")
    public String getJobStatistics(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
        Date date = new Date();
        String jsonString = "";
        List<Chart> charts = jobService.getJobStatistics(sdf.format(date));
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            jsonString = objectMapper.writeValueAsString(charts);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jsonString;
    }
    /**
     * 查询所有用户的所有jobs
     * @return
     */
    @RequestMapping(value = "/queryJobsAdmin")
    @ResponseBody
    public String queryAll(Integer pageSize, Integer pageNumber){
        int total = jobService.getJobCount();
        List<Job> jobsList = jobService.queryAllJobs(pageSize, pageNumber);
        Page page = new Page();
        String resultJson = JSON.toJSONString(jobsList);
        page.setTotal(total);
        page.setRows(jobsList);
        return JSON.toJSONString(page);
   }

    /**
     * 用户组列表
     * @param model
     * @return
     */
   @RequestMapping(value = "/backusergroup")
   public String pageUserGroup(Model model){
       //初始化用户组列表
       List<UserGroup> groupList = new ArrayList<UserGroup>();
       PageInfo pageInfo = new PageInfo();
       pageInfo.setPageNum(1);
       groupList = userService.queryUserGroupByPage(new UserGroup(), pageInfo);
       model.addAttribute("groupList",groupList);
       model.addAttribute("pageinfo",pageInfo);
       return "background/backusergroup";
   }

    /**
     * 添加用户组
     * @param adminid
     * @param request
     * @return
     */
   @ResponseBody
   @RequestMapping(value = "/addusergroup/{adminid}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
   public String addUserGroupController(@PathVariable(value = "adminid")String adminid, HttpServletRequest request, @RequestParam("checkbox") String[] checklist){
       UserGroup userGroup = new UserGroup();
       userGroup.setUpdater(adminid);
       userGroup.setGroupname(request.getParameter("groupname"));
       userGroup.setData_protected(0);
       userGroup.setData_public(0);
       userGroup.setData_private(0);
       for(String check : checklist){
           switch (check){
               case "public":
                   userGroup.setData_public(1);
                   break;
               case"protected":
                   userGroup.setData_protected(1);
                   break;
               case"private":
                   userGroup.setData_private(1);
                   break;
           }
       }
       if(userService.addUserGroup(userGroup) > 0){
           return "success";
       }else{
           return "fail";
       }

   }

    /**
     * 分页查询用户组
     * @param pagenum
     * @return
     */
   @ResponseBody
   @RequestMapping(value = "/grouplist/{pagenum}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
   public String refreshGroupController(@PathVariable(value = "pagenum")String pagenum){

        List<UserGroup> groupList = new ArrayList<UserGroup>();
        PageInfo pageInfo = new PageInfo();
        String jsonString = "";
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        groupList = userService.queryUserGroupByPage(new UserGroup(), pageInfo);
        Map map = new HashMap();
        map.put("grouplist",groupList);
        map.put("totalpages",pageInfo.count());
        map.put("curpage",pageInfo.getPageNum());
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            jsonString = objectMapper.writeValueAsString(map);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jsonString;
   }

    /**
     * 删除用户组
     * @param id
     * @return
     */
   @ResponseBody
   @RequestMapping(value = "/deleteusergroup/{id}")
   public String deleteGroupController(@PathVariable(value = "id")String id){
        int result = userService.deleteUserGroup(Integer.parseInt(id));
        if(result > 0){
            return "success";
        }else{
            return "fail";
        }

   }

    public class Dir {
        public DatasetCategory firstLevel;
        public ArrayList<DatasetCategory> secondLevel;
        public DatasetCategory getFirstLevel() { return firstLevel; }
        public void setFirstLevel(DatasetCategory firstLevel) { this.firstLevel = firstLevel; }
        public ArrayList<DatasetCategory> getSecondLevel() { return secondLevel; }
        public void setSecondLevel(ArrayList<DatasetCategory> secondLevel) { this.secondLevel = secondLevel; }
    }

    @RequestMapping("/datacategorylist")
    public ModelAndView toDatacategorylist(){
        ModelAndView mv = new ModelAndView("front/datacategory");
        ArrayList<DatasetCategory> firstDirList = dataShareService.getFirstDir();
        ArrayList<DatasetCategory> secondDirList = dataShareService.getSecondDir();
        ArrayList<Dir> dirs = new ArrayList();
        Dir dir;
        ArrayList<DatasetCategory> tempSecond;
        for (int i = 0; i < firstDirList.size(); i++) {
            tempSecond = new ArrayList();
            for (int j = 0; j < secondDirList.size(); j++) {
                if(firstDirList.get(i).getCategoryId() == secondDirList.get(j).getParentId()){
                    tempSecond.add(secondDirList.get(j));
                }
            }
            dir = new Dir();
            dir.setFirstLevel(firstDirList.get(i));
            dir.setSecondLevel(tempSecond);
            if(dir.getFirstLevel().getCategoryId() != 0){
                dirs.add(dir);
            }
            System.out.println(tempSecond.toString());
        }
        for (int i = 0; i < firstDirList.size(); i++) {
            System.out.println(firstDirList.get(i).toString());
        }
        for (int i = 0; i < dirs.size(); i++) {
            System.out.println(dirs.get(i).firstLevel.getName());
            System.out.println(dirs.get(i).getSecondLevel().toString());

        }
        mv.addObject("dirs", dirs);
        return mv;
    }

    @RequestMapping("/datasetlist")
    public String datasetList(){
        return "front/datasetlist";
    }

    @RequestMapping(value = "/getDatasetList", method = RequestMethod.GET, produces = "plain/text;charset=UTF-8")
    @ResponseBody
    public String getDatasetList(Integer pageSize, Integer pageNumber){
        int total = dataShareService.queryDSCount();
        List<Dataset> dsList = dataShareService.getDatasetList(pageSize, pageNumber);
        Page page = new Page();
        page.setTotal(total);
        page.setRows(dsList);
        return JSON.toJSONString(page);
    }

    @RequestMapping("/editDataset")
    public String editDataset(){
        return "background/editdataset";
    }

    @RequestMapping(value = "/getDSforDSC", method = RequestMethod.GET, produces = "plain/text;charset=UTF-8")
    @ResponseBody
    public String getDSforDSC(@RequestParam(value = "categoryId") String categoryId){
        List<Dataset> dsList = dataShareService.selectByCategoryId(categoryId);
        if(dsList != null){
            log.debug("dsList.size:"+ dsList.size());
        }else {
            log.debug("出错！");
        }
        String jsonString = JSON.toJSONString(dsList);
        return jsonString;
    }
}



