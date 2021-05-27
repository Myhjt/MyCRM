package com.hjt.MyCRM.workbench.service.impl;

import com.hjt.MyCRM.exception.TranModifyException;
import com.hjt.MyCRM.exception.TranSaveException;
import com.hjt.MyCRM.utils.DateTimeUtil;
import com.hjt.MyCRM.utils.SqlSessionUtil;
import com.hjt.MyCRM.utils.UUIDUtil;
import com.hjt.MyCRM.vo.PaginationVo;
import com.hjt.MyCRM.workbench.dao.*;
import com.hjt.MyCRM.workbench.domain.*;
import com.hjt.MyCRM.workbench.service.TranService;
import com.mysql.cj.conf.PropertyDefinitions;

import java.util.List;
import java.util.Map;

public  class TranServiceImpl implements TranService {
    private ActivityDao activityDao = (ActivityDao) SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ContactsDao contactsDao = (ContactsDao) SqlSessionUtil.getSqlSession().getMapper(ContactsDao.class);
    private TranDao tranDao = (TranDao) SqlSessionUtil.getSqlSession().getMapper(TranDao.class);
    private CustomerDao customerDao = (CustomerDao) SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    private TranHistoryDao tranHistoryDao = (TranHistoryDao) SqlSessionUtil.getSqlSession().getMapper(TranHistoryDao.class);

    @Override
    public List<Activity> getActivityListByActivityName(String activityName) {
       return activityDao.getActivityListByActivityName(activityName);
    }

    @Override
    public List<Contacts> getContactsListByContactsName(String contactsName) {
        return contactsDao.getContactsListByContactsName(contactsName);
    }

    @Override
    public boolean save(Tran tran,String customerName) throws TranSaveException {
        Customer customer = customerDao.getByName(customerName);
        if(customer!=null){
            tran.setCustomerId(customer.getId());
        }else{

            //创建客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(customerName);
            customer.setCreateBy(tran.getCreateBy());
            customer.setCreateTime(tran.getCreateTime());
            customer.setOwner(tran.getOwner());
            customer.setContactSummary(tran.getContactSummary());
            customer.setNextContactTime(tran.getNextContactTime());
            int flag = customerDao.save(customer);
            if(flag!=1){
                throw new TranSaveException("交易创建失败");
            }
            tran.setCustomerId(customer.getId());
        }

        //创建交易
        int flag = tranDao.save(tran);
        if(flag!=1){
            throw new TranSaveException("交易创建失败");
        }

        //创建交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setTranId(tran.getId());
        tranHistory.setCreateBy(tran.getCreateBy());
        tranHistory.setCreateTime(DateTimeUtil.getSysTime());
        tranHistory.setStage(tran.getStage());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setExpectedDate(tran.getExpectedDate());
        flag = tranHistoryDao.save(tranHistory);
        if(flag!=1){
            throw new TranSaveException("交易创建失败");
        }
        return true;
    }

    @Override
    public PaginationVo<Tran> pageList(Map<String,Object> map) {
        PaginationVo<Tran> paginationVo = new PaginationVo<>();

        paginationVo.setTotal(tranDao.getTotal(map));
        paginationVo.setDataList(tranDao.getPageList(map));

        return paginationVo;
    }

    @Override
    public Tran detail(String id) {
        return tranDao.detail(id);
    }

    @Override
    public List<TranHistory> getHistoryList(String tranId) {
        return tranHistoryDao.getByTranId(tranId);
    }

    @Override
    public boolean changeStage(Tran tran) throws TranModifyException {
        int result = 0;
        //1、改变阶段
        result = tranDao.modifyStage(tran);
        if(result!=1){
            throw new TranModifyException("阶段改变失败");
        }
        //2、创建交易历史
        TranHistory history = new TranHistory();
        history.setId(UUIDUtil.getUUID());
        history.setStage(tran.getStage());
        history.setCreateBy(tran.getEditBy());
        history.setCreateTime(tran.getEditTime());
        history.setTranId(tran.getId());
        history.setMoney(tran.getMoney());
        history.setExpectedDate(tran.getExpectedDate());
        result = tranHistoryDao.save(history);
        if(result!=1){
            throw new TranModifyException("阶段改变失败");
        }
        return true;
    }
}
