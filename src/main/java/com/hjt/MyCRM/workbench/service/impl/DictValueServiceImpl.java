package com.hjt.MyCRM.workbench.service.impl;

import com.hjt.MyCRM.utils.SqlSessionUtil;
import com.hjt.MyCRM.workbench.dao.DictValueDao;
import com.hjt.MyCRM.workbench.service.DictValueService;

public class DictValueServiceImpl implements DictValueService {

    private DictValueDao valueDao = (DictValueDao) SqlSessionUtil.getSqlSession().getMapper(DictValueDao.class);
}
