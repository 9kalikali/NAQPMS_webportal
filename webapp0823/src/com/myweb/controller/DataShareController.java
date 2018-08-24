package com.myweb.controller;

import com.myweb.model.Dataset;
import com.myweb.myutils.FileUtil;
import com.myweb.service.DataShareService;
import com.myweb.service.UserService;
import org.apache.commons.io.IOUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping(value = "/datashare")
public class DataShareController {

    @Autowired
    UserService userService;
    @Autowired
    DataShareService dataShareService;

    private static Logger log = LoggerFactory.getLogger(PlatFormInfoController.class);
    private static String URL_PATH = "http://47.92.125.215:8080/opendap/data/nc/testdir/beforeDA2015010100.nc.html";

    /**
     * 检查用户下载权限
     * @param request
     * @return
     */
    @RequestMapping(value = "/checkPermission", method = RequestMethod.POST)
    @ResponseBody
    public String checkPermission(HttpServletRequest request){
        String userId = request.getParameter("userId");
        String dataLevel = request.getParameter("dataLevel");
        if(userService.isDataAvaliable(userId, Integer.parseInt(dataLevel))){
            return "true";
        }else {
            return "false";
        }
    }

    /**
     * 返回数据集目录
     * @param categoryId
     * @return
     */
    @RequestMapping(value = "/page2/{categoryId}")
    public ModelAndView toTestPage2(@PathVariable(value = "categoryId") String categoryId){
        Dataset ds = dataShareService.getDataset(categoryId);
        ds.setShareLevel(ds.getShareLevel().split(":")[1]);
        return new ModelAndView("front/downloadtestpage2").addObject("dataset",ds);
    }

    /**
     * 返回对应数据集中数据列表
     * @param path
     * @return
     */
    @RequestMapping(value = "/listFiles/{path:.+}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    @ResponseBody
    public String listFiles(@PathVariable(value = "path") String path, Model model){
        String temp = path.equals("init") ? "" : path.replaceAll("\\*","/");
        log.debug("Temp:"+ path );
        List<FileUtil.FileInfo> fileList = dataShareService.listFiles(temp);
        ObjectMapper objectMapper = new ObjectMapper();
        String jsonString = null;
        if(null != fileList){
            try {
                jsonString = objectMapper.writeValueAsString(fileList);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }else{
            jsonString = "null";
        }
        return jsonString;
    }

    @RequestMapping(value = "/dataextract/{filename}")
    public ModelAndView go2OPeNDAP(@PathVariable(value = "filename") String filename){
        log.debug("Filename:"+filename);
        return new ModelAndView(new RedirectView(URL_PATH));
    }

    /**
     * 打包下载文件——.tar.gz
     * @param request
     * @param response
     * @throws IOException
     * @throws InterruptedException
     */
    @RequestMapping(value = "/downloadFiles", method = RequestMethod.POST)
    public void downloadFiles(HttpServletRequest request, HttpServletResponse response) throws IOException, InterruptedException {
        int len = request.getParameterValues("files").length;
        ArrayList<String> filenames = new ArrayList<>();
        for (int i = 0; i < len; i++) {
            log.debug("Request:"+request.getParameterValues("files")[i]);
            filenames.add(request.getParameterValues("files")[i].replaceAll("s","/"));
        }

        //将选择的文件打包压缩
        String path = dataShareService.packing(filenames);
        String filename = path.split("/")[4];
        String contentDisposition = "attachment;filename=" + URLEncoder.encode(filename,"utf-8");
        FileInputStream input = new FileInputStream(path);

        // 设置头
        response.setHeader("Content-Type","application/octet-stream;charset=utf-8");
        response.setHeader("Content-Disposition",contentDisposition);

        // 获取绑定了客户端的流
        ServletOutputStream output = response.getOutputStream();

        // 把输入流中的数据写入到输出流中
        IOUtils.copy(input, output);
        input.close();
    }

}
