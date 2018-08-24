package com.myweb.controller;


import com.myweb.model.Message;
import com.myweb.model.PageInfo;
import com.myweb.service.MessageService;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.*;

@Controller
@RequestMapping(value = "/message")
public class MessageController {

    private Logger log = LoggerFactory.getLogger(MessageController.class);
    @Autowired
    private MessageService messageService;

    /**
     * 用户端站内信页面
     * @param recid 接受人id
     * @param pagenum 页数
     * @param model
     * @return
     */
    @RequestMapping(value = "/messagelist/{recid}_{pagenum}")
    public String pageMessageList(@PathVariable(value = "recid") String recid, @PathVariable(value = "pagenum") String pagenum,Model model){
        List<Message> messageList = new ArrayList<Message>();
        PageInfo pageInfo = new PageInfo();
        if(pagenum == null || pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else{
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        messageList = messageService.queryMessageByPage(recid,pageInfo);
        model.addAttribute("messagelist",messageList);
        model.addAttribute("pageinfo",pageInfo);
        return "users/messagelist";
    }

    /**
     * 站内信未读数量
     * @param recid
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/unreadcount/{recid}", method = RequestMethod.POST)
    public String getUnreadCountControl(@PathVariable(value = "recid")String recid){
        int count = messageService.queryUnreadCount(recid);
        //log.debug("count="+count);
        if(count > 0){
            return String.valueOf(count);
        }else{
            return "";
        }
    }

    /**
     * 站内信内容
     * @param messageid
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/messagetext/{messageid}", method = RequestMethod.POST)
    public String getMessageTextControl(@PathVariable(value = "messageid") String messageid){
        String text = messageService.queryMessageText(messageid);
        return text;
    }

    /**
     * 读取站内信
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/readmessage/{id}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    public String readMessageControl(@PathVariable(value = "id")String id){
        int result = messageService.readMessage(Integer.parseInt(id));
        Message message = messageService.queryMessageByID(Integer.parseInt(id));
        log.debug("message:"+message.getMessage());
        if(result > 0){
            return message.getMessage();
        }else{
            return "";
        }
    }

    //--------------------------站内信后台----------------------------//

    /**
     * 后台站内信列表
     * @param model
     * @param sendid
     * @return
     */
    @RequestMapping(value = "/admin/messagelist/{sendid}")
    public ModelAndView pageBackMessageList(Model model, @PathVariable(value = "sendid")String sendid){
        //初始化站内信列表
        List<Message> messageList = new ArrayList<Message>();
        PageInfo pageInfo = new PageInfo();
        pageInfo.setPageNum(1);
        messageList = messageService.queryMessageBackByPage(sendid, new Message(), pageInfo);
        model.addAttribute("pageinfo",pageInfo);
        model.addAttribute("messageList", messageList);
        return new ModelAndView("background/backmessagelist").addObject(new Message());
    }

    /**
     * 站内信查询
     * @param message
     * @param sendid
     * @param pagenum
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/searchmessages/{sendid}_{pagenum}", method = RequestMethod.POST, produces = "plain/text;charset=UTF-8")
    public String searchMessagesControl(@ModelAttribute Message message, @PathVariable(value = "sendid")String sendid,
                                        @PathVariable(value = "pagenum")String pagenum){
        List<Message> messageList = new ArrayList<Message>();
        PageInfo pageInfo = new PageInfo();
        String jsonSring = "";
        if(pagenum != null && pagenum.equals("0")){
            pageInfo.setPageNum(1);
        }else if(pagenum != null){
            pageInfo.setPageNum(Integer.parseInt(pagenum));
        }
        messageList = messageService.queryMessageBackByPage(sendid,message,pageInfo);
        Map map = new HashMap();
        map.put("messagelist",messageList);
        map.put("totalpages",pageInfo.count());
        map.put("curpage",pageInfo.getPageNum());
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            jsonSring = objectMapper.writeValueAsString(map);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jsonSring;
    }

    /**
     * 删除站内信
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/admin/deletemessage/{id}")
    public String deleteMessageControl(@PathVariable(value = "id")String id){
        int result = messageService.deleteMessage(Integer.parseInt(id));
        if(result > 0){
            return "success";
        }else{
            return "fail";
        }
    }

    /**
     * 站内信发送页面
     * @return
     */
    @RequestMapping(value = "/admin/postmessage")
    public String pagePostMessage(){
        return "background/postmessage";
    }

    /**
     * 发送站内信
     * @param request
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/dopostmessage", method = RequestMethod.POST)
    public String postMessageControl(HttpServletRequest request){

        long milliseconds = new Date().getTime();
        String sendid = request.getParameter("sendid");
        String recid = request.getParameter("recid");
        String messagetxt = request.getParameter("msg-content");
        //用毫秒数作为message的id
        String messageid = String.valueOf(milliseconds);
        Message message = new Message();
        message.setSendID(sendid);
        message.setRecID(recid);
        message.setMessageID(messageid);
        message.setMessage(messagetxt);
        int result = messageService.insertMessage(message);

        if(result > 0){
            return "success";
        }else{
            return "fail";
        }
    }
}
