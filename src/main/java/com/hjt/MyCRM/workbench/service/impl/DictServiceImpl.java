package com.hjt.MyCRM.workbench.service.impl;

import com.hjt.MyCRM.utils.SqlSessionUtil;
import com.hjt.MyCRM.workbench.dao.DictTypeDao;
import com.hjt.MyCRM.workbench.dao.DictValueDao;
import com.hjt.MyCRM.workbench.domain.DictType;
import com.hjt.MyCRM.workbench.domain.DictValue;
import com.hjt.MyCRM.workbench.service.DictService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DictServiceImpl implements DictService {
    private DictTypeDao typeDao = (DictTypeDao) SqlSessionUtil.getSqlSession().getMapper(DictTypeDao.class);
    private DictValueDao valueDao = (DictValueDao) SqlSessionUtil.getSqlSession().getMapper(DictValueDao.class);

    @Override
    public Map<String, List<DictValue>> getAll() {
        Map<String,List<DictValue>> map = new HashMap<>();
        List<DictType> typeList = typeDao.getAll();
        for(DictType type:typeList){
            List<DictValue> valueList = valueDao.getAllByCode(type.getCode());
            map.put(type.getCode()+"List",valueList);
        }
        return map;
    }
}
