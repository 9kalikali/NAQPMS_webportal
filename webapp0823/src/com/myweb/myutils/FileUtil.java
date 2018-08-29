package com.myweb.myutils;

import com.myweb.model.Job;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class FileUtil {

    private static float GB_BASE = 1024*1024;
    private static Logger log = LoggerFactory.getLogger(FileUtil.class);

    /**
     * 创建文件
     * @param filePath
     * @return
     */
    public static boolean creatFile(String filePath){
        boolean flag = false;
        try {
            File newfile = new File(filePath);
            if(!newfile.exists()){
                newfile.createNewFile();
                flag = true;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return flag;
    }

    /**
     * 读文件
     * @param filepath
     * @return
     */
    public static String readTxtFile(String filepath){
        String result = "";
        File file = new File(filepath);
        try {
            InputStreamReader reader = new InputStreamReader(new FileInputStream(file), "UTF-8");
            BufferedReader br = new BufferedReader(reader);
            String s = null;
            while ((s = br.readLine()) != null) {
                result += s;
                //System.out.println(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * 覆写文件
     * @param filePath
     * @param content
     * @return
     */
    public static boolean writeTxtFile(String filePath, String content){
        boolean flag = false;
        FileOutputStream fileOutputStream = null;
        File file = new File(filePath);
        try {
            fileOutputStream = new FileOutputStream(file);
            fileOutputStream.write(content.getBytes("UTF-8"));
            fileOutputStream.close();
            flag = true;
        } catch (Exception e) {
            log.error("================文件写入失败！==============");
            e.printStackTrace();
        }
        return flag;
    }

    /**
     * 追加文件内容
     * @param filePath
     * @param content
     * @return
     */
    public static boolean appendTxtFile(String filePath, String content){
        boolean flag = false;
        try {
            // 构造函数中的第二个参数true表示以追加形式写文件
            FileWriter fw = new FileWriter(filePath, true);
            fw.write(content);
            fw.close();
            flag = true;
        } catch (IOException e) {
            log.error("==============文件写入失败！=============");
            e.printStackTrace();
        }
        return flag;
    }

    /**
     * 获取服务器的路径
     * @return
     */
    public static String getServerPath(){
        return System.getProperty("catalina.home");
    }

    public String[] renameFiles(String[] fileNames, Job job){
        for(int i=0;i<fileNames.length;i++){
            fileNames[i] = renameFile(fileNames[i], job);
        }
        return fileNames;
    }

    /**
     * 如果传入文件名为a.sh,当前时间为2018-03-02 09:13:44,则新文件名为admin_20180302091344_a.sh
     * @param fileName
     * @return
     */
    public String renameFile(String fileName, Job job){
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
        String time = df.format(new Date());// new Date()为获取当前系统时间
        String prefixOfFileName =
                time.replace("-", "").replace(" ", "").replace(":", "");
        fileName = job.getUserId() + "_" + prefixOfFileName+ "_" +fileName;
        return fileName;
    }

    /**
     * 还原文件名，去掉添加在文件名开头的时间,共14个字符
     * @param fileName
     * @return
     */
    public String restoreFileName(String fileName, Job job){
        fileName.substring(14+job.getUserId().length(), fileName.length()-1);
        return fileName;
    }

    public ArrayList<String> getFileListFromDB(String fileNames){
        String fileNames1 = fileNames.substring(1, fileNames.length()-2);//去掉"[]"
        String[] fileNames2 = fileNames1.split(",");
        ArrayList<String> filesList = new ArrayList<String>();
        for (int i = 0; i < fileNames2.length; i++) {
            filesList.add(fileNames2[i]);
        }
        return filesList;
    }


//    public ArrayList<String> getFileNamesFromDir(String dir){
//        ArrayList<String> fileNames = new ArrayList<String>();
//        File file = new File(dir);
//        File[] tempList = file.listFiles();
//
//        System.out.println("00000000000000000000000000000");
//        System.out.println("dir:"+ dir);
//        System.out.println("tempList.length:"+ tempList.length);
//        System.out.println("00000000000000000000000000000");
//        for (int i = 0; i < tempList.length; i++) {
//            if(tempList[i].isFile()){
//                fileNames.add(tempList[i].getName());
//            }
//        }
//        return fileNames;
//    }

    /**
     * 获取目录下的所有文件和子目录的名称
     * @param path 目录路径
     * @param baselength 基路径长度，方便提取后续路径
     * @return dirList 文件&目录名的List
     */
    public static List<FileInfo> getDirList(String path, int baselength){
        log.debug("FileUtil:"+path);
        List<FileInfo> dirList =  new ArrayList<FileInfo>();
        File file = new File(path);
        if(file.isDirectory()){
            File[] fileList = file.listFiles();
            for(int i = 0; i < fileList.length; i++){
                String name = fileList[i].getName();
                String size = fileList[i].isFile() ? String.valueOf(fileList[i].length() / GB_BASE) : "-";
                String type = fileList[i].isFile() ? name.substring(name.lastIndexOf(".") + 1) : "-";
                log.debug("fileSize:"+size + " fileLength:"+ fileList[i].length());
                String fpath = fileList[i].getAbsolutePath().substring(baselength).replaceAll("/","*");
                dirList.add(new FileInfo(name, (size.equals("-") ? size : size.substring(0,4)), type, fpath));
            }
        }else {
            dirList = null;
        }
        return dirList;
    }

    public static class FileInfo{

        private String filename;
        private String filesize;
        private String filetype;
        private String filepath;

        public FileInfo(String n, String s, String t, String p){
            this.filename = n;
            this.filesize = s;
            this.filetype = t;
            this.filepath = p;
        }

        public String getFilename() {
            return filename;
        }

        public void setFilename(String filename) {
            this.filename = filename;
        }

        public String getFilesize() {
            return filesize;
        }

        public void setFilesize(String filesize) {
            this.filesize = filesize;
        }

        public String getFiletype() {
            return filetype;
        }

        public void setFiletype(String filetype) {
            this.filetype = filetype;
        }

        public String getFilepath() {
            return filepath;
        }

        public void setFilepath(String filepath) {
            this.filepath = filepath;
        }
    }
}
