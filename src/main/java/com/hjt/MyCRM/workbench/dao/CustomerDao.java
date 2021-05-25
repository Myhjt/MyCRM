package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.Customer;

import java.util.List;

public interface CustomerDao {
    Customer getByName(String companyName);

    int save(Customer customer);

    List<String> getNameListLikeName(String name);
}
