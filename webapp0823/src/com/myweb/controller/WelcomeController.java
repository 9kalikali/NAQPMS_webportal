package com.myweb.controller;

import com.myweb.model.DatasetCategory;
import com.myweb.model.User;
import com.myweb.service.ArticleService;
import com.myweb.service.DataShareService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.Map;

/**
 * 首页视图控制器
 */
@Controller
public class WelcomeController {

    private static Logger log = LoggerFactory.getLogger(WelcomeController.class);

    @Autowired
    private ArticleService articleService;
    @Autowired
    private DataShareService dataShareService;

    @RequestMapping(value = {"/","index"})
    public ModelAndView pageIndex(){
        return new ModelAndView("index").addObject("pageviews","0");
    }

    /**
     * 登陆、注册页面
     * @return
     */
    @RequestMapping(value = "/login")
    public ModelAndView pageLogin(){
        return new ModelAndView("users/login").addObject(new User());
    }

    @RequestMapping(value = "/regist")
    public ModelAndView pageRegist(){
        return new ModelAndView("users/regist").addObject(new User());
    }

    /**
     * 首页
     */
    @RequestMapping(value="/welcome")
    public ModelAndView pageWelcome(){
        Map modelMap = articleService.queryAll5();
        return new ModelAndView("front/welcome").addObject("modelMap",modelMap);
    }

    /**
     * 计算任务页面
     * @return
     */
    @RequestMapping(value = "/jobsubmit")
    public ModelAndView pageDraw(){
        return new ModelAndView("front/jobsubmit");
    }

    /**
     * 数据展示页面
     * @return
     */
    @RequestMapping(value = "/datadisplay")
    public String pageDisplay(){
        return "front/datadisplay";
    }

    /**
     * WebGIS展示页面
     * @return
     */
    @RequestMapping(value = "/webgisdisplay")
    public String pageWebGIS(){
        return "front/webgisdisplay";
    }

    /**
     * 用户中心页面
     * @return
     */
    @RequestMapping(value = "/usercenter/{section}")
    public String pageUserCenter(Model model, @PathVariable(value = "section") String section){
        model.addAttribute("section",section);
        return "users/usercenter";
    }

    /**
     * 入门指南页面
     * @return
     */
    @RequestMapping(value = "tutorial")
    public String pageTutorial(){
        return "others/tutorial";
    }

    /**
     * 关于我们页面
     * @return
     */
    @RequestMapping(value = "/aboutus")
    public String pageAboutUs(){
        return "others/aboutus";
    }

    /**
     * 缺省页面
     * @return
     */
    @RequestMapping(value = "/invalid")
    public String pageInvalid(){
        return "others/invalid";
    }

    /**
     * 数据共享——下载文件——测试
     * @return
     */
    @RequestMapping(value = "/download")
    public ModelAndView pageDownloadTest() {
        ModelAndView mv = new ModelAndView("front/downloadtest");
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
        mv.addObject("firstDirList", firstDirList);
        mv.addObject("secondDirList", secondDirList);
        return mv;
    }

    public class Dir {
        public DatasetCategory firstLevel;
        public ArrayList<DatasetCategory> secondLevel;
        public DatasetCategory getFirstLevel() { return firstLevel; }
        public void setFirstLevel(DatasetCategory firstLevel) { this.firstLevel = firstLevel; }
        public ArrayList<DatasetCategory> getSecondLevel() { return secondLevel; }
        public void setSecondLevel(ArrayList<DatasetCategory> secondLevel) { this.secondLevel = secondLevel; }

    }

}
