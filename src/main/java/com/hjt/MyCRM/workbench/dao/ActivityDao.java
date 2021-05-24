package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    List<Activity> get();

    int save(Activity activity);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    int deleteByIds(String[] id);

    Activity getById(String id);

    int modify(Activity activity);

    Activity detail(String id);

    List<Activity> getActivityListByClueId(String clueId);

    List<Activity> getActivityListByActivityNameAndClueId(@Param("activityName") String activityName, @Param("clueId") String clueId);

    List<Activity> getActivityListByActivityName(String activityName);
}
