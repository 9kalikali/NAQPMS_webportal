package com.myweb.service;

import com.myweb.model.Chart;
import com.myweb.model.Job;
import com.myweb.model.JobDetail;
import com.myweb.model.PageInfo;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface JobService {

    int submitJob(Job job, JobDetail jobDetail);

    void testSubmit();

    List<Job> queryAllJobs();

    List<Job> queryUserJob(String userid);

    List<Job> queryRecycledUserJob(Job job, PageInfo pageInfo);

    JobDetail getJobDetail(String jobid);

    int getJobCount();

    int getRunningJobCount();

    int getUserJobCount(String userid);

    int getUserJobCountByStatus(String userid, String status);

    int deleteJob(String jobid);

    int recycleJob(String jobid);

    int derecycleJob(String jobid);

    List<Chart> getJobStatistics(String year);

    List<Job> queryJobsByPage(Job job, PageInfo pageInfo);

    int queryCount0(String userId);

    List<Job> selectAllByUserid0(Integer pageSize, Integer pageNumber, String userId);

    Boolean updateIsRecycled(String jobId);

    Boolean updateNotRecycled(String jobId);

    JobDetail selectByJobId(String jobId);

    List<Job> queryAllJobs(Integer pageSize, Integer pageNumber);
}