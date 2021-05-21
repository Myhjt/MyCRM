package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.DictValue;

import java.util.List;

public interface DictValueDao {
    List<DictValue> getAllByCode(String typeCode);
}
