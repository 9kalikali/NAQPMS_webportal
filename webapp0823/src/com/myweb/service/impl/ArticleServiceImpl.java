package com.myweb.service.impl;

import com.myweb.dao.ArticleDao;
import com.myweb.model.Article;
import com.myweb.model.PageInfo;
import com.myweb.service.ArticleService;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("articleService")
public class ArticleServiceImpl implements ArticleService {

    private final static int PAGE_SIZE = 5;


    //------------------------专题文章--------------------//

    @Override
    public List<Article> queryLimitedArticle(String type) {
        ArticleDao articleDao = new ArticleDao();
        return articleDao.queryLimitedArticle(type);
    }

    @Override
    public Article queryArticleByID(int id) {
        ArticleDao articleDao = new ArticleDao();
        return articleDao.queryArticleByID(id);
    }

    @Override
    public int submitArticle(Article article) {
        ArticleDao articleDao = new ArticleDao();
        return articleDao.insertArticle(article);
    }

    @Override
    public int deleteArticleByID(int id) {
        ArticleDao articleDao = new ArticleDao();
        return articleDao.deleteArticleByID(id);
    }

    @Override
    public List<Article> queryArticleByPage(Article article, PageInfo pageInfo) {
        Map parameter = new HashMap();
        ArticleDao articleDao = new ArticleDao();
        pageInfo.setPageSize(PAGE_SIZE);
        pageInfo.setDbOffset();
        parameter.put("article", article);
        parameter.put("pageinfo", pageInfo);
        return articleDao.queryArticleByPage(parameter);
    }

    @Override
    public int readArticle(int id) {
        ArticleDao articleDao = new ArticleDao();
        return articleDao.updateArticleViewsByID(id);
    }


    /**
     * 用作首页
     * 返回文章和新闻的最新五条
     * @return
     */
    @Override
    public Map queryAll5() {
        Map result = new HashMap();
        List<Article> articleList = queryLimitedArticle(TYPE_ARTICLE);
        List<Article> newsList = queryLimitedArticle(TYPE_NEWS);
        List<Article> questionList = queryLimitedArticle(TYPE_QUESTION);
        result.put("articlelist",articleList);
        result.put("newslist",newsList);
        result.put("questionlist",questionList);
        return result;
    }
}
