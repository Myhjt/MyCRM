package com.hjt.MyCRM.workbench.service.impl;

import com.hjt.MyCRM.exception.ActivitySaveException;
import com.hjt.MyCRM.utils.SqlSessionUtil;
import com.hjt.MyCRM.vo.PaginationVo;
import com.hjt.MyCRM.workbench.dao.ActivityDao;
import com.hjt.MyCRM.workbench.domain.Activity;
import com.hjt.MyCRM.workbench.service.ActivityService;

import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao dao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);

    @Override
    public List<Activity> get() {
        List<Activity> activityList = dao.get();
        return activityList;
    }

    @Override
    public boolean save(Activity activity) throws ActivitySaveException {
        int num =  dao.save(activity);
        if(num==1){
            return true;
        }
        else{
            throw new ActivitySaveException("活动添加失败");
        }
    }

    @Override
    public PaginationVo<Activity> getPaginationVo(Map<String, Object> map) {
        PaginationVo<Activity> data = new PaginationVo<Activity>();
        data.setTotal(dao.getTotalByCondition(map));
        data.setDataList(dao.getActivityListByCondition(map));
        return data;
    }
}
