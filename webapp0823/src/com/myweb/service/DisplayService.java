package com.myweb.service;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface DisplayService {

    List<String> getDisplayUrl(String type, String date, String domain, String source, String step);

    String getSourceData(String source, String time);
}
