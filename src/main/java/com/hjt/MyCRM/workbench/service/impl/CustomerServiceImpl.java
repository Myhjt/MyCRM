package com.hjt.MyCRM.workbench.service.impl;

import com.hjt.MyCRM.utils.SqlSessionUtil;
import com.hjt.MyCRM.workbench.dao.CustomerDao;
import com.hjt.MyCRM.workbench.service.CustomerService;

import java.util.List;

public class CustomerServiceImpl implements CustomerService {
    private CustomerDao customerDao = (CustomerDao) SqlSessionUtil.getSqlSession().getMapper(CustomerDao.class);
    @Override
    public List<String> getCustomerNames(String name) {
        return customerDao.getNameListLikeName(name);
    }
}
