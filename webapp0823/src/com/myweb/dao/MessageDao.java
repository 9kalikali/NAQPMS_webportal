package com.myweb.dao;

import com.myweb.mapper.MessageMapper;
import com.myweb.model.Message;
import com.myweb.myutils.DBUtil;
import org.apache.ibatis.session.SqlSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class MessageDao {

    private static final String SYSTEM_ID = "system";

    /**
     * 获取用户的通知
     * @param parameter
     * @return
     */
    public List<Message> queryMessageByPage(Map parameter){
        SqlSession sqlSession = null;
        List<Message> messageList = new ArrayList<Message>();
        try{
            sqlSession = DBUtil.getSqlSession();
            messageList = sqlSession.selectList("Message.queryMessageByPage",parameter);
            return messageList;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    /**
     * 后台按条件分页查询通知
     * @param parameter
     * @return
     */
    public List<Message> queryMessageBackByPage(Map parameter){
        SqlSession sqlSession = null;
        List<Message> messagesList = new ArrayList<Message>();
        try{
            sqlSession = DBUtil.getSqlSession();
            messagesList = sqlSession.selectList("Message.queryMessageBackByPage",parameter);
            return messagesList;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    /**
     * 获取用户未读的通知数
     * @param recid
     * @return
     */
    public int queryUnreadCount(String recid){
        SqlSession sqlSession = null;
        int count = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            MessageMapper mapper = sqlSession.getMapper(MessageMapper.class);
            count = mapper.queryUnreadCount(recid);
        }catch (Exception e){
            e.printStackTrace();
            count = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return count;
    }

    /**
     * 将通知标记为已读
     * @param id
     * @return
     */
    public int readMessage(int id){
        SqlSession sqlSession = null;
        int result = 0;
        try {
            sqlSession = DBUtil.getSqlSession();
            MessageMapper mapper = sqlSession.getMapper(MessageMapper.class);
            result = mapper.readMessage(id);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            if(sqlSession!=null)
                sqlSession.rollback();
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return result;
    }

    /**
     * 将通知放到回收站
     * @param id
     * @return
     */
    public int recycleMessage(int id){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            MessageMapper mapper = sqlSession.getMapper(MessageMapper.class);
            result = mapper.recycleMessage(id);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            if(sqlSession != null)
                sqlSession.rollback();
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return result;
    }

    public Message queryMessageByID(int id){
        SqlSession sqlSession = null;
        Message message = new Message();
        try{
            sqlSession = DBUtil.getSqlSession();
            MessageMapper mapper = sqlSession.getMapper(MessageMapper.class);
            message = mapper.queryMessageByID(id);
            return message;
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return null;
    }

    public String queryMessageText(String messageid){
        SqlSession sqlSession = null;
        try{
            sqlSession = DBUtil.getSqlSession();
            MessageMapper mapper = sqlSession.getMapper(MessageMapper.class);
            return mapper.queryMessageText(messageid);
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return "";
    }

    public int insertMessage(Message message){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            MessageMapper mapper = sqlSession.getMapper(MessageMapper.class);
            mapper.insertMessage(message);
            mapper.insertMessageText(message);
            result = 1;
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            sqlSession.rollback();
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return result;
    }


    public int deleteMessageByID(int id){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            MessageMapper mapper = sqlSession.getMapper(MessageMapper.class);
            result = mapper.deleteMessageByID(id);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            sqlSession.rollback();
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return result;
    }

    public int deleteMessageText(String messageid){
        SqlSession sqlSession = null;
        int result = 0;
        try{
            sqlSession = DBUtil.getSqlSession();
            MessageMapper mapper = sqlSession.getMapper(MessageMapper.class);
            result = mapper.deleteMessageTextByID(messageid);
            sqlSession.commit();
        }catch (Exception e){
            e.printStackTrace();
            sqlSession.rollback();
            result = -1;
        }finally {
            if(sqlSession != null){
                sqlSession.close();
            }
        }
        return result;
    }


//    public static void main(String[] args){
//        MessageDao dao = new MessageDao();
//        Message message = new Message();
//        message.setSendID("root");
//        message.setRecID("admin");
//        message.setMessageID("20180402094410");
//        message.setMessage("hahahahahahaheheheheehehe");
//
//        int ressult = dao.insertMessage(message);
//
//        System.out.println("message=");
//
//    }
}
