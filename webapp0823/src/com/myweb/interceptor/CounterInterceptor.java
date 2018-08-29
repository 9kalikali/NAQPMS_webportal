package com.myweb.interceptor;


import com.myweb.myutils.PageViewStatistics;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class CounterInterceptor implements HandlerInterceptor {

    private static Logger log = LoggerFactory.getLogger(CounterInterceptor.class);
    private static String VIEWER = "person";
    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest,
                             HttpServletResponse httpServletResponse,
                             Object o) throws Exception {
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest,
                           HttpServletResponse httpServletResponse,
                           Object o, ModelAndView modelAndView) throws Exception {
        //System.out.println("This is postHandler!");
        Long l = PageViewStatistics.newInstance().increase(VIEWER);
        log.debug("Fuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuck:"+l);
    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest,
                                HttpServletResponse httpServletResponse,
                                Object o, Exception e) throws Exception {

    }
}
