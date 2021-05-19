package com.hjt.MyCRM.workbench.service.impl;

import com.hjt.MyCRM.exception.ActivityRemarkDeleteException;
import com.hjt.MyCRM.exception.ActivityRemarkModifyException;
import com.hjt.MyCRM.exception.ActivityRemarkSaveException;
import com.hjt.MyCRM.utils.SqlSessionUtil;
import com.hjt.MyCRM.workbench.dao.ActivityDao;
import com.hjt.MyCRM.workbench.dao.ActivityRemarkDao;
import com.hjt.MyCRM.workbench.domain.ActivityRemark;
import com.hjt.MyCRM.workbench.service.ActivityRemarkService;
import org.apache.ibatis.session.SqlSession;

import java.util.List;

public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    private ActivityRemarkDao remarkDao = (ActivityRemarkDao) SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    @Override
    public List<ActivityRemark> getRemarkList(String activityId) {
        List<ActivityRemark> remarkList = remarkDao.getById(activityId);
        return remarkList;
    }

    @Override
    public boolean save(ActivityRemark remark) throws ActivityRemarkSaveException {
        System.out.println(remark.getEditFlag());
        int result = remarkDao.save(remark);
        if(result!=1){
            throw new ActivityRemarkSaveException("备注保存失败");
        }
        return true;
    }

    //删除

    @Override
    public boolean delete(String activityId) throws ActivityRemarkDeleteException {
        int result = remarkDao.delete(activityId);
        if(result!=1){
            throw new ActivityRemarkDeleteException("活动备注删除失败");
        }
        return true;
    }

    @Override
    public boolean modify(ActivityRemark remark) throws ActivityRemarkModifyException {
       int result = remarkDao.modify(remark);
       if(result!=1){
           throw new ActivityRemarkModifyException("备注修改失败");
       }
       return true;
    }
}
