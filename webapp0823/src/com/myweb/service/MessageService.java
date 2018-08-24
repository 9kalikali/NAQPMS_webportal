package com.myweb.service;

import com.myweb.model.Message;
import com.myweb.model.PageInfo;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface MessageService {

    List<Message> queryMessageByPage(String recid, PageInfo pageInfo);

    List<Message> queryMessageBackByPage(String sendid, Message message, PageInfo pageInfo);

    Message queryMessageByID(int id);

    String queryMessageText(String messageid);

    int queryUnreadCount(String recid);

    int readMessage(int id);

    int recycleMessage(int id);

    int insertMessage(Message message);

    int deleteMessage(int id);

}
