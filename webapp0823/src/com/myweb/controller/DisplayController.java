package com.myweb.controller;

import com.myweb.service.DisplayService;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

/**
 * 绘图控制器
 * 负责绘图相关的交互工作
 */
@Controller
@RequestMapping(value = "/displayer")
public class DisplayController {

    public static Logger log = LoggerFactory.getLogger(DisplayController.class);

    @Autowired
    DisplayService displayService;


//    @RequestMapping(value = "/drawresult")
//    public String pageResult(){
//        return "drawresult";
//    }

    /**
     * 返回图片序列的url
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/showimages",method = RequestMethod.POST)
    public String showImagesControl(HttpServletRequest request){
        String jsonString = "";
        ObjectMapper objectMapper = new ObjectMapper();
        String domain = request.getParameter("domain");
        String step = request.getParameter("step");
        String source = request.getParameter("source");
        String date = request.getParameter("date");
        domain = "RegPol"+domain;
        log.debug("domain="+domain+" step="+step+" source="+source+" date="+date);

        List<String> imgList = displayService.getDisplayUrl("",date,domain,source,step);
        if(imgList == null){
            return "fail";
        }else{
            try {
                jsonString = objectMapper.writeValueAsString(imgList);
            } catch (IOException e) {
                e.printStackTrace();
            }
            return jsonString;
        }
    }


    /**
     * 返回热力图的数据
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/heatmapdata", method = RequestMethod.GET)
    public String heatmapData(HttpServletRequest request){
        String source = request.getParameter("source");
        String time = request.getParameter("time");
        System.out.println(source);
        System.out.println(time);
        return displayService.getSourceData(source,time);
    }


}
