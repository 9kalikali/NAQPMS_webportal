package com.myweb.controller;
import com.alibaba.fastjson.JSON;
import com.myweb.model.Job;
import com.myweb.model.Message;
import com.myweb.model.PageInfo;
import com.myweb.model.User;
import com.myweb.service.JobService;
import com.myweb.service.MessageService;
import com.myweb.service.UserService;
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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 用户视图控制器
 * 对用户的登陆以及增删改查做出一些反应
 */
@Controller
@RequestMapping(value = "/user")
public class UserController {

    private static Logger log = LoggerFactory.getLogger(UserController.class);
    private final static String USER_GROUP1 = "normal";
    private final static String USER_GROUP2 = "advanced";
    private final static String USER_GROUP3 = "senior";
    @Autowired
    private UserService userService;
    @Autowired
    private MessageService messageService;
    @Autowired
    private JobService jobService;


    @RequestMapping(value = "/dologin", method = RequestMethod.POST)
    public ModelAndView loginControl (@ModelAttribute User user, HttpServletResponse response, Model model){
        if(userService.queryLogin(user)){
            Cookie cookie = setCookie("userid",user.getUserid(),30);
            response.addCookie(cookie);
            return new ModelAndView("index").addObject("userid",user.getUserid());
        }else {
            model.addAttribute("errmsg","fail");
            return new ModelAndView("users/login");
        }
    }

    @RequestMapping(value = "/dologout")
    public String logoutControl(HttpServletRequest request, HttpServletResponse response){
        Cookie[] cookies = request.getCookies();
        if (null==cookies) {
            log.debug("=============没有cookie==============");
        } else {
            for(Cookie cookie : cookies){
                if(cookie.getName().equals("userid")){
                    cookie.setValue(null);
                    cookie.setMaxAge(0);// 立即销毁cookie
                    cookie.setPath("/");
                    System.out.println("被删除的cookie名字为:"+cookie.getName());
                    response.addCookie(cookie);
                    break;
                }
            }
        }
        return "index";
    }

    @RequestMapping(value = "/doregist", method = RequestMethod.POST)
    public String registControl(@ModelAttribute User user,Model model){
        log.debug("userid={}",user.getUserid());
        log.debug("username={}",user.getUsername());
        int result = userService.registUser(user);
        if(result == 1){
            return "users/login";
        }else{
            model.addAttribute("errmsg","error");
            return "users/regist";
        }
    }

    @RequestMapping(value = "/userindex/{userid}")
    public String pageUserIndex(Model model, @PathVariable(value = "userid")String userid){
        User curuser = userService.queryUserByUid(userid);
        PageInfo pageInfo = new PageInfo();
        switch (curuser.getUsergroup()){
            case USER_GROUP1:
                curuser.setUsergroup("普通用户");
                break;
            case USER_GROUP2:
                curuser.setUsergroup("中级用户");
                break;
            case USER_GROUP3:
                curuser.setUsergroup("高级用户");
                break;
            default:
                break;
        }
        int runningjobs = jobService.getUserJobCountByStatus(userid,"1");
        int jobcomplete = jobService.getUserJobCountByStatus(userid,"2");
        int jobcount = jobService.getUserJobCount(userid);
        pageInfo.setPageNum(1);
        Job mjob = new Job();
        mjob.setUserId(userid);
        List<Job> jobList = jobService.queryJobsByPage(mjob,pageInfo);
        jobList.forEach(job -> {
            switch (job.getStatus()){
                case "0":
                    job.setStatus("排队中");
                    break;
                case"1":
                    job.setStatus("运行中");
                    break;
                case"2":
                    job.setStatus("已完成");
                    break;
                default:
                    job.setStatus("异常");
            }
            switch (job.getType()){
                case "file":
                    job.setType("脚本");
                    break;
                case"args":
                    job.setType("参数");
                    break;
                default:
                    job.setType("未知");
            }
        });

        model.addAttribute("jobcount",jobcount);
        model.addAttribute("runningjobs",runningjobs);
        model.addAttribute("completejobs",jobcomplete);
        model.addAttribute("joblist",jobList);
        model.addAttribute("curuser",curuser);
        return "users/userindex";
    }

    @RequestMapping(value = "/initmsglist/{userid}")
    public String pageMessageList(@PathVariable(value = "userid")String userid, Model model){
        List<Message> messageList = new ArrayList<Message>();
        PageInfo pageInfo = new PageInfo();
        pageInfo.setPageNum(1);
        messageList = messageService.queryMessageByPage(userid, pageInfo);
        model.addAttribute("messagelist",messageList);
        model.addAttribute("pageinfo",pageInfo);
        return "users/messagelist";
    }

    @RequestMapping(value = "/modifyuser/{userid}")
    public ModelAndView pageModifyUser(Model model, @PathVariable(value = "userid")String userid){
        User oldinfo = userService.queryUserByUid(userid);
        model.addAttribute("oldinfo",oldinfo);
        return new ModelAndView("users/modifyuser").addObject(new User());
    }

    @ResponseBody
    @RequestMapping(value="/domodifyuser",method = RequestMethod.POST)
    public String modifyUserControl(@ModelAttribute User user,Model model){
        int result = userService.updateUserInfo(user);
        if(result ==1){
            return "success";
        }else{
            return "fail";
        }
    }

    @RequestMapping(value = "/modifypwd/{userid}")
    public String pageModifyPwd(Model model,@PathVariable(value = "userid")String userid){
        model.addAttribute("userid",userid);
        return "users/modifypwd";
    }

    @RequestMapping(value = "/domodifypwd/{userid}")
    @ResponseBody
    public String modifyPwdControl(@PathVariable(value = "userid")String userid,HttpServletRequest request){
        String oldpwd = request.getParameter("oldpwd");
        String newpwd = request.getParameter("newpwd");
        User user = new User();
        user.setUserid(userid);
        user.setPassword(oldpwd);
        if(userService.queryLogin(user)){
            user.setPassword(newpwd);
            int result = userService.updatePassword(user);
            if(result == 1){
                return "success";
            }else{
                return "fail";
            }
        }else{
            return "none";
        }
    }

    @RequestMapping(value = "/checkuserid")
    @ResponseBody
    public String checkUseridControl(@ModelAttribute User user, HttpServletResponse response){
        log.debug("check~check~userid={}",user.getUserid());
        int count = userService.checkUserid(user.getUserid());
        String jsonString = null;
        if(count > 0 || count == -1){
            jsonString = JSON.toJSONString(false);
        }else{
            jsonString = JSON.toJSONString(true);
        }
        return jsonString;
    }
    @RequestMapping(value = "/checkemail")
    @ResponseBody
    public String checkEmailControl(@ModelAttribute User user, HttpServletResponse response){
        log.debug("check~check~email={}",user.getEmail());
        int count = userService.checkEmail(user.getEmail());
        String jsonString = null;
        if(count > 0 || count == -1){
            jsonString = JSON.toJSONString(false);
        }else{
            jsonString = JSON.toJSONString(true);
        }
        return jsonString;
    }

    //----------------------------用户后台----------------------------//
    @RequestMapping(value = "/admin/userlist")
    public ModelAndView pageBackUserList(Model model){
        //初始化用户列表
        List<User> userList = new ArrayList<User>();
        PageInfo pageInfo = new PageInfo();
        pageInfo.setPageNum(1);
        userList = userService.queryUserByPage(new User(),pageInfo);
        log.debug("userid1="+userList.get(1).getUserid());
        //log.debug("size="+userList.size());
        userList.forEach(user -> {
            log.debug("group="+user.getUsergroup());
            switch (user.getUsergroup()){
                case USER_GROUP1:
                    user.setUsergroup("普通用户");
                    break;
                case USER_GROUP2:
                    user.setUsergroup("中级用户");
                    break;
                case USER_GROUP3:
                    user.setUsergroup("高级用户");
                    break;
                default:
                    break;
            }
        });
        model.addAttribute("pageinfo",pageInfo);
        model.addAttribute("userList",userList);
        return new ModelAndView("background/backuserlist").addObject(new User());
    }

    @ResponseBody
    @RequestMapping(value = "/deleteuser/{id}")
    public String deleteUserControl(@PathVariable(value = "userid")String id){
        //Need Test
        int result = userService.deleteUserByID(Integer.parseInt(id));
        if(result == 1){
            return "success";
        }else{
            return "false";
        }
    }

    @RequestMapping(value = "/backmodifyuser/{userid}")
    public ModelAndView pageBackModifyUser(Model model, @PathVariable(value = "userid")String userid){
        User oldinfo = userService.queryUserByUid(userid);
        model.addAttribute("oldinfo",oldinfo);
        return new ModelAndView("background/backmodifyuser").addObject(new User());
    }

    @ResponseBody
    @RequestMapping(value = "/searchuser/{pagenum}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    public String searchUserControl(@ModelAttribute User user, @PathVariable(value = "pagenum")String pagenum){

        List<User> userList = new ArrayList<User>();
        PageInfo pageInfo = new PageInfo();
        String jsonString = "";
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        userList = userService.queryUserByPage(user,pageInfo);
        Map map = new HashMap();
        map.put("userlist",userList);
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
     * 后台执行更改用户信息的控制器
     * @param user
     * @return
     */
    @ResponseBody
    @RequestMapping(value="/domodifyuserback",method = RequestMethod.POST)
    public String modifyUserBackControl(@ModelAttribute User user){
        log.debug("ID="+user.getId());
        int result = userService.updateUserInfoBack(user);
        if(result ==1){
            return "200";
        }else{
            return "500";
        }
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

}
