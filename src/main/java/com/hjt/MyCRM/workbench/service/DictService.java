package com.hjt.MyCRM.workbench.service;

import com.hjt.MyCRM.workbench.domain.DictValue;

import java.util.List;
import java.util.Map;

public interface DictService {
    Map<String, List<DictValue>> getAll();
}
