package com.hjt.MyCRM.settings.service.impl;

import com.hjt.MyCRM.exception.LoginException;
import com.hjt.MyCRM.settings.dao.UserDao;
import com.hjt.MyCRM.settings.domain.User;
import com.hjt.MyCRM.settings.service.UserService;
import com.hjt.MyCRM.utils.DateTimeUtil;
import com.hjt.MyCRM.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.Map;

public class UserServiceImpl implements UserService {
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    @Override
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        Map<String,String> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userDao.login(map);
        if(user==null){
            throw new LoginException("用户名或密码错误");
        }
        //判断账号是否失效
        if(user.getExpireTime().compareTo(DateTimeUtil.getSysTime())<0){
            throw new LoginException("账号已失效，请联系管理员");
        }
        String allowIps = user.getAllowIps();
        if(allowIps!=null && !allowIps.equals("")){
            //判断ip是否允许
            if(!allowIps.contains(ip)){
                throw new LoginException("ip受限，不允许访问");
            }
        }
        //判断账号是否锁定
        if("0".equals(user.getLockState())){
            throw new LoginException("账号已锁定，请联系管理员");
        }
        return user;
    }
}
