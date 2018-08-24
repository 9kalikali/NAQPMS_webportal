package com.myweb.myutils;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.Reader;

/**
 * 数据库相关工具
 */
public class DBUtil {

    /**
     * 获取数据库链接
     * @return
     * @throws IOException
     */
    public static SqlSession getSqlSession() throws IOException {
        //通过配置文件获取数据库链接信息
        Reader reader =  Resources.getResourceAsReader("com/myweb/myutils/Configuration.xml");
        //通过配置信息构建SqlSessionFactory
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);
        //通过sqlSessinFactory打开数据库会话
        return sqlSessionFactory.openSession();
    }

}
