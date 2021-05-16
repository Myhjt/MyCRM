package com.hjt.MyCRM.settings.dao;

import com.hjt.MyCRM.settings.domain.User;

import java.util.Map;

public interface UserDao {
    User login(Map<String,String> map);
}
