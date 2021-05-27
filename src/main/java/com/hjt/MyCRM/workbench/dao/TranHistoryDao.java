package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryDao {

    int save(TranHistory tranHistory);

    List<TranHistory> getByTranId(String tranId);
}
