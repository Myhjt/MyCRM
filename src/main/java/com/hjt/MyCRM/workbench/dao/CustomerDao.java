package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.Customer;

public interface CustomerDao {
    Customer getByName(String companyName);

    int save(Customer customer);
}
