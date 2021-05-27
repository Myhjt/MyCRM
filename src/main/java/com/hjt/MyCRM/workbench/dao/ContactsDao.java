package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.Contacts;

import java.util.List;

public interface ContactsDao {
    int save(Contacts contacts);

    List<Contacts> getContactsListByContactsName(String contactsName);
}
