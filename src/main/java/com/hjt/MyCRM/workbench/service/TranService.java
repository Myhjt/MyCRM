package com.hjt.MyCRM.workbench.service;

import com.hjt.MyCRM.exception.TranModifyException;
import com.hjt.MyCRM.exception.TranSaveException;
import com.hjt.MyCRM.vo.PaginationVo;
import com.hjt.MyCRM.workbench.domain.Activity;
import com.hjt.MyCRM.workbench.domain.Contacts;
import com.hjt.MyCRM.workbench.domain.Tran;
import com.hjt.MyCRM.workbench.domain.TranHistory;

import java.util.List;
import java.util.Map;

public interface TranService {
    List<Activity> getActivityListByActivityName(String activityName);

    List<Contacts> getContactsListByContactsName(String contactsName);

    boolean save(Tran tran,String customerName) throws TranSaveException;

    PaginationVo<Tran> pageList(Map<String,Object> map);

    Tran detail(String id);

    List<TranHistory> getHistoryList(String id);

    boolean changeStage(Tran tran) throws TranModifyException;
}
