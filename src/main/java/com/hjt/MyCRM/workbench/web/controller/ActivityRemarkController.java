package com.hjt.MyCRM.workbench.web.controller;

import com.hjt.MyCRM.exception.ActivityRemarkDeleteException;
import com.hjt.MyCRM.exception.ActivityRemarkSaveException;
import com.hjt.MyCRM.settings.domain.User;
import com.hjt.MyCRM.utils.DateTimeUtil;
import com.hjt.MyCRM.utils.PrintJson;
import com.hjt.MyCRM.utils.ServiceFactory;
import com.hjt.MyCRM.utils.UUIDUtil;
import com.hjt.MyCRM.workbench.domain.ActivityRemark;
import com.hjt.MyCRM.workbench.service.ActivityRemarkService;
import com.hjt.MyCRM.workbench.service.ActivityService;
import com.hjt.MyCRM.workbench.service.impl.ActivityRemarkServiceImpl;
import com.hjt.MyCRM.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityRemarkController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if("/workbench/activityRemark/getRemarkList.do".equals(path)){
            getRemarkList(request,response);
        }
        else if("/workbench/activityRemark/save.do".equals(path)){
            save(request,response);
        }
        else if("/workbench/activityRemark/delete.do".equals(path)){
            delete(request,response);
        }
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        String activityId = request.getParameter("remarkId");
        ActivityRemarkService remarkService = (ActivityRemarkService) ServiceFactory.getService(new ActivityRemarkServiceImpl());
        try {
            boolean flag = remarkService.delete(activityId);
            PrintJson.printJsonFlag(response,flag);
        } catch (ActivityRemarkDeleteException e) {
            String msg = e.getMessage();
            Map<String,Object> map = new HashMap<>();
            map.put("code",-1);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        ActivityRemarkService remarkService = (ActivityRemarkService) ServiceFactory.getService(new ActivityRemarkServiceImpl());
        /*id
        noteContent
        createTime
        createBy
        editTime
        editBy
        editFlag
        activityId
        */
        String uuid = UUIDUtil.getUUID();
        String noteContent = request.getParameter("noteContent");
        String createTime = DateTimeUtil.getSysTime();
        String createBy   = ((User)request.getSession().getAttribute("user")).getId();
        String activityId = request.getParameter("activityId");
        String editFlag  = "0";//没有修改过
        ActivityRemark remark = new ActivityRemark();
        remark.setId(uuid);
        remark.setCreateTime(createTime);
        remark.setActivityId(activityId);
        remark.setCreateBy(createBy);
        remark.setNoteContent(noteContent);
        remark.setEditFlag(editFlag);
        try{
            boolean flag = remarkService.save(remark);
            PrintJson.printJsonFlag(response,flag);
        }
        catch (ActivityRemarkSaveException e) {
            String msg  = e.getMessage();
            Map<String,Object>  map = new HashMap<>();
            map.put("code",-1);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }
    }

    //获取活动备注
    private void getRemarkList(HttpServletRequest request, HttpServletResponse response) {
        /*
        * {
	        "remarkList":[
		        {'id':'','noteContent':'','createTime':'','createBy':'','editTime':'','editBy':'','activityId':'','editFlag'}
	        ]
           }
        * */
        String activityId = request.getParameter("activityId");
        ActivityRemarkService remarkService = (ActivityRemarkService) ServiceFactory.getService(new ActivityRemarkServiceImpl());
        List<ActivityRemark> remarkList = remarkService.getRemarkList(activityId);
        PrintJson.printJsonObj(response,remarkList);
    }
}
