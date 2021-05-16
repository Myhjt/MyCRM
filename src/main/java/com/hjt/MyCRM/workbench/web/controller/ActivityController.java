package com.hjt.MyCRM.workbench.web.controller;

import com.hjt.MyCRM.exception.ActivitySaveException;
import com.hjt.MyCRM.settings.domain.User;
import com.hjt.MyCRM.settings.service.UserService;
import com.hjt.MyCRM.settings.service.impl.UserServiceImpl;
import com.hjt.MyCRM.utils.DateTimeUtil;
import com.hjt.MyCRM.utils.PrintJson;
import com.hjt.MyCRM.utils.ServiceFactory;
import com.hjt.MyCRM.utils.UUIDUtil;
import com.hjt.MyCRM.workbench.domain.Activity;
import com.hjt.MyCRM.workbench.service.ActivityService;
import com.hjt.MyCRM.workbench.service.impl.ActivityServiceImpl;
import com.mysql.cj.util.TimeUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.Provider;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;


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
        else if("/workbench/activity/save.do".equals(path)){
            saveActivity(request,response);
        }
        else if("/workbench/activity/xxx.do".equals(path)){

        }
    }

    //添加活动
    private void saveActivity(HttpServletRequest request, HttpServletResponse response) {
        /*
            id
            owner;
            name;
            startDate;
            endDate;
            cost;
            description;
            createTime;
            createBy;
            editTime;
            editBy;
       */
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("user")).getName();

        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setCost(cost);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);
        activity.setDescription(description);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        try{
            boolean flag = activityService.save(activity);
            PrintJson.printJsonFlag(response,flag);
        }
        catch (ActivitySaveException e){
           String msg =  e.getMessage();
           Map<String,Object> map = new HashMap<>();
           map.put("code",-1);
           map.put("msg",msg);
           PrintJson.printJsonObj(response,map);
        }
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService service = (UserService) ServiceFactory.getService(new UserServiceImpl());

        List<User> users= service.getUserList();
        PrintJson.printJsonObj(response,users);
    }
}
