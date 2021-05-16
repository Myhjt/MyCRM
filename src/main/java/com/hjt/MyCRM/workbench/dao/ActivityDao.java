package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    List<Activity> get();

    int save(Activity activity);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);
}
