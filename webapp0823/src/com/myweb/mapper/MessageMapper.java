package com.myweb.mapper;

import com.myweb.model.Message;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.stereotype.Service;

public interface MessageMapper {

    @Select("SELECT COUNT(*) FROM message WHERE (RecID = '0' OR RecID = #{recid}) AND Status = 0")
    int queryUnreadCount(String recid);

    @Update("UPDATE message SET Status = 1 WHERE ID = #{id}")
    int readMessage(int id);

    @Update("UPDATE message SET Status = 2 WHERE ID = #{id}")
    int recycleMessage(int id);

    @Select("SELECT a.ID,a.SendID,a.RecID,a.PDate,a.Status,a.MessageID,b.Message FROM\n" +
            "        (SELECT * FROM message WHERE ID = #{id}) AS a\n" +
            "        LEFT JOIN messagetext b ON a.MessageID = b.MessageID ")
    Message queryMessageByID(int id);

    @Select("SELECT Message FROM messagetext WHERE MessageID = #{messageid}")
    String queryMessageText(String messageid);

    @Insert("INSERT INTO message(SendID, RecID, MessageID) VALUES (#{SendID}, #{RecID}, #{MessageID})")
    int insertMessage(Message message);

    @Insert("INSERT INTO messagetext(MessageID, Message) VALUES (#{MessageID}, #{Message})")
    int insertMessageText(Message message);

    @Delete("DELETE FROM message WHERE ID = #{id}")
    int deleteMessageByID(int id);

    @Delete("DELETE FROM messagetext WHERE MessageID = #{messageid}")
    int deleteMessageTextByID(String messageid);
}
