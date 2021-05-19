package com.hjt.MyCRM.workbench.service;

import com.hjt.MyCRM.exception.ActivityRemarkDeleteException;
import com.hjt.MyCRM.exception.ActivityRemarkModifyException;
import com.hjt.MyCRM.exception.ActivityRemarkSaveException;
import com.hjt.MyCRM.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    List<ActivityRemark> getRemarkList(String activityId);

    boolean save(ActivityRemark remark) throws ActivityRemarkSaveException;

    boolean delete(String activityId) throws ActivityRemarkDeleteException;

    boolean modify(ActivityRemark remark) throws ActivityRemarkModifyException;
}
