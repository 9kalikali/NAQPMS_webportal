package com.myweb.interceptor;

import java.sql.Connection;
import com.myweb.model.PageInfo;
import org.apache.ibatis.executor.parameter.ParameterHandler;
import org.apache.ibatis.executor.statement.StatementHandler;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.reflection.MetaObject;
import org.apache.ibatis.reflection.SystemMetaObject;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;
import java.util.Properties;

/**
 * 分页拦截器
 */
@Intercepts({@Signature(type = StatementHandler.class,method = "prepare",args={Connection.class,Integer.class})})
public class PageInterceptor implements Interceptor {
    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        StatementHandler statementHandler = (StatementHandler) invocation.getTarget();
        //通过反射的方式获取statementhandler
        MetaObject metaObject = SystemMetaObject.forObject(statementHandler);
        MappedStatement mappedStatement = (MappedStatement) metaObject.getValue("delegate.mappedStatement");
        //获取配置文件中sql语句的id
        String id = mappedStatement.getId();
        //拦截ByPage结尾的sql语句
        if(id.matches(".+ByPage$")){
            BoundSql boundSql = statementHandler.getBoundSql();
            //原始的SQL语句
            String sql = boundSql.getSql();
            //查询条数SQL
            String countSql = "SELECT COUNT(*) FROM ("+ sql +")a";
            Connection connection = (Connection) invocation.getArgs()[0];
            PreparedStatement countStatement = (PreparedStatement) connection.prepareStatement(countSql);
            ParameterHandler parameterHandler = (ParameterHandler) metaObject.getValue("delegate.parameterHandler");
            parameterHandler.setParameters(countStatement);
            ResultSet resultSet = countStatement.executeQuery();
            //获得传入参数
            Map<?,?> parameter = (Map<?, ?>) boundSql.getParameterObject();
            PageInfo pageInfo = (PageInfo) parameter.get("pageinfo");
            //设置查询的总条数
            if(resultSet.next()){
                pageInfo.setTotalNum(resultSet.getInt(1));
            }
            //改造为分页查询的SQL
            String pageSql = sql + " LIMIT " + pageInfo.getDbOffset() + "," + pageInfo.getPageSize();
            metaObject.setValue("delegate.boundSql.sql",pageSql);
        }
        return invocation.proceed();
    }

    @Override
    public Object plugin(Object target) {
        return Plugin.wrap(target,this);
    }

    @Override
    public void setProperties(Properties properties) {

    }
}
