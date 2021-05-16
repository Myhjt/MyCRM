package com.hjt.MyCRM.workbench.service;

import com.hjt.MyCRM.exception.ActivitySaveException;
import com.hjt.MyCRM.workbench.domain.Activity;

import java.util.List;

public interface ActivityService {
    List<Activity> get();
    boolean save(Activity activity) throws ActivitySaveException;
}
