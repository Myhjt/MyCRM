package com.hjt.MyCRM.workbench.web.controller;

import com.hjt.MyCRM.settings.domain.User;
import com.hjt.MyCRM.settings.service.UserService;
import com.hjt.MyCRM.settings.service.impl.UserServiceImpl;
import com.hjt.MyCRM.utils.PrintJson;
import com.hjt.MyCRM.utils.ServiceFactory;
import com.hjt.MyCRM.workbench.domain.Activity;
import com.hjt.MyCRM.workbench.service.ActivityService;
import com.hjt.MyCRM.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;


/*
* 市场活动控制器
* */
public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if("/workbench/activity/getUserList.do".equals(path)){
            getUserList(request,response);
        }
        else if("/workbench/activity/xxx".equals(path)){

        }
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService service = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> users= service.getUserList();
        PrintJson.printJsonObj(response,users);
    }
}
