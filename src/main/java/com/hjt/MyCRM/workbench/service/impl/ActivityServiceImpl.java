package com.hjt.MyCRM.workbench.service.impl;

import com.hjt.MyCRM.utils.ServiceFactory;
import com.hjt.MyCRM.utils.SqlSessionUtil;
import com.hjt.MyCRM.workbench.dao.ActivityDao;
import com.hjt.MyCRM.workbench.domain.Activity;
import com.hjt.MyCRM.workbench.service.ActivityService;

import java.util.List;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao dao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);

    @Override
    public List<Activity> get() {
        List<Activity> activityList = dao.get();
        return activityList;
    }
}
