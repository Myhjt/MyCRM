package com.hjt.MyCRM.workbench.service.impl;

import com.hjt.MyCRM.exception.ActivityDeleteException;
import com.hjt.MyCRM.exception.ActivityRemarkDeleteException;
import com.hjt.MyCRM.exception.ActivitySaveException;
import com.hjt.MyCRM.utils.SqlSessionUtil;
import com.hjt.MyCRM.vo.PaginationVo;
import com.hjt.MyCRM.workbench.dao.ActivityDao;
import com.hjt.MyCRM.workbench.dao.ActivityRemarkDao;
import com.hjt.MyCRM.workbench.domain.Activity;
import com.hjt.MyCRM.workbench.service.ActivityService;

import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao remarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    @Override
    public List<Activity> get() {
        List<Activity> activityList = activityDao.get();
        return activityList;
    }

    @Override
    public boolean save(Activity activity) throws ActivitySaveException {
        int num =  activityDao.save(activity);
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
        data.setTotal(activityDao.getTotalByCondition(map));
        data.setDataList(activityDao.getActivityListByCondition(map));
        return data;
    }

    @Override
    public boolean delete(String[] ids) throws ActivityDeleteException,ActivityRemarkDeleteException{
        int count_1 = 0,count_2 = 0,count_3;
        //查询出需要删除的备注的数量
        count_1 = remarkDao.selectCountByAids(ids);
        //删除备注，返回实际删除备注的数量
        count_2 = remarkDao.deleteRemarkByAids(ids);

        if(count_1!=count_2){
            throw new ActivityRemarkDeleteException("删除失败，原因:活动备注删除失败");
        }
        else{
            //删除市场活动
            count_3 = activityDao.deleteByIds(ids);
            if(count_3!=ids.length){
                throw new ActivityDeleteException("删除失败，原因：活动删除失败");
            }
        }
        return true;
    }
}
