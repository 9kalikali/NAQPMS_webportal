package com.myweb.mapper;

import com.myweb.model.Chart;
import com.myweb.model.Job;
import com.myweb.model.JobDetail;
import org.apache.ibatis.annotations.*;

import java.util.ArrayList;
import java.util.List;

public interface JobMapper {
/*    @Select("select count(*) from job where userid = #{userId} and isrecycled= \"0\"")
    int queryJobsCount0(String userId);*/

    @Select("select * from job where jobid=#{jobId}")
    Job selectByJobId(@Param("jobId") String jobId);

    @Select("select resultspath from job where jobid=#{jobId}")
    String selectResult(@Param("jobId") String jobId);

    @Select("select * from job where userid=#{userId} and isrecycled=#{isRecycled}")
    ArrayList<Job> selectByIsRecycled(@Param("userId") String userId, @Param("isRecycled") String isRecycled);

    @Select("SELECT COUNT(*) FROM job WHERE userid=#{userid} AND isrecycled=\"0\"")
    int queryCountByUserId0(String userid);

    @Select("SELECT COUNT(*) FROM job WHERE userid=#{userid} AND isrecycled=\"1\"")
    int queryCountByUserId1(String userid);

    @Delete("delete from job where jobid=#{jobId}")
    int delete(@Param("jobId") String jobId);

    @Select("select * from job")
    ArrayList<Job> selectAll();

    //--------------------------------------------------Ren----------------------------------------------------//

    @Insert("INSERT INTO job(jobid, userid, type) VALUES (#{jobid}, #{userid}, #{type})")
    int insertJob(Job job);

    /**
     * 提交为脚本时
     */
    @Insert("INSERT INTO jobdetail(jobid, scriptfilenames, scriptfilepath) VALUES (#{jobid}, #{scriptfilename}, #{scriptfilepath})")
    int insertScript(JobDetail jobDetail);

    /**
     * 提交为参数时
     * @param jobDetail
     * @return
     */
    @Insert("INSERT INTO jobdetail(jobid, minlon, minlat, maxlon, maxlat, cenlon, cenlat, starttime, endtime, steplength, stdout, stderr, dir, cpus) " +
            "VALUES (#{jobid}, #{minlon}, #{minlat}, #{maxlon}, #{maxlat}, #{cenlon}, #{cenlat}, #{startTime}, #{endTime}, #{steplength}, #{stdout}, #{stderr}, #{dir}, #{cpus})")
    int insertArgs(JobDetail jobDetail);

    /**
     * 查询作业详情标中是否存在该记录
     * @param jobid
     * @return
     */
    @Select("SELECT COUNT(*) FROM jobdetail WHERE jobid=#{jobid}")
    int queryJobDetailCountByJobID(String jobid);

    @Select("SELECT * FROM job")
    List<Job> queryAllJobs();

    @Select("SELECT * FROM job WHERE userid=#{userid} AND isrecycled='0'")
    List<Job> queryJobByUserID(String userid);

    @Select("SELECT * FROM job WHERE userid=#{userid} AND isrecycled='1'")
    List<Job> queryRecycledJobByUserID(String userid);

    @Select("SELECT * FROM jobdetail WHERE jobid=#{jobid}")
    JobDetail queryJobDetail(String jobid);

    @Select("SELECT COUNT(*) FROM job")
    int queryCount();

    @Select("SELECT COUNT(*) FROM job WHERE status='1'")
    int queryRunningCount();

    @Select("SELECT COUNT(*) FROM job WHERE userid=#{userid}")
    int queryJobCountByUser(String userid);

    @Select("SELECT COUNT(*) FROM job WHERE userid=#{userid} AND status=#{status}")
    int queryUserJobCountByStatus(@Param(value = "userid") String userid, @Param(value = "status") String status);

    @Delete("DELETE FROM job WHERE jobid=#{jobid}")
    int deleteJob(String jobid);

    @Delete("DELETE FROM jobdetail WHERE jobid=#{jobid}")
    int deleteJobDetail(String jobid);

    @Update("UPDATE job SET isrecycled = '1' WHERE jobid=#{jobId}")
    int updateIsRecycled(String jobId);

    @Update("UPDATE job SET isrecycled = '0' WHERE jobid=#{jobId}")
    int updateNotRecycled(String jobId);

    /**
     * 查询当年每个月计算任务的数量
     * @param year
     * @return
     */
    @Select("SELECT DATE_FORMAT(submittime,'%m') AS categories, COUNT(*) AS ydata FROM job WHERE DATE_FORMAT(submittime,'%Y')=#{year} GROUP BY DATE_FORMAT(submittime,'%m') ORDER BY categories")
    List<Chart> queryJobCountByMonth(String year);


}
