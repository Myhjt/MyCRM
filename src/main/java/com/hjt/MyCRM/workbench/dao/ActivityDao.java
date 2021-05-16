package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.Activity;

import java.util.List;

public interface ActivityDao {
    List<Activity> get();

    int save(Activity activity);
}
