package com.myweb.dao;

import com.myweb.mapper.ArticleMapper;
import com.myweb.model.Article;
import com.myweb.myutils.DBUtil;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ArticleDao {
    /**
     * 获取全部新闻内容
     * @return
     */
    public List<Article> queryAllArticle(){
        SqlSession sqlSession = null;
        List<Article> articlelist = new ArrayList<Article>();

        try{
            sqlSession = DBUtil.getSqlSession();
            ArticleMapper mapper = sqlSession.getMapper(ArticleMapper.class);
            articlelist = mapper.queryAllArticle();
            return articlelist;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }

        return null;
    }

    /**
     * 通过id选择新闻
     * @param id
     * @return
     */
    public Article queryArticleByID(int id){
        SqlSession sqlSession = null;
        Article result = new Article();
        try{
            sqlSession = DBUtil.getSqlSession();
            ArticleMapper mapper = sqlSession.getMapper(ArticleMapper.class);
            result = mapper.queryArticleByID(id);
            return result;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }

        return null;
    }

    /**
     * 查询最新的前5条内容
     * @return
     */
    public List<Article> queryLimitedArticle(String type){
        SqlSession sqlSession = null;
        List<Article> articlelist = new ArrayList<Article>();

        try{
            sqlSession = DBUtil.getSqlSession();
            ArticleMapper mapper = sqlSession.getMapper(ArticleMapper.class);
            articlelist = mapper.queryLimitedArticle(type);
            return articlelist;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }

        return null;
    }

    /**
     * 插入一条新闻
     * @param article
     * @return
     */
    public int insertArticle(Article article){
        SqlSession sqlSession = null;
        int result = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            //通过sqlSession执行SQL语句
            ArticleMapper mapper = sqlSession.getMapper(ArticleMapper.class);
            result = mapper.insertArticle(article);
            //没有设置自动提交的话需要手动提交
            sqlSession.commit();
        } catch (IOException e) {
            e.printStackTrace();
            sqlSession.rollback();
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
            //返回数据
            return result;
        }
    }

    /**
     * 删除一条文章
     * @param id
     * @return
     */
    public int deleteArticleByID(int id){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            ArticleMapper mapper = sqlSession.getMapper(ArticleMapper.class);
            result = mapper.deleteArticleByID(id);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            sqlSession.rollback();
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
            return result;
        }
    }

    /**
     * 按条件分页查询
     * @param parameter
     * @return
     */
    public List<Article> queryArticleByPage(Map<String, Object> parameter){
        SqlSession sqlSession = null;
        List<Article> resultList = new ArrayList<Article>();
        try{
            sqlSession = DBUtil.getSqlSession();
            resultList = sqlSession.selectList("Article.queryArticleByPage",parameter);
            return resultList;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    /**
     * 更新专题文章阅览量
     * @param id
     * @return
     */
    public int updateArticleViewsByID(int id){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            ArticleMapper mapper = sqlSession.getMapper(ArticleMapper.class);
            result = mapper.updateArticleViews(id);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            result = -1;
            if(sqlSession != null)
                sqlSession.rollback();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return result;
    }

}
