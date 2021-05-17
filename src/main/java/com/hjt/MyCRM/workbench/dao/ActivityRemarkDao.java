package com.hjt.MyCRM.workbench.dao;

public interface ActivityRemarkDao {
    int selectCountByAids(String[] ids);

    int deleteRemarkByAids(String[] ids);
}
