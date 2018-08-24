package com.myweb.mapper;

import com.myweb.model.Article;
import org.apache.ibatis.annotations.*;

import java.util.List;

public interface ArticleMapper {
    /**
     * 查询全部文章内容
     * @return
     */
    @Select("SELECT * FROM article")
    @ResultMap("Article.ArticleResult")//通过该注解映射查询结果
    List<Article> queryAllArticle();

    /**
     * 按ID查询文章
     */
    @Select("SELECT * FROM article WHERE ID = #{id}")
    @ResultMap("Article.ArticleResult")
    Article queryArticleByID(int id);

    /**
     * 根据日期查询前5条记录
     * @return
     */
    @Select("SELECT * FROM article WHERE type=#{type} ORDER BY datetime DESC LIMIT 5")
    @ResultMap("Article.ArticleResult")
    List<Article> queryLimitedArticle(String type);

    /**
     * 插入文章
     * @param article
     * @return
     */
    @Insert("INSERT INTO article(title, author, content, type) " +
            "VALUES (#{title}, #{author}, #{content}, #{type})")
    int insertArticle(Article article);

    /**
     * 删除一条文章
     * @param id
     * @return
     */
    @Delete("DELETE FROM article WHERE ID = #{id}")
    int deleteArticleByID(int id);

    /**
     * 获取文章列表中的记录数
     * @return
     */
    @Select("SELECT COUNT(*) FROM article")
    int getArticleCount();

    /**
     * 浏览量加一
     * @param id
     * @return
     */
    @Update("UPDATE article SET views=views+1 WHERE ID=#{id}")
    int updateArticleViews(int id);
}
