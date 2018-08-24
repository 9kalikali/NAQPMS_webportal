package com.myweb.service.impl;

import com.myweb.dao.DatasetDao;
import com.myweb.model.Dataset;
import com.myweb.model.DatasetCategory;
import com.myweb.myutils.FileUtil;
import com.myweb.service.DataShareService;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service("datashareService")
public class DataShareServiceImpl implements DataShareService {
    //测试用1
    //private static String DATASET_BASE_PATH = "/home/dataset/";
    //测试用2
    private static String DATASET_BASE_PATH = "/usr/share/hyrax/data/";

    @Override
    public ArrayList<DatasetCategory> getFirstDir() {
        DatasetDao dao = new DatasetDao();
        return dao.getFirstDir();
    }

    @Override
    public ArrayList getSecondDir() {
        DatasetDao dao = new DatasetDao();
        return dao.getSecondDir();
    }

    @Override
    public Dataset getDataset(String categoryId) {
        DatasetDao dao = new DatasetDao();
        Dataset ds = dao.getDatasetByCategoryId(categoryId);
        return ds;
    }

    @Override
    public int queryDSCount() {
        DatasetDao dao = new DatasetDao();
        int total = dao.queryCount();
        return total;
    }

    @Override
    public List<Dataset> getDatasetList(int pageSize, int pageNumber) {
        DatasetDao dao = new DatasetDao();
        List<Dataset> dsList = dao.selectAll();
        List<Dataset> dsListShowed = new ArrayList<Dataset>();
        int j = 0;
        for (int i = pageSize*(pageNumber-1); i < ((pageSize*pageNumber<dsList.size())? pageSize*pageNumber: dsList.size()); i++) {
            //System.out.println("第"+pageNumber+"页第"+j+"行："+ dsList.get(i));
            dsListShowed.add(dsList.get(i));
            j++;
        }
        return dsListShowed;
    }

    @Override
    public List<Dataset> selectByCategoryId(String categoryId) {
        DatasetDao dao = new DatasetDao();
        List<Dataset> dsList = dao.selectByCategoryId(categoryId);
        return dsList;
    }

    @Override
    public List<FileUtil.FileInfo> listFiles(String path) {
        return FileUtil.getDirList(DATASET_BASE_PATH + path, DATASET_BASE_PATH.length());
    }

    @Override
    public String packing(ArrayList<String> filenames)throws IOException, InterruptedException {
        String s = "";
        for (int i = 0; i < filenames.size(); i++) {
            s += DATASET_BASE_PATH + filenames.get(i) + " ";
        }

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
        String time = df.format(new Date());// new Date()为获取当前系统时间
        String prefixOfFileName =
                time.replace("-", "").replace(" ", "").replace(":", "");
        String targetFilePath = "/home/resource/temp/" + prefixOfFileName + ".tar.gz";
        String cmd = "tar zcvf " + targetFilePath + " " + s;
        System.out.println(cmd);
        Process process;
        process = Runtime.getRuntime().exec(cmd);
        process.waitFor();
        return targetFilePath;
    }


//    public static void main(String[] args){
//        DataShareServiceImpl dataShareServiceImpl = new DataShareServiceImpl();
//        List<FileUtil.FileInfo> list = dataShareServiceImpl.listFiles("/Users/renxuanzhengbo/Movies/[Yousei-raws] Haiyore! Nyaruko-san [BDrip 1920x1080 x264 FLAC]");
//        list.forEach(fileInfo -> {
//            System.out.println("Name:"+fileInfo.getFilename() + " Size:"+fileInfo.getFilesize() + " Type:"+fileInfo.getFiletype());
//        });
//    }

}
