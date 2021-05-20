package com.hjt.MyCRM.workbench.service.impl;

import com.hjt.MyCRM.utils.SqlSessionUtil;
import com.hjt.MyCRM.workbench.dao.DictTypeDao;
import com.hjt.MyCRM.workbench.service.DictTypeService;

public class DictTypeServiceImpl implements DictTypeService {
    private DictTypeDao typeDao = (DictTypeDao) SqlSessionUtil.getSqlSession().getMapper(DictTypeDao.class);

}
