package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {
    int selectCountByAids(String[] ids);

    int deleteRemarkByAids(String[] ids);

    List<ActivityRemark> getById(String activityId);

    int save(ActivityRemark remark);

    int delete(String id);

    int modify(ActivityRemark remark);
}
