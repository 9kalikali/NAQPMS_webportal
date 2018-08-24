package com.myweb.controller;

import com.alibaba.fastjson.JSON;
import com.myweb.model.Job;
import com.myweb.model.JobDetail;
import com.myweb.model.Page;
import com.myweb.model.PageInfo;
import com.myweb.myutils.FileUtil;
import com.myweb.service.JobService;
import org.apache.commons.io.FileUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class JobController {

    private static Logger log = LoggerFactory.getLogger(JobController.class);


    @Autowired
    private JobService jobService;
    /**
     * 接收并处理用户从浏览器提交的计算任务的相关参数
     * @param request
     * @return
     * @throws IOException
     * @throws InterruptedException
     */
    @ResponseBody
    @RequestMapping(value = "/dosubmitargs", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    public String submitJobByArgs(HttpServletRequest request){
        Job job = new Job();
        JobDetail jobDetail = new JobDetail();
        log.debug("jobid="+request.getParameter("jobName"));
        String jobid = request.getParameter("jobName");
        //获取userid
        for (Cookie cookie : request.getCookies()) {
            if (cookie.getName().equals("userid")) {
                job.setUserId(cookie.getValue());
            }
        }

        //接收参数——初始化job
        job.setJobId(jobid);
        job.setType("args");
        //初始化jobdetail
        //log.debug("minlon="+request.getParameter("minlon"));
        jobDetail.setJobid(jobid);
        jobDetail.setMinlon(request.getParameter("minlon"));
        jobDetail.setMaxlon(request.getParameter("maxlon"));
        jobDetail.setMinlat(request.getParameter("minlat"));
        jobDetail.setMaxlat(request.getParameter("maxlat"));
        jobDetail.setStartTime(request.getParameter("starttime"));
        jobDetail.setEndTime(request.getParameter("endtime"));
        jobDetail.setSteplength(Integer.parseInt(request.getParameter("steplength")));
        jobDetail.setStdout(request.getParameter("stdout"));
        jobDetail.setStderr(request.getParameter("stderr"));
        jobDetail.setDir(request.getParameter("dir"));
        jobDetail.setCpus(Integer.parseInt(request.getParameter("CPUs")));

        //提交计算任务并将信息录入数据库
        int result = jobService.submitJob(job,jobDetail);
        if(result > 0){
            return "提交成功!";
        }else{
            return "提交失败!";
        }

    }

    /**
     * 接收并处理用户从浏览器提交的计算任务的脚本文件
     * @param inputFiles
     * @param request
     * @return
     * @throws IOException
     * @throws InterruptedException
     */
    @ResponseBody
    @RequestMapping(value = "/dosubmitfile",method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    public String submitJobByScript(@RequestParam(value = "inputFiles", required = false) MultipartFile inputFiles,
                                        HttpServletRequest request) throws IOException, InterruptedException {
        Job job = new Job();
        JobDetail jobDetail = new JobDetail();
        String jobid = request.getParameter("jobName");

        //从cookies获取userid
        for (Cookie cookie : request.getCookies()) {
            if (cookie.getName().equals("userid")) {
                job.setUserId(cookie.getValue());
                System.out.println("userid:" + job.getUserId());
            }
        }
        //文件存储位置
        String path = "/home/usersubmit" + "/" + job.getUserId();
        //接收参数，不包括文件，初始化jobDetail, job
        job.setJobId(jobid);
        job.setType("file");
        //初始化jobdetail
        jobDetail.setJobid(jobid);
        jobDetail.setScriptfilepath(path);
        //接收文件
        ArrayList<String> fileNamesList = new ArrayList<String>();
        List<MultipartFile> files = null;
        if (request instanceof MultipartHttpServletRequest) {
            files = ((MultipartHttpServletRequest) request).getFiles("inputFiles");
        }

        FileUtil fu = new FileUtil();
        if (files != null) {
            for (MultipartFile file : files) {
                String fileName = fu.renameFile(file.getOriginalFilename(), job);//按照”文件重命名规则“重命名文件
                fileNamesList.add(fileName);
                File dir = new File(path, fileName);
                if (!dir.exists()) {
                    dir.getParentFile().mkdirs();
                }
                dir.createNewFile();
                file.transferTo(dir);//MultipartFile自带的解析方法
            }
        }

        String filenamesJson = "{";
        for (int j = 0; j < fileNamesList.size(); j++) {
            filenamesJson = filenamesJson + "\"file" + j + "\" : " + "\"" +fileNamesList.get(j) + "\"";
            if(j != fileNamesList.size()-1){
                filenamesJson = filenamesJson + ",";
            }
        }
        filenamesJson = filenamesJson + "}";
        jobDetail.setScriptfilenames(filenamesJson);
        //提交计算任务并将信息录入数据库
        int result = jobService.submitJob(job,jobDetail);
        if(result > 0){
            return "提交成功!";
        }else{
            return "提交失败!";
        }
    }

    @ResponseBody
    @RequestMapping(value = "/testsubmit")
    public String testSubmit(){
        jobService.testSubmit();
        return "1";
    }
    /**
     * 用户从web服务器下载计算任务的结果文件
     * @param request
     * @param response
     * @return
     * @throws IOException
     */
    @RequestMapping(value = "/downloadResult")
    @ResponseBody
    public ResponseEntity<byte[]> downloadFromWebServer(@RequestParam(value = "jobId") String jobId, HttpServletRequest request, HttpServletResponse response) throws IOException, InterruptedException {
        String path = "/home/result/"+ jobId;
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
        String time = df.format(new Date());// new Date()为获取当前系统时间
        String prefixOfFileName =
                time.replace("-", "").replace(" ", "").replace(":", "");
        String targetFilePath = "/home/result/" + prefixOfFileName + ".tar.gz";
        String cmd = "tar zcvPf " + targetFilePath + " " + path;
        Process process;
        process = Runtime.getRuntime().exec(cmd);
        process.waitFor();
        File dir = new File(targetFilePath);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentDispositionFormData("attachment", targetFilePath);
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        response.setContentType("application/octet-stream");
        return new ResponseEntity<byte[]>(FileUtils.readFileToByteArray(dir),
                headers, HttpStatus.CREATED);
    }

    /**
     * web服务器从计算服务器上下载计算任务的结果文件，并保存在web服务器上，以供用户下载
     * @return
     */
    public String downloadFromComputingServer(){
        return null;
    }

    /**
     * 用户查询提交的某一个作业的详细信息
     * @param jobId
     * @return
     */
    @RequestMapping(value = "/queryJob", produces = "plain/text;charset=UTF-8")
    @ResponseBody
    public String queryAllByJobId(@RequestParam(name = "jobId") String jobId){
        System.out.println("in CONTROLLER");
        System.out.println(jobId);
        JobDetail jobDetail = jobService.selectByJobId(jobId);
        return JSON.toJSONString(jobDetail);
    }

    /**
     * 查询某个用户的所有作业，不在回收站中，方法名末尾带“0”则是不在回收站中的意思
     * @param userId
     * @param pageSize
     * @param pageNumber
     * @return
     */
    @RequestMapping(value = "/queryJobs0", produces = "plain/text;charset=UTF-8")
    @ResponseBody
    public String queryAllByUseridServer(@RequestParam(name= "userId") String userId, Integer pageSize, Integer pageNumber){
        //查询该用户下所有未在回收站的jobs数量
        int total = jobService.queryCount0(userId);
        List<Job> jobsList = jobService.selectAllByUserid0(pageSize, pageNumber, userId);
        Page page = new Page();
        String resultJson = JSON.toJSONString(jobsList);
        page.setTotal(total);
        page.setRows(jobsList);
        return JSON.toJSONString(page);
    }

    /**
     * 将计算任务放入回收站
     * 将指定job的isRecycled的值改为“1”
     * @param jobId
     * @return
     */
    @RequestMapping(value = "/deleteToRecycleBin", produces = "plain/text;charset=UTF-8")
    @ResponseBody
    public String deleteToRecycleBin(@RequestParam(name = "jobId") String jobId){
        Boolean flag = jobService.updateIsRecycled(jobId);
        if(flag){
            return "200";
        }else {
            return "500";
        }
    }

    /**
     * 将计算任务从回收站还原
     * 将指定job的isRecycled的值改为“0”
     * @param jobId
     * @return
     */
    @RequestMapping(value = "/restoreFromRecycleBin", produces = "plain/text;charset=UTF-8")
    @ResponseBody
    public String restoreFromRecycleBin(@RequestParam(name = "jobId") String jobId){
        Boolean flag = jobService.updateNotRecycled(jobId);
        if(flag){
            return "200";
        }else {
            return "500";
        }
    }

    /**
     * 删除计算任务
     * @param jobId
     * @return
     */
    @RequestMapping(value = "/deleteCompletely", produces = "plain/text;charset=UTF-8")
    @ResponseBody
    public String deleteCompletely(@RequestParam(name = "jobId") String jobId){
        int flag = jobService.deleteJob(jobId);
        if(flag>0){
            return "200";
        }else {
            return "500";
        }
    }

    /**
     * 初始化前台任务列表
     * @return
     */
    @RequestMapping(value = "/joblist/{userid}")
    public ModelAndView pageJobslist(Model model, @PathVariable(value = "userid")String userid){
        List<Job> jobList;
        PageInfo pageInfo = new PageInfo();
        pageInfo.setPageNum(1);
        Job jobb = new Job();
        jobb.setUserId(userid);
        jobList = jobService.queryJobsByPage(jobb,pageInfo);
        jobList.forEach(job -> {
            job.setType(job.getType().equals("args")? "参数":"脚本");
            switch (job.getStatus()){
                case "0":
                    job.setStatus("<span class=\"glyphicon glyphicon-minus\" style='color: #070580'></span> 排队中");
                    break;
                case "1":
                    job.setStatus("<i class=\"fa fa-spinner fa-spin\"></i> 运行中");
                    break;
                case "2":
                    job.setStatus("<span class=\"glyphicon glyphicon-ok\" style='color: #1DC116'></span> 已完成");
                    break;
            }
        });
        model.addAttribute("pageinfo",pageInfo);
        model.addAttribute("jobList",jobList);
        return new ModelAndView("users/joblistb").addObject(new Job());
    }

    /**
     * 初始化前台回收站列表
     * @return
     */
    @RequestMapping(value = "/jobrecyclelist/{userid}")
    public String pageRecycledJobslist(Model model, @PathVariable(value = "userid")String userid){
        List<Job> jobList;
        PageInfo pageInfo = new PageInfo();
        pageInfo.setPageNum(1);
        Job jobb = new Job();
        jobb.setUserId(userid);
        jobList = jobService.queryRecycledUserJob(jobb,pageInfo);
        jobList.forEach(job -> {
            job.setType(job.getType().equals("args")? "参数":"脚本");
            switch (job.getStatus()){
                case "0":
                    job.setStatus("<span class=\"glyphicon glyphicon-minus\" style='color: #070580'></span> 排队中");
                    break;
                case "1":
                    job.setStatus("<i class=\"fa fa-spinner fa-spin\"></i> 运行中");
                    break;
                case "2":
                    job.setStatus("<span class=\"glyphicon glyphicon-ok\" style='color: #1DC116'></span> 已完成");
                    break;
            }
        });
        model.addAttribute("pageinfo",pageInfo);
        model.addAttribute("jobList",jobList);
        return "users/jobrecyclelistb";
    }

    /**
     * 按条件分页查询计算任务列表
     * @param pagenum
     * @param job
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/searchjobs/{userid}_{pagenum}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    public String searchJobsControl(@PathVariable(value = "pagenum")String pagenum, @PathVariable(value = "userid") String userid, @ModelAttribute Job job){

        List<Job> jobList = new ArrayList<Job>();
        PageInfo pageInfo = new PageInfo();
        String jsonString = "";
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        job.setUserId(userid);
        if(job.getStatus().equals("3")){
            job.setStatus("");
        }
        jobList = jobService.queryJobsByPage(job,pageInfo);
        jobList.forEach(jobb -> {
            jobb.setType(jobb.getType().equals("args")? "参数":"脚本");
            switch (jobb.getStatus()){
                case "0":
                    jobb.setStatus("<span class=\"glyphicon glyphicon-minus\" style='color: #070580'></span> 排队中");
                    break;
                case "1":
                    jobb.setStatus("<i class=\"fa fa-spinner fa-spin\"></i> 运行中");
                    break;
                case "2":
                    jobb.setStatus("<span class=\"glyphicon glyphicon-ok\" style='color: #1DC116'></span> 已完成");
                    break;
            }
            jobb.setSubmitTime(jobb.getSubmitTime().substring(0,19));
        });
        Map map = new HashMap();
        map.put("joblist",jobList);
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

    /**
     * 按条件分页查询回收站列表
     * @param pagenum
     * @param userid
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/searchrecyclejobs/{userid}_{pagenum}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    public String searchRecycleJobsControl(@PathVariable(value = "pagenum")String pagenum, @PathVariable(value = "userid") String userid){

        List<Job> jobList = new ArrayList<Job>();
        PageInfo pageInfo = new PageInfo();
        String jsonString = "";
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        Job job = new Job();
        job.setUserId(userid);
        jobList = jobService.queryRecycledUserJob(job,pageInfo);
        jobList.forEach(jobb -> {
            jobb.setType(jobb.getType().equals("args")? "参数":"脚本");
            switch (jobb.getStatus()){
                case "0":
                    jobb.setStatus("<span class=\"glyphicon glyphicon-minus\" style='color: #070580'></span> 排队中");
                    break;
                case "1":
                    jobb.setStatus("<i class=\"fa fa-spinner fa-spin\"></i> 运行中");
                    break;
                case "2":
                    jobb.setStatus("<span class=\"glyphicon glyphicon-ok\" style='color: #1DC116'></span> 已完成");
                    break;
            }
            jobb.setSubmitTime(jobb.getSubmitTime().substring(0,19));
        });
        Map map = new HashMap();
        map.put("joblist",jobList);
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
}
