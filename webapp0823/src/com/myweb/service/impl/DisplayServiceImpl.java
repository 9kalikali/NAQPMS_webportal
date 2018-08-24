package com.myweb.service.impl;

import com.myweb.service.DisplayService;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import ucar.nc2.NetcdfFile;
import ucar.nc2.Variable;
import ucar.nc2.dataset.NetcdfDataset;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

/**
 * 利用ProcessBuilder执行本地命令
 */
@Service("displayService")
public class DisplayServiceImpl implements DisplayService {
    //debug输出
    private static final String TAG = "DisplayService";
    private static Logger log = LoggerFactory.getLogger(DisplayServiceImpl.class);
    //获取图片的基本路径
    private static final String BASE_URL = "http://159.226.119.101/tempfig";
    //private static final String BASE_URL = "http://47.92.125.215:8080/home/display";
    //测试用
    //private static final String BASE_URL = "/display/";

    /**
     * 返回图片数据的URL
     * @param type 图片的种类 Region;Station;Weather_Chart
     * @param date 当日日期+"12"
     * @param domain 世界范围或华北地区 RegPol1;RegPol2
     * @param source 污染源
     * @param step 跨度每小时/每天 hourly/daily
     * @return
     */
    @Override
    public List<String> getDisplayUrl(String type, String date, String domain, String source, String step) {
        int start = 2;
        int end = 1;
        int stepsize = 1;
        List<String> resultList = new ArrayList<String>();
        date = date.replaceAll("-", "");
        String url = "";
        int num = 1;
        //设置偏移量
        if (step.equals("daily")) {
            stepsize = 4;
        }
        //设置区域
        //世界范围总共65张图片/组
        //京津冀地区共128图片/组
        if (domain.equals("RegPol1")) {
            start = 1;
            end = 65;
        }
        if (domain.equals("RegPol2")) {
            start = 2;
            end = 129;
        }
        //测试链接是否正常
        String testUrl = BASE_URL + type + "/" + date + "12/" + domain + "/" + source + "/" + pngName(start);
        log.debug("TestURL:"+testUrl);
        if(!testConnection(testUrl)){
            return null;
        }
        for (; start <= end; start+=stepsize) {
            url = BASE_URL + type + "/" + date + "12/" + domain + "/" + source + "/" + pngName(start);
            log.debug(url);
            resultList.add(url);
        }
        return resultList;
    }

    /**
     * 返回000.png格式的文件名
     * @param num
     * @return
     */
    private String pngName(int num){
        if(num < 10){
            return "00"+num+".png";
        }
        if(num >= 10 && num <100){
            return "0"+num+".png";
        }
        return String.valueOf(num)+".png";
    }

    /**
     *测试链接的方法
     * @param url
     * @return
     */
    private boolean testConnection(String url){
        try{
            URL urlObj = new URL(url);
            HttpURLConnection oc = (HttpURLConnection) urlObj.openConnection();
            oc.setUseCaches(false);
            oc.setConnectTimeout(3000);
            int status = oc.getResponseCode();
            if(status == 200){
                return true;
            }else{
                return false;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 从netcdf文件中读取热力图的元数据
     * 利用netcdf的库处理nc文件的数据，记得将其jar包拷贝到tomcat的lib文件夹下
     * origin指的是各个维度的起点，size指的是读取的个数并非是各个维度的终点
     * @param source 污染源名称
     * @param time 时间
     * @return 二维数组 一定范围内的污染源标量
     */
    @Override
    public String getSourceData(String source, String time) {
        //本地测试用
        //String sourcename = "/Users/renxuanzhengbo/Documents/ncForDisplay/beforeDA20150101"+time+".nc";
        //String filename = "/Users/renxuanzhengbo/Documents/ncForDisplay/lonlatM.nc";
        //服务器用
        String sourcename = "/home/display/ncForDisplay/beforeDA20150101"+time+".nc";
        String filename = "/home/display/ncForDisplay/lonlatM.nc";
        NetcdfFile ncfile = null;
        String jsonString = "";
        List<DataPoint> dataPoints = new ArrayList<DataPoint>();
        try {
            //读取经纬度文件
            ncfile = NetcdfDataset.open(filename);
            Variable lonM = ncfile.findVariable("lonM");
            Variable latM = ncfile.findVariable("latM");
            double[][] lonArray = (double[][]) lonM.read().copyToNDJavaArray();
            double[][] latArray = (double[][]) latM.read().copyToNDJavaArray();
            //读取污染源的值
            ncfile = NetcdfDataset.open(sourcename);
            Variable sourceValue = ncfile.findVariable(source);
            float[][] sourceArray = (float[][]) sourceValue.read().reduce().copyToNDJavaArray();
            //生成相应格式
            for(int i=0;i<sourceArray.length;i++){
                for (int j=0;j<sourceArray[0].length;j++){
                    //System.out.println("lon="+lonArray[i][j]+",lat="+latArray[i][j]+",count="+sourceArray[i][j]);
                    dataPoints.add(new DataPoint(lonArray[i][j],latArray[i][j], (int) sourceArray[i][j]));
                }
            }
            //转换为json字串
            ObjectMapper objectMapper = new ObjectMapper();
            jsonString = objectMapper.writeValueAsString(dataPoints);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if(ncfile != null) {
                try {
                    ncfile.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return jsonString;
    }

//    public static void main(String[] args){
//        String sourcename = "/Users/renxuanzhengbo/Documents/ncForDisplay/beforeDA2015010101.nc";
//        String filename = "/Users/renxuanzhengbo/Documents/ncForDisplay/lonlatM.nc";
//        NetcdfFile ncfile = null;
//        try {
//            System.out.println(1);
//            //读取文件
//            ncfile = NetcdfDataset.open(filename);
//            //读取其中的值
//            Variable v1 = ncfile.findVariable("lonM");
//            Variable v2 = ncfile.findVariable("latM");
//            double[][] lonArray = (double[][]) v1.read().copyToNDJavaArray();
//            double[][] latArray = (double[][]) v2.read().copyToNDJavaArray();
//            System.out.println(lonArray.length);
//            System.out.println(lonArray[0].length);
//            System.out.println(latArray.length);
//            System.out.println(latArray[0].length);
//            ncfile = NetcdfDataset.open(sourcename);
//            Variable source = ncfile.findVariable("pm25");
//            float[][] sourceArray = (float[][]) source.read().reduce().copyToNDJavaArray();
//            System.out.println(sourceArray.length);
//            System.out.println(sourceArray[0].length);
//            //System.out.println(sourceArray[0][0].length);
//            for(int i=0;i<sourceArray.length;i++){
//                for(int j=0;j<sourceArray[0].length;j++){
//                    System.out.println("lon="+lonArray[i][j]+",lat="+latArray[i][j]+",count="+sourceArray[i][j]);
//                }
//            }
//
//        } catch (IOException e) {
//            e.printStackTrace();
//        } finally {
//            if(ncfile != null) {
//                try {
//                    ncfile.close();
//                } catch (IOException e) {
//                    e.printStackTrace();
//                }
//            }
//        }
//    }


    static class DataPoint{
        public double lng;
        public double lat;
        public int count;

        DataPoint(double lng, double lat, int count) {
            this.lng = lng;
            this.lat = lat;
            this.count = count;
        }
    }
}
