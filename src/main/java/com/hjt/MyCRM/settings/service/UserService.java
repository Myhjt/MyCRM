package com.hjt.MyCRM.settings.service;

import com.hjt.MyCRM.exception.LoginException;
import com.hjt.MyCRM.settings.dao.UserDao;
import com.hjt.MyCRM.settings.domain.User;
import com.hjt.MyCRM.workbench.domain.Activity;

import java.util.List;

public interface UserService{
    public User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUserList();
}
