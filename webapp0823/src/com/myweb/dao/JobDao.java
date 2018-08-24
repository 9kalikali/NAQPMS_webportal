package com.myweb.dao;

import com.myweb.mapper.JobMapper;
import com.myweb.model.Chart;
import com.myweb.model.Job;
import com.myweb.model.JobDetail;
import com.myweb.myutils.DBUtil;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class JobDao {


    /**
     * 向作业表中插入记录
     *
     * @param job
     * @param jobDetail
     * @return
     */
    public int insertJob(Job job, JobDetail jobDetail) {
        SqlSession sqlSession = null;
        int result = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            if (jobMapper.queryJobDetailCountByJobID(job.getJobId()) > 0) {
                result = -1;
                return result;
            }
            jobMapper.insertJob(job);
            if (job.getType().equals("file")) {
                jobMapper.insertScript(jobDetail);
            } else {
                jobMapper.insertArgs(jobDetail);
            }
            sqlSession.commit();
            result = 1;
        } catch (Exception e) {
            e.printStackTrace();
            if (sqlSession != null)
                sqlSession.rollback();
            result = -1;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return result;
    }

    /**
     * 查询所有作业
     *
     * @return
     */
    public List<Job> queryAllJobs() {
        SqlSession sqlSession = null;
        List<Job> resultList = null;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            resultList = jobMapper.queryAllJobs();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return resultList;
    }

    /**
     * 查询用户没被回收的作业
     *
     * @param userid
     * @return
     */
    public List<Job> queryUserJob(String userid) {
        SqlSession sqlSession = null;
        List<Job> resultList = null;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            resultList = jobMapper.queryJobByUserID(userid);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return resultList;
    }

    /**
     * 查询用户被回收的作业
     *
     * @param userid
     * @return
     */
    public List<Job> queryRecycledUserJob(String userid) {
        SqlSession sqlSession = null;
        List<Job> resultList = null;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            resultList = jobMapper.queryRecycledJobByUserID(userid);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return resultList;
    }

    /**
     * 查询作业详情
     *
     * @param jobid
     * @return
     */
    public JobDetail queryJobDetail(String jobid) {
        SqlSession sqlSession = null;
        JobDetail jobDetail = null;
        try {
            System.out.println("in DAO");
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            jobDetail = jobMapper.queryJobDetail(jobid);
            System.out.println("joid:"+ jobDetail.getJobid()+ " minlat:"+ jobDetail.getMinlat()+
                    " dir:"+jobDetail.getDir()+ " endtime"+jobDetail.getEndTime()+" scriptfilenames"+ jobDetail.getScriptfilenames()+ " cpus"+jobDetail.getCpus());

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return jobDetail;
    }

    /**
     * 查询作业数量
     *
     * @return
     */
    public int queryJobCount() {
        SqlSession sqlSession = null;
        int count = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            count = jobMapper.queryCount();
        } catch (Exception e) {
            e.printStackTrace();
            count = -1;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return count;
    }

    /**
     * 查询正在运行的作业数量
     *
     * @return
     */
    public int queryRunningCount() {
        SqlSession sqlSession = null;
        int count = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            count = jobMapper.queryRunningCount();
        } catch (Exception e) {
            e.printStackTrace();
            count = -1;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return count;
    }

    /**
     * 查询用户的作业数量
     *
     * @param userid
     * @return
     */
    public int queryUserJobCount(String userid) {
        SqlSession sqlSession = null;
        int count = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            count = jobMapper.queryJobCountByUser(userid);
        } catch (Exception e) {
            e.printStackTrace();
            count = -1;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return count;
    }

    /**
     * 按状态查询用户作业数量
     *
     * @param userid
     * @return
     */
    public int queryUserJobCountByStauts(String userid, String status) {
        SqlSession sqlSession = null;
        int count = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            count = jobMapper.queryUserJobCountByStatus(userid, status);
        } catch (Exception e) {
            e.printStackTrace();
            count = -1;
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return count;
    }

    /**
     * 删除作业
     * 删除作业信息和作业详情两个表中的内容
     *
     * @param jobid
     * @return
     */
    public int deleteJob(String jobid) {
        SqlSession sqlSession = null;
        int result = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            jobMapper.deleteJobDetail(jobid);
            jobMapper.deleteJob(jobid);
            sqlSession.commit();
            result = 1;
        } catch (Exception e) {
            e.printStackTrace();
            result = -1;
            if (sqlSession != null)
                sqlSession.rollback();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return result;
    }

    /**
     * 将作业标记为已回收
     *
     * @param jobid
     * @return
     */
    public int updateIsRecycled(String jobid) {
        SqlSession sqlSession = null;
        int result = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            result = jobMapper.updateIsRecycled(jobid);
            sqlSession.commit();
        } catch (Exception e) {
            e.printStackTrace();
            result = -1;
            if (sqlSession != null)
                sqlSession.rollback();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return result;
    }

    /**
     * 将作业标记为未回收
     *
     * @param jobid
     * @return
     */
    public int updateNotRecycled(String jobid) {
        SqlSession sqlSession = null;
        int result = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            result = jobMapper.updateNotRecycled(jobid);
            sqlSession.commit();
        } catch (Exception e) {
            e.printStackTrace();
            result = -1;
            if (sqlSession != null)
                sqlSession.rollback();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return result;
    }

    /**
     * 后台作业统计
     *
     * @param year
     * @return
     */
    public List<Chart> queryJobCountByMonth(String year) {
        SqlSession sqlSession = null;
        List<Chart> resultList = null;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper jobMapper = sqlSession.getMapper(JobMapper.class);
            resultList = jobMapper.queryJobCountByMonth(year);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }

        return resultList;
    }

    /**
     * 分页查询作业列表
     *
     * @param parameter
     * @return
     */
    public List<Job> queryJobsByPage(Map parameter) {
        SqlSession sqlSession = null;
        List<Job> resultList = new ArrayList<Job>();
        try {
            sqlSession = DBUtil.getSqlSession();
            resultList = sqlSession.selectList("Job.queryJobsByPage", parameter);
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return null;
    }

    /**
     * 分页查询回收作业列表
     *
     * @param parameter
     * @return
     */
    public List<Job> queryRecycledJobsByPage(Map parameter) {
        SqlSession sqlSession = null;
        List<Job> resultList = new ArrayList<Job>();
        try {
            sqlSession = DBUtil.getSqlSession();
            resultList = sqlSession.selectList("Job.queryRecycledJobsByPage", parameter);
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return null;
    }

    public int queryCountByUserId0(String userId) {
        SqlSession sqlSession = null;
        int result = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            JobMapper mapper = sqlSession.getMapper(JobMapper.class);
            result = mapper.queryCountByUserId0(userId);
            return  result;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (sqlSession != null) {
                sqlSession.close();
            }
        }
        return result;
    }

    public ArrayList<Job> selectAllByUserid0(String userId) {
        ArrayList<Job> jobsList = new ArrayList<Job>();
        SqlSession sqlSession = null;
        try{
            sqlSession = DBUtil.getSqlSession();
            JobMapper mapper = sqlSession.getMapper(JobMapper.class);
            jobsList = mapper.selectByIsRecycled(userId, "0");
            sqlSession.commit();
            return jobsList;
        }catch(IOException e){
            e.printStackTrace();
        }finally{
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return jobsList;
    }


//    public static void main(String[] args){
//        JobDao dao = new JobDao();
//        int count = dao.queryUserJobCountByStauts("test1","1");
//        System.out.println(count);
//    }
}
