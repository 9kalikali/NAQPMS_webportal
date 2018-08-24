package com.myweb.controller;

import com.myweb.model.Article;
import com.myweb.model.PageInfo;
import com.myweb.service.ArticleService;
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
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 新闻公告控制器
 */
@Controller
@RequestMapping(value = "/platforminfo")
public class PlatFormInfoController {
    private static Logger log = LoggerFactory.getLogger(PlatFormInfoController.class);
    @Autowired
    private ArticleService articleService;

    //----------------------------新闻公告前台-----------------------------//

    @RequestMapping(value = "/newslist/{pagenum}")
    public String pageNewsList(Model model, @PathVariable(value = "pagenum") String pagenum){
        List<Article> newsList = new ArrayList<Article>();
        PageInfo pageInfo = new PageInfo();
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        Article news = new Article();
        news.setType(ArticleService.TYPE_NEWS);
        newsList = articleService.queryArticleByPage(news,pageInfo);
        model.addAttribute("pageinfo",pageInfo);
        model.addAttribute("newsList",newsList);
        //System.out.println("pagenum="+pagenum);
        return "front/newslist";
    }

    //----------------------------新闻公告后台--------------------------//

    @RequestMapping(value = "/admin/newslist")
    public ModelAndView pageBackNewsList(Model model){
        //初始化文章列表
        List<Article> newsList;
        PageInfo pageInfo = new PageInfo();
        pageInfo.setPageNum(1);
        Article news = new Article();
        news.setType(ArticleService.TYPE_NEWS);
        newsList = articleService.queryArticleByPage(news,pageInfo);
        model.addAttribute("pageinfo",pageInfo);
        model.addAttribute("newsList",newsList);
        return new ModelAndView("background/backnewslist").addObject(new Article());
    }

    /**
     * 删除新闻公告
     * @param newsid
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/admin/deletenews/{newsid}")
    public String deleteNewsControl(@PathVariable(value = "newsid")String newsid){
        int result = articleService.deleteArticleByID(Integer.parseInt(newsid));
        if(result >0){
            return "success";
        }
        return "fail";
    }

    /**
     * 多条件分页查询，返回JSON字符串
     * @param news
     * @param pagenum
     * @return jsonString
     */
    @ResponseBody
    @RequestMapping(value = "/searchnews/{pagenum}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    public String searchNewsControl(@ModelAttribute Article news, @PathVariable(value = "pagenum")String pagenum){

        List<Article> newsList;
        PageInfo pageInfo = new PageInfo();
        String jsonString = "";
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        news.setType(ArticleService.TYPE_NEWS);
        newsList = articleService.queryArticleByPage(news,pageInfo);
        Map map = new HashMap();
        map.put("newslist",newsList);
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

    //-----------------------------专题文章前台------------------------------------//

    @RequestMapping(value = "/articlelist/{pagenum}")
    public String articleList(Model model, @PathVariable(value= "pagenum") String pagenum){
        List<Article> articleList;
        PageInfo pageInfo = new PageInfo();
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        Article article = new Article();
        article.setType(ArticleService.TYPE_ARTICLE);
        articleList = articleService.queryArticleByPage(article,pageInfo);
        model.addAttribute("pageinfo",pageInfo);
        model.addAttribute("articleList",articleList);
        return "front/articlelist";
    }

    //----------------------------------专题文章后台------------------------------//
    @RequestMapping(value = "/admin/articlelist")
    public ModelAndView pageBackArticleList(Model model){
        //初始化文章列表
        List<Article> articleList;
        PageInfo pageInfo = new PageInfo();
        pageInfo.setPageNum(1);
        Article article = new Article();
        article.setType(ArticleService.TYPE_ARTICLE);
        articleList = articleService.queryArticleByPage(article,pageInfo);
        model.addAttribute("pageinfo",pageInfo);
        model.addAttribute("articleList",articleList);
        return new ModelAndView("background/backarticlelist").addObject(new Article());
    }

    /**
     * 删除文章
     * @param articleid
     * @return success or not
     */
    @ResponseBody
    @RequestMapping(value = "/admin/deletearticle/{articleid}")
    public String deleteArticleControl(@PathVariable(value = "articleid")String articleid){
        int result = articleService.deleteArticleByID(Integer.parseInt(articleid));
        if(result >0){
            return "success";
        }
        return "fail";
    }

    /**
     * 多条件分页查询
     * @param article
     * @param pagenum
     * @return jsonString
     */
    @ResponseBody
    @RequestMapping(value = "/searcharticle/{pagenum}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    public String searchArticleControl(@ModelAttribute Article article, @PathVariable(value = "pagenum")String pagenum){


        List<Article> articleList = new ArrayList<Article>();
        PageInfo pageInfo = new PageInfo();
        String jsonString = "";
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        article.setType(ArticleService.TYPE_ARTICLE);
        articleList = articleService.queryArticleByPage(article,pageInfo);
        Map map = new HashMap();
        map.put("articlelist",articleList);
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

    //-------------------------------常见问题前台-----------------------------//
    @RequestMapping(value = "/questionlist/{pagenum}")
    public String questionList(Model model, @PathVariable(value = "pagenum") String pagenum){
        List<Article> questionList;
        PageInfo pageInfo = new PageInfo();
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        Article question = new Article();
        question.setType(ArticleService.TYPE_QUESTION);
        questionList = articleService.queryArticleByPage(question,pageInfo);
        model.addAttribute("pageinfo",pageInfo);
        model.addAttribute("questionList",questionList);
        //System.out.println("pagenum="+pagenum);
        return "front/questionlist";
    }

    //-------------------------------常见问题后台-------------------------//

    @RequestMapping(value = "/admin/questionlist")
    public ModelAndView pageBackQuestionList(Model model){
        //初始化文章列表
        List<Article> questionList;
        PageInfo pageInfo = new PageInfo();
        pageInfo.setPageNum(1);
        Article question = new Article();
        question.setType(ArticleService.TYPE_QUESTION);
        questionList = articleService.queryArticleByPage(question,pageInfo);
        model.addAttribute("pageinfo",pageInfo);
        model.addAttribute("questionList",questionList);
        return new ModelAndView("background/backquestionlist").addObject(new Article());
    }

    @ResponseBody
    @RequestMapping(value = "/admin/deletequestion/{questionid}")
    public String deleteQuestionControl(@PathVariable(value = "question")String questionid){
        int result = articleService.deleteArticleByID(Integer.parseInt(questionid));
        if(result < 0){
            return "fail";
        }
        return "success";
    }

    /**
     * 多条件分页查询问题列表
     * @param question
     * @param pagenum
     * @return jsonString
     */
    @ResponseBody
    @RequestMapping(value = "/searchquestion/{pagenum}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    public String searchQuestionControl(@ModelAttribute Article question, @PathVariable(value = "pagenum")String pagenum){

        List<Article> questionList;
        PageInfo pageInfo = new PageInfo();
        String jsonString = "";
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        question.setType(ArticleService.TYPE_QUESTION);
        questionList = articleService.queryArticleByPage(question,pageInfo);
        Map map = new HashMap();
        map.put("questionlist",questionList);
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

    //-------------------------------公共--------------------------------//

    /**
     * 跳转至平台信息页面
     * @param infoType
     * @param para
     * @param model
     * @return
     */
    @RequestMapping(value = "/more/{infoType}_{para}")
    public String pageMoreInfo(@PathVariable(value = "infoType") String infoType,@PathVariable(value = "para") String para, Model model){
        model.addAttribute("infoType",infoType);
        model.addAttribute("para",para);
        return "front/platforminfo";
    }

    /**
     * 返回文章具体内容页面
     * @param aType
     * @param id
     * @param model
     * @return
     */
    @RequestMapping(value = "/details/{aType}_{id}")
    public String pageDetails(@PathVariable(value = "aType")String aType, @PathVariable(value = "id")String id, Model model){
        //model.addAttribute("type",aType);
        //model.addAttribute("id",id);
        model.addAttribute("type",aType);
        Article details = null;
        if(aType.equals("article")){
            //文章阅览量+1
            articleService.readArticle(Integer.parseInt(id));
            details = articleService.queryArticleByID(Integer.parseInt(id));
        }else{
            details = articleService.queryArticleByID(Integer.parseInt(id));
        }
        //log.debug("title="+details.title);
        model.addAttribute("detail",details);
        return "front/details";
    }

    /**
     * 文章发布页面
     * @return
     */
    @RequestMapping(value = "/admin/postinfo")
    public String pageEditor(){
        return "background/postinfo";
    }

    @RequestMapping(value = "/dopostinfo", method = RequestMethod.POST)
    @ResponseBody
    public String postInfoControl(HttpServletRequest request){
        String title = request.getParameter("title");
        String type = request.getParameter("type");
        String content = request.getParameter("md-code");
        String author = getCookies(request,"adminid");
        log.debug("author:"+author);
        log.debug("title:"+title);
        log.debug("type:"+type);

        if(author != null && author != ""){
            Article article = new Article();
            article.setTitle(title);
            article.setAuthor(author);
            article.setContent(content);
            article.setType(type);
            articleService.submitArticle(article);
            return "success";
        }
        return "fail";
    }

    /**
     *用于获取管理员界面管理员id
     * @param request
     * @param name
     * @return
     */
    private String getCookies(HttpServletRequest request,String name){
        Cookie[] cookies = request.getCookies();
        if (null==cookies) {
            return null;
        } else {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("adminid")) {
                    return cookie.getValue();
                }
            }
        }
        return "";
    }
}
