package com.hjt.MyCRM.settings.web.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hjt.MyCRM.settings.dao.UserDao;
import com.hjt.MyCRM.settings.domain.User;
import com.hjt.MyCRM.settings.service.UserService;
import com.hjt.MyCRM.settings.service.impl.UserServiceImpl;
import com.hjt.MyCRM.utils.MD5Util;
import com.hjt.MyCRM.utils.PrintJson;
import com.hjt.MyCRM.utils.ServiceFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/settings/user/save.do".equals(path)){

        }
        else if("/settings/user/login.do".equals(path)){
            login(request,response);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        loginPwd = MD5Util.getMD5(loginPwd);
        String ip = request.getRemoteAddr();
        //以后业务层的开发，使用代理类形态的接口对象
        //使用动态代理做增强功能，比如事务的回滚
        UserService service = (UserService)ServiceFactory.getService(new UserServiceImpl());
        try{
            User user = service.login(loginAct, loginPwd, ip);
            //登录成功
            request.getSession().setAttribute("user",user);
            //为前端返回登录成功的消息
            /*{'code':'0'}*/
            PrintJson.printJsonFlag(response,true);
        }
        catch (Exception e){
            //业务层验证登录失败
            //为前端返回登录失败的消息
            /*{'code':'-1','msg':"fail"}*/
            e.printStackTrace();
            Map<String,Object> map = new HashMap<>();
            map.put("code",-1);//{'code':-1
            map.put("msg",e.getMessage());//'msg':"fail"}
            PrintJson.printJsonObj(response,map);
        }
    }
}
