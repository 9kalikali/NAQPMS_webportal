package com.myweb.myutils;

import java.io.*;
import java.util.*;

/**
 * 获取服务器的运行信息
 * cpu使用率、内存占用率、磁盘IO
 * 网络带宽占用率等
 */
public class SystemInfo {

    //测试用
    public final static String HPC_IP = "47.92.125.215";

    /**
     * 输出CPU使用率
     * CPU利用率的计算方法：可以使用取两个采样点，计算其差值的办法。
     * CPU利用率 = 1- (idle2-idle1)/(cpu2-cpu1)
     * @return
     */
    public static int CPURatio(){
        try {
            Map<?, ?> map1 = SystemInfo.cpuinfo();
            Thread.sleep(500);
            Map<?, ?> map2 = SystemInfo.cpuinfo();

            long user1 = Long.parseLong(map1.get("user").toString());
            long nice1 = Long.parseLong(map1.get("nice").toString());
            long system1 = Long.parseLong(map1.get("system").toString());
            long idle1 = Long.parseLong(map1.get("idle").toString());

            long user2 = Long.parseLong(map2.get("user").toString());
            long nice2 = Long.parseLong(map2.get("nice").toString());
            long system2 = Long.parseLong(map2.get("system").toString());
            long idle2 = Long.parseLong(map2.get("idle").toString());

            long total1 = user1 + system1 + nice1;
            long total2 = user2 + system2 + nice2;
            float total = total2 - total1;

            long totalIdle1 = user1 + nice1 + system1 + idle1;
            long totalIdle2 = user2 + nice2 + system2 + idle2;
            float totalidle = totalIdle2 - totalIdle1;

            float cpusage = (total / totalidle) * 100;
            return (int) cpusage;
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 获取CPU信息
     * 查询"/proc/stat"文件
     * @return
     */
    private static Map<?, ?> cpuinfo() {
        InputStreamReader inputs = null;
        BufferedReader buffer = null;
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            inputs = new InputStreamReader(new FileInputStream("/proc/stat"));
            buffer = new BufferedReader(inputs);
            String line = "";
            while (true) {
                line = buffer.readLine();
                if (line == null) {
                    break;
                }
                if (line.startsWith("cpu")) {
                    StringTokenizer tokenizer = new StringTokenizer(line);
                    List<String> temp = new ArrayList<String>();
                    while (tokenizer.hasMoreElements()) {
                        String value = tokenizer.nextToken();
                        temp.add(value);
                    }
                    map.put("user", temp.get(1));
                    map.put("nice", temp.get(2));
                    map.put("system", temp.get(3));
                    map.put("idle", temp.get(4));
                    map.put("iowait", temp.get(5));
                    map.put("irq", temp.get(6));
                    map.put("softirq", temp.get(7));
                    map.put("stealstolen", temp.get(8));
                    break;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(buffer != null){
                    buffer.close();
                    inputs.close();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return map;
    }

    /**
     * 获取内存占用率
     * 从/proc文件系统获取内存使用情况
     * 内存使用率 = 1 - MemFree/MemTotal
     * @return
     */
    public static int MemoryUsage() {
        Map<String, Object> map = new HashMap<String, Object>();
        InputStreamReader inputs = null;
        BufferedReader buffer = null;
        try {
            inputs = new InputStreamReader(new FileInputStream("/proc/meminfo"));
            buffer = new BufferedReader(inputs);
            String line = "";
            while (true) {
                line = buffer.readLine();
                if (line == null)
                    break;
                int beginIndex = 0;
                int endIndex = line.indexOf(":");
                if (endIndex != -1) {
                    String key = line.substring(beginIndex, endIndex);
                    beginIndex = endIndex + 1;
                    endIndex = line.length();
                    String memory = line.substring(beginIndex, endIndex);
                    String value = memory.replace("kB", "").trim();
                    map.put(key, value);
                }
            }

            long memTotal = Long.parseLong(map.get("MemTotal").toString());
            long memFree = Long.parseLong(map.get("MemFree").toString());
            long memused = memTotal - memFree;
            long buffers = Long.parseLong(map.get("Buffers").toString());
            long cached = Long.parseLong(map.get("Cached").toString());

            double usage = (double) (memused - buffers - cached) / memTotal * 100;
            return (int) usage;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if(buffer != null){
                    buffer.close();
                    inputs.close();
                }
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
        return 0;
    }

    /**
     * 获取磁盘IO
     * 利用'iostat -d -x'获取
     * @return
     */
    public static int IOUsage(){
        float ioUsage = 0.0f;
        Process pro = null;
        BufferedReader in = null;
        Runtime r = Runtime.getRuntime();
        try {
            String command = "iostat -d -x";
            pro = r.exec(command);
            in = new BufferedReader(new InputStreamReader(pro.getInputStream()));
            String line = null;
            int count =  0;
            while((line=in.readLine()) != null){
                if(++count >= 4){
                    String[] temp = line.split("\\s+");
                    if(temp.length > 1){
                        float util =  Float.parseFloat(temp[temp.length-1]);
                        ioUsage = (ioUsage>util)?ioUsage:util;
                    }
                }
            }
            if(ioUsage > 0){
                ioUsage *= 100;
            }
        } catch (IOException e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
        }finally {
            if(in != null && pro != null){
                try {
                    in.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                pro.destroy();
            }
        }
        return (int)ioUsage;
    }

    /**
     * 检测web服务器与计算服务器的网络延迟
     * @return
     */
    public static float NetWorkDelay(){
        float ping = -1.0f;
        Process pro;
        Runtime r = Runtime.getRuntime();
        try{
            String command = "ping -c 5 "+HPC_IP;
            pro = r.exec(command);
            BufferedReader in = new BufferedReader(new InputStreamReader(pro.getInputStream()));
            String line = null;
            while ((line = in.readLine()) != null){
                line = line.trim();
                System.out.println("line="+line);
                if(line.startsWith("rtt")){
                    System.out.println("avg="+line.substring(30,33));
                    ping = Float.parseFloat(line.substring(30,33));
                    break;
                }
            }
            in.close();
            pro.destroy();
        }catch (Exception e){
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
        }
        return ping;
    }

    /**
     *网络带宽使用情况
     *统计一段时间内Receive和Tramsmit的bytes数的变化，即可获得网口传输速率
     * 单位：Mbps
     * @return
     */
    public static float NetWorkUsage(){
        float curRate = 0.0f;
        Process pro1,pro2;
        Runtime r = Runtime.getRuntime();
        try {
            String command = "cat /proc/net/dev";
            //第一次采集流量数据
            long startTime = System.currentTimeMillis();
            pro1 = r.exec(command);
            BufferedReader in1 = new BufferedReader(new InputStreamReader(pro1.getInputStream()));
            String line = null;
            long inSize1 = 0, outSize1 = 0;
            while((line=in1.readLine()) != null){
                line = line.trim();
                //System.out.println("line="+line);
                if(line.startsWith("eth0")){
                    String[] temp = line.split("\\s+");
//                    System.out.println("temp0="+temp[0]);
//                    inSize1 = Long.parseLong(temp[1].substring(5)); //Receive bytes,单位为Byte
                    inSize1 = Long.parseLong(temp[1].trim());              //Receive bytes,单位为Byte
                    outSize1 = Long.parseLong(temp[9].trim());             //Transmit bytes,单位为Byte
                    //System.out.println("inSize1="+inSize1);
                    //System.out.println("outSize1="+outSize1);
                    break;
                }
            }
            in1.close();
            pro1.destroy();
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                StringWriter sw = new StringWriter();
                e.printStackTrace(new PrintWriter(sw));

            }
            //第二次采集流量数据
            long endTime = System.currentTimeMillis();
            pro2 = r.exec(command);
            BufferedReader in2 = new BufferedReader(new InputStreamReader(pro2.getInputStream()));
            long inSize2 = 0 ,outSize2 = 0;
            while((line=in2.readLine()) != null){
                line = line.trim();
                if(line.startsWith("eth0")){
                    String[] temp = line.split("\\s+");
//                    inSize2 = Long.parseLong(temp[0].substring(5));
//                    outSize2 = Long.parseLong(temp[8]);
                    inSize2 = Long.parseLong(temp[1].trim());              //Receive bytes,单位为Byte
                    outSize2 = Long.parseLong(temp[9].trim());             //Transmit bytes,单位为Byte
                    //System.out.println("inSize2="+inSize2);
                    //System.out.println("outSize2="+outSize2);
                    break;
                }
            }
            if(inSize1 > 0 && outSize1 > 0 && inSize2 > 0 && outSize2 > 0){
                float interval = (float)(endTime - startTime)/1000;
                //网口传输速度,单位为Mbps
                curRate = (float)(inSize2 - inSize1 + outSize2 - outSize1)*8/(1000000*interval);
                //System.out.println("curRate="+curRate);
            }
            in2.close();
            pro2.destroy();
        } catch (IOException e) {
            StringWriter sw = new StringWriter();
            e.printStackTrace(new PrintWriter(sw));
        }
        return curRate;
    }



//    public static void main(String[] args){
//        System.out.println(SystemInfo.CpuRatio());
//    }
}
