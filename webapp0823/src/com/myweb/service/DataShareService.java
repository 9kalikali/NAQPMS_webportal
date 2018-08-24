package com.myweb.service;

import com.myweb.model.Dataset;
import com.myweb.myutils.FileUtil;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Service
public interface DataShareService {

    ArrayList getFirstDir();

    ArrayList getSecondDir();

    Dataset getDataset(String categoryId);

    int queryDSCount();

    List<Dataset> getDatasetList(int pageSize, int pageNumber);

    List<Dataset> selectByCategoryId(String categoryId);

    List<FileUtil.FileInfo> listFiles(String path);

    String packing(ArrayList<String> filenames) throws IOException, InterruptedException;

}
