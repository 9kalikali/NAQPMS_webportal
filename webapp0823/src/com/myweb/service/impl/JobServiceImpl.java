package com.myweb.service.impl;

import com.myweb.dao.JobDao;
import com.myweb.model.Chart;
import com.myweb.model.Job;
import com.myweb.model.JobDetail;
import com.myweb.model.PageInfo;
import com.myweb.service.JobService;
import org.springframework.stereotype.Service;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("jobService")
public class JobServiceImpl implements JobService {

    private final static  String PATH = "/home/usersubmit";
    //计算服务器IP地址，目前为测试用机并不是真实的计算服务器
    private final static  String HPC_IP = "39.106.215.146";
    private final static int PAGE_SIZE = 6;

    /**
     * 文件提交到    /home/usersubmit/
     * 为每个提交作业的用户新建一个文件夹，以userId命名。第一次提交时创建此文件夹    /home/usersubmit/admin/
     * 将用户提交的脚本以及新生成的脚本重新命名，加上userId，时间前缀    /home/usersubmit/admin/admin_20180418132513_run.ksh
     * 将作业名称改为userId_时间,admin_20180418132513
     * 作业名称中的前缀和需要提交的脚本的前缀一致
     * 作业名称在浏览器脚本中生成
     * 然后连接计算服务器
     * 提交命令、参数、脚本
     * @param job
     * @param jobDetail
     * @return
     */
    @Override
    public int submitJob(Job job, JobDetail jobDetail) {
        List<String> targetFileNames = new ArrayList<String>();
        int result = 1;
        JobDao dao = new JobDao();
        //-------------------------生成脚本文件----------------------//
        if(job.getType() == "args"){
            //新生成脚本文件
            String path = PATH + "/" + job.getUserId() + "/" + job.getJobId() + "_" + "run.sh";
            File file = new File(path);
            BufferedReader br = null;
            BufferedWriter bw = null;
            if(!file.exists()){
                file.getParentFile().mkdirs();
            }
            try {
                file.createNewFile();
                //模板脚本文件 /home/usersubmit/model-run.ksh
                File fileModel = new File(PATH+"/model-run.ksh");
                //按照模板写刚刚新建的文件
                br = new BufferedReader(new FileReader(fileModel));
                bw = new BufferedWriter(new FileWriter(file));
                String line;
                while ((line = br.readLine()) != null){
                    line = updateArgs(line, jobDetail);
                    bw.write(line+"\r\n");
                }
            } catch (IOException e) {
                e.printStackTrace();
                result = -1;
                return result;
            }finally {
                if(br != null && bw != null){
                    try {
                        br.close();
                        bw.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                        result = -1;
                    }

                }
            }
            targetFileNames.add(file.getName());
        }else{
            String filenames = jobDetail.getScriptfilenames().replace("{", "").replace("}", "").replace(" ", "");
            String[] filenamesArray = filenames.split(",");
            for (int i = 0; i < filenamesArray.length; i++) {
                targetFileNames.add(filenamesArray[i].split(":")[1].replace("\"", ""));
            }
        }
        //----------------------------向HPC递交计算任务，并将记录插入数据库-----------------------//
        targetFileNames.forEach(filename->{
            System.out.println("====================filename:"+filename+"======================");
            String filepath = PATH+"/"+job.getUserId()+"/"+filename;
            if(send2HPC(filepath)){
                dao.insertJob(job,jobDetail);
            }
        });

        return result;
    }

    @Override
    public List<Job> queryAllJobs() {
        JobDao dao = new JobDao();
        return dao.queryAllJobs();
    }

    @Override
    public List<Job> queryUserJob(String userid) {
        JobDao dao = new JobDao();
        return dao.queryUserJob(userid);
    }

    //有所更改
    @Override
    public List<Job> queryRecycledUserJob(Job job, PageInfo pageInfo) {
        Map parameter = new HashMap();
        JobDao dao = new JobDao();
        pageInfo.setPageSize(PAGE_SIZE);
        pageInfo.setDbOffset();
        parameter.put("job",job);
        parameter.put("pageinfo",pageInfo);

        return dao.queryRecycledJobsByPage(parameter);
    }

    @Override
    public JobDetail getJobDetail(String jobid) {
        JobDao dao = new JobDao();
        return dao.queryJobDetail(jobid);
    }

    @Override
    public int getJobCount() {
        JobDao dao = new JobDao();
        return dao.queryJobCount();
    }

    @Override
    public int getRunningJobCount() {
        JobDao dao = new JobDao();
        return dao.queryRunningCount();
    }

    @Override
    public int getUserJobCount(String userid) {
        JobDao dao = new JobDao();
        return dao.queryUserJobCount(userid);
    }

    @Override
    public int getUserJobCountByStatus(String userid,String status) {
        JobDao dao = new JobDao();
        return dao.queryUserJobCountByStauts(userid,status);
    }

    @Override
    public int deleteJob(String jobid) {
        JobDao dao = new JobDao();
        return dao.deleteJob(jobid);
    }

    @Override
    public int recycleJob(String jobid) {
        JobDao dao = new JobDao();
        return dao.updateIsRecycled(jobid);
    }

    @Override
    public int derecycleJob(String jobid) {
        JobDao dao = new JobDao();
        return dao.updateNotRecycled(jobid);
    }

    @Override
    public List<Chart> getJobStatistics(String year) {
        JobDao dao = new JobDao();
        return dao.queryJobCountByMonth(year);
    }

    @Override
    public void testSubmit(){
        send2HPC(null);
    }

    /**
     * 向HPC提交计算任务申请
     * @param scripts 脚本文件名
     * @return
     */
    private static boolean send2HPC(String scripts) {
        InputStream in = null;
        BufferedReader br = null;
        try{
            /**
             * ProcessBuilder参数(command, args1, args2....)
             * 此处执行submit 脚本并输入参数
             * submit脚本接收的参数：
             * arg1高性能计算机的ip;
             * arg2计算任务脚本路径(要用绝对路径);
             */
            ProcessBuilder processBuilder = new ProcessBuilder("./submit.sh",HPC_IP,scripts);
            Process process = processBuilder.start();
            if(process.waitFor() != 0){
                //System.exit(1);
                throw new Exception("脚本执行错误！！");
            }
            in = process.getInputStream();
            br = new BufferedReader(new InputStreamReader(in));
            String temp = null;
            while ((temp = br.readLine()) != null){
                System.out.println("output:"+temp);
            }
            //结束子进程
            process.destroy();
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }finally {
            if(in != null){
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (br != null){
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        return true;
    }

    private String updateArgs(String line, JobDetail jobDetail) {
        String ss;
        if (line.matches(".*\\$[1-9].*")) {
            ss = line.substring(line.indexOf("export") + 7);
            System.out.println(ss);
            if (ss.startsWith("NE")) {
                line = line.replaceFirst("\\$[1-9]", jobDetail.getJobid());
                System.out.println(line);
            } else if (ss.startsWith("count")) {
                line = line.replaceFirst("\\$[1-9]", String.valueOf(jobDetail.getCpus()));
                System.out.println(line);
            } else if (ss.startsWith("STARTDATE")) {
                line = line.replaceFirst("\\$[1-9]", jobDetail.getStartTime());
                System.out.println(line);
            } else if (ss.startsWith("INTERVAL")) {
                line = line.replaceFirst("\\$[1-9]", String.valueOf(jobDetail.getSteplength()));
                System.out.println(line);
            } else if (ss.startsWith("RANGE")) {
                line = line.replaceFirst("\\$[1-9]", jobDetail.getEndTime());
                System.out.println(line);
            } else if (ss.startsWith("dd")) {
                System.out.println("jobId:" + jobDetail.getJobid());
                line = line.replaceFirst("\\$[1-9]", jobDetail.getMinlat());
                System.out.println(line);
            } else if (ss.startsWith("WRF_RUNDIR")) {
                line = line.replaceFirst("\\$[1-9]", jobDetail.getDir());
                System.out.println(line);
            }
        }
        return line;
    }

    @Override
    public List<Job> queryJobsByPage(Job job, PageInfo pageInfo) {
        Map parameter = new HashMap();
        JobDao dao = new JobDao();
        pageInfo.setPageSize(PAGE_SIZE);
        pageInfo.setDbOffset();
        parameter.put("job",job);
        parameter.put("pageinfo",pageInfo);

        return dao.queryJobsByPage(parameter);
    }

    @Override
    public int queryCount0(String userId) {
        JobDao dao = new JobDao();
        int count = dao.queryCountByUserId0(userId);
        return count;
    }

    @Override
    public List<Job> selectAllByUserid0(Integer pageSize, Integer pageNumber, String userId) {
        ArrayList<Job> jobsListAll;
        ArrayList<Job> jobsList = new ArrayList<>();
        JobDao dao = new JobDao();
        jobsListAll = dao.selectAllByUserid0(userId);
        int j = 0;
        for (int i = pageSize*(pageNumber-1); i < ((pageSize*pageNumber<jobsListAll.size())? pageSize*pageNumber: jobsListAll.size()); i++) {
            System.out.println("第"+pageNumber+"页第"+j+"行："+ jobsListAll.get(i));
            jobsList.add(jobsListAll.get(i));
            j++;
        }
        return jobsList;
    }

    @Override
    public Boolean updateIsRecycled(String jobId) {
        JobDao dao = new JobDao();
        if(dao.updateIsRecycled(jobId) > 0){
            return true;
        }else {
            return false;
        }
    }

    @Override
    public Boolean updateNotRecycled(String jobId) {
        JobDao dao = new JobDao();
        if(dao.updateNotRecycled(jobId) > 0){
            return true;
        }else {
            return false;
        }
    }

    @Override
    public JobDetail selectByJobId(String jobId) {
        System.out.println("in SERVICE");
        JobDetail jobDetail;
        JobDao dao = new JobDao();
        jobDetail = dao.queryJobDetail(jobId);
        return jobDetail;
    }

    @Override
    public List<Job> queryAllJobs(Integer pageSize, Integer pageNumber) {
        List<Job> jobsListAll;
        List<Job> jobsList = new ArrayList<>();
        JobDao dao = new JobDao();
        jobsListAll = dao.queryAllJobs();
        int j = 0;
        for (int i = pageSize*(pageNumber-1); i < ((pageSize*pageNumber<jobsListAll.size())? pageSize*pageNumber: jobsListAll.size()); i++) {
            System.out.println("第"+pageNumber+"页第"+j+"行："+ jobsListAll.get(i));
            jobsList.add(jobsListAll.get(i));
            j++;
        }
        return jobsList;
    }
}