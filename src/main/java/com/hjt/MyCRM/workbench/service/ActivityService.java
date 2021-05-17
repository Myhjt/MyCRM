package com.hjt.MyCRM.workbench.service;

import com.hjt.MyCRM.exception.ActivityDeleteException;
import com.hjt.MyCRM.exception.ActivityRemarkDeleteException;
import com.hjt.MyCRM.exception.ActivitySaveException;
import com.hjt.MyCRM.vo.PaginationVo;
import com.hjt.MyCRM.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    List<Activity> get();
    boolean save(Activity activity) throws ActivitySaveException;
    PaginationVo<Activity> getPaginationVo(Map<String,Object> map);

    boolean delete(String[] ids) throws ActivityDeleteException, ActivityRemarkDeleteException;
}
