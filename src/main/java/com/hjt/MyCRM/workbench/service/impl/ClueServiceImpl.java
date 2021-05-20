package com.hjt.MyCRM.workbench.service.impl;

import com.hjt.MyCRM.utils.SqlSessionUtil;
import com.hjt.MyCRM.workbench.dao.ClueDao;
import com.hjt.MyCRM.workbench.service.ClueService;

public class ClueServiceImpl implements ClueService {

    private ClueDao clueDao = (ClueDao) SqlSessionUtil.getSqlSession().getMapper(ClueDao.class);
}
