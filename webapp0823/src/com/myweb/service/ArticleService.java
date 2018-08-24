package com.myweb.service;

import com.myweb.model.Article;
import com.myweb.model.PageInfo;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * 包括专题文章、新闻公告两个类的数据库操作
 */
@Service
public interface ArticleService {

    String TYPE_ARTICLE="ARTICLE";
    String TYPE_NEWS="NEWS";
    String TYPE_QUESTION="QUESTION";

    /**
     * 专题文章
     */
    List<Article> queryLimitedArticle(String type);

    Article queryArticleByID(int id);

    int submitArticle(Article article);

    int deleteArticleByID(int id);

    List<Article> queryArticleByPage(Article article, PageInfo pageInfo);

    int readArticle(int id);


    /**
     * 综合
     */
    Map queryAll5();
}
