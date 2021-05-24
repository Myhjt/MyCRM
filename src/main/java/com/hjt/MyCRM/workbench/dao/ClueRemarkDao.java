package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkDao {
    List<ClueRemark> getByClueId(String clueId) ;

    int deleteByClueId(String clueId);
}
