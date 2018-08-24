package com.myweb.service.impl;

import com.myweb.dao.MessageDao;
import com.myweb.model.Message;
import com.myweb.model.PageInfo;
import com.myweb.service.MessageService;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("messageService")
public class MessageServiceImpl implements MessageService {

    private final static int PAGE_SIZE = 5;
    private final static String ASSIGNMENT_COMPLETE = "assignment_complete";

    @Override
    public List<Message> queryMessageByPage(String recid, PageInfo pageInfo) {
        MessageDao dao = new MessageDao();
        Map parameter = new HashMap<>();
        pageInfo.setPageSize(PAGE_SIZE);
        pageInfo.setDbOffset();
        parameter.put("recid",recid);
        parameter.put("pageinfo",pageInfo);
        return dao.queryMessageByPage(parameter);
    }

    @Override
    public Message queryMessageByID(int id) {
        MessageDao dao = new MessageDao();
        return dao.queryMessageByID(id);
    }

    @Override
    public String queryMessageText(String messageid) {
        MessageDao dao = new MessageDao();
        return dao.queryMessageText(messageid);
    }

    @Override
    public int queryUnreadCount(String recid) {
        MessageDao dao = new MessageDao();
        return dao.queryUnreadCount(recid);
    }

    @Override
    public int readMessage(int id) {
        MessageDao dao = new MessageDao();
        return dao.readMessage(id);
    }

    @Override
    public int recycleMessage(int id) {
        MessageDao dao = new MessageDao();
        return dao.recycleMessage(id);
    }

    @Override
    public List<Message> queryMessageBackByPage(String sendid, Message message, PageInfo pageInfo) {
        Map parameter = new HashMap();
        MessageDao dao = new MessageDao();
        pageInfo.setPageSize(PAGE_SIZE);
        pageInfo.setDbOffset();
        parameter.put("sendid",sendid);
        parameter.put("message",message);
        parameter.put("pageinfo",pageInfo);
        return dao.queryMessageBackByPage(parameter);
    }

    @Override
    public int insertMessage(Message message) {
        MessageDao dao = new MessageDao();
        return dao.insertMessage(message);
    }

    //先删文本再删记录
    @Override
    public int deleteMessage(int id) {
        MessageDao dao = new MessageDao();
        Message message = dao.queryMessageByID(id);
        String messageid = message.getMessageID();
        //判断是否为计算任务完成的通知，是的话只删除记录
        if(messageid != null && !message.equals(ASSIGNMENT_COMPLETE)){
            dao.deleteMessageText(messageid);
        }
        return dao.deleteMessageByID(id);
    }
}
