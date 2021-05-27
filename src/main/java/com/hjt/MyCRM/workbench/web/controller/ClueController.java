package com.hjt.MyCRM.workbench.web.controller;

import com.hjt.MyCRM.exception.*;
import com.hjt.MyCRM.settings.domain.User;
import com.hjt.MyCRM.settings.service.UserService;
import com.hjt.MyCRM.settings.service.impl.UserServiceImpl;
import com.hjt.MyCRM.utils.DateTimeUtil;
import com.hjt.MyCRM.utils.PrintJson;
import com.hjt.MyCRM.utils.ServiceFactory;
import com.hjt.MyCRM.utils.UUIDUtil;
import com.hjt.MyCRM.vo.PaginationVo;
import com.hjt.MyCRM.workbench.domain.Activity;
import com.hjt.MyCRM.workbench.domain.Clue;
import com.hjt.MyCRM.workbench.domain.Tran;
import com.hjt.MyCRM.workbench.service.ClueService;
import com.hjt.MyCRM.workbench.service.impl.ClueServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

public class ClueController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if("/workbench/clue/getUserList.do".equals(path)){
            getUserList(request,response);
        }
        else if("/workbench/clue/save.do".equals(path)){
            save(request,response);
        }
        else if("/workbench/clue/pageList.do".equals(path)){
            pageList(request,response);
        }
        else if("/workbench/clue/detail.do".equals(path)){
            detail(request,response);
        }
        else if("/workbench/clue/get.do".equals(path)){
            get(request,response);
        }
        else if("/workbench/clue/modify.do".equals(path)){
            modify(request,response);
        }
        else if("/workbench/clue/getActivityListByClueId.do".equals(path)){
            getActivityListByRelationId(request,response);
        }
        else if("/workbench/clue/getActivityListByActivityName.do".equals(path)){
            getActivityListByActivityName(request,response);
        }
        else if("/workbench/clue/unbound.do".equals(path)){
            unbound(request,response);
        }
        else if("/workbench/clue/bound.do".equals(path)){
            bound(request,response);
        }
        else if("/workbench/clue/getActivityListByActivityNameNotClueId.do".equals(path)){
            getActivityListByActivityNameNotClueId(request,response);
        }
        else if("/workbench/clue/convert.do".equals(path)){
            convert(request,response);
        }
    }

    private void convert(HttpServletRequest request, HttpServletResponse response) throws IOException {
        /*
        * clueId
        * createTranFlag
        * tranMoney
        * tranName
        * tranExpectedClosingDate
        * tranStage
        * tranActivityId
        * */

        String tranFlag = request.getParameter("createTranFlag");
        String clueId = request.getParameter("clueId");
        String createBy = ((User)request.getSession().getAttribute("user")).getId();
        Tran t = null;
        //要创建交易
        if("true".equals(tranFlag)){
            String money = request.getParameter("tranMoney");
            String activityId = request.getParameter("activityId");
            String tranName = request.getParameter("tranName");
            String tranExceptedClosingDate = request.getParameter("tranExpectedClosingDate");
            String tranStage = request.getParameter("tranStage");
            t = new Tran();
            t.setId(UUIDUtil.getUUID());
            t.setMoney(money);
            t.setName(tranName);
            t.setExpectedDate(tranExceptedClosingDate);
            t.setStage(tranStage);
            t.setCreateBy(createBy);
            t.setCreateTime(DateTimeUtil.getSysTime());
            t.setActivityId(activityId);
        }
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        try {
            boolean flag = clueService.convert(clueId,t,createBy);
            if(flag){
                response.sendRedirect(request.getContextPath()+"/workbench/clue/index.jsp");
            }
        } catch (ClueConvertException e) {
            e.getMessage();

        }
    }

    private void getActivityListByActivityName(HttpServletRequest request, HttpServletResponse response) {
        String activityName = request.getParameter("activityName");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<Activity> activityList  = clueService.getActivityListByActivityName(activityName);
        PrintJson.printJsonObj(response, activityList);
    }

    private void bound(HttpServletRequest request, HttpServletResponse response) {
        List<Map<String,String>> datas = new ArrayList<>();
        String[] activityIds = request.getParameterValues("activityIds");
        String clueId = request.getParameter("clueId");
        for(int i =0;i<activityIds.length;i++){
            Map<String,String> map = new HashMap<>();
            map.put("activityId",activityIds[i]);
            map.put("id",UUIDUtil.getUUID());
            map.put("clueId",clueId);
            datas.add(map);
        }
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        try {
            boolean flag = clueService.bound(datas);
            PrintJson.printJsonFlag(response,flag);
        } catch (ClueActivityRelationBoundException e) {
            Map<String,Object> temp = new HashMap<>();
            temp.put("code",-1);
            temp.put("msg",e.getMessage());
            PrintJson.printJsonObj(response,temp);
        }
    }

    private void getActivityListByActivityNameNotClueId(HttpServletRequest request, HttpServletResponse response) {

        //clueId activityName
        //{[{'id':,'name':,'startDate':,'endDate':,'owner':}],[],[]}
        String clueId = request.getParameter("clueId");
        String activityName = request.getParameter("activityName");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<Activity> activityList = clueService.getActivityListByActivityNameNotClueId(activityName,clueId);
        PrintJson.printJsonObj(response,activityList);
    }

    private void unbound(HttpServletRequest request, HttpServletResponse response) {
        String relationId = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        try {
            boolean flag = clueService.unbound(relationId);
            PrintJson.printJsonFlag(response,flag);
        } catch (ClueActivityRelationUnboundException e) {
            Map<String,Object> map = new HashMap<>();
            map.put("msg",e.getMessage());
            map.put("code",-1);
            PrintJson.printJsonObj(response,map);
        }
    }

    private void getActivityListByRelationId(HttpServletRequest request, HttpServletResponse response) {
        String clueId = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        List<Activity> activityList = clueService.getActivityListByClueId(clueId);
        PrintJson.printJsonObj(response,activityList);
    }

    private void modify(HttpServletRequest request, HttpServletResponse response){
        String id = request.getParameter("id");
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String editBy = request.getParameter("editBy");
        String editTime = DateTimeUtil.getSysTime();
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");

        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job );
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setSource(source);
        clue.setState(state);
        clue.setEditBy(editBy);
        clue.setEditTime(editTime);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        System.out.println("modify");
        try {
            boolean flag = clueService.modify(clue);
            PrintJson.printJsonFlag(response,flag);
        } catch (ClueModifyException e) {
            Map<String,Object> map = new HashMap<>();
            map.put("code",-1);
            map.put("msg",e.getMessage());
            PrintJson.printJsonObj(response,map);
        }
    }

    private void get(HttpServletRequest request, HttpServletResponse response) {
        String clueId  = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = clueService.getByIdForModify(clueId);
        PrintJson.printJsonObj(response,clue);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String clueId  = request.getParameter("id");
        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        Clue clue = clueService.getByIdForDetail(clueId);
        request.setAttribute("clue",clue);
        request.getRequestDispatcher("/workbench/clue/detail.jsp").forward(request,response);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        /*
         * data:{"total":,"dataList":[{'id':,'fullname':,appellation:';,'company':'','mphone':'',
         * 		'phone':'','source':'','owner';'','state':''}],
         * 		[]
         * }
         *
         * "pageNo,"pageSize","fullname","company","mphone","source","owner":,"phone","state"
         * */
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        String fullname = request.getParameter("fullname");
        String company = request.getParameter("company");
        String mphone =request.getParameter("mphone");
        String source = request.getParameter("source");
        String owner = request.getParameter("owner");
        String phone = request.getParameter("phone");
        String state = request.getParameter("state");
        Integer pageSize = Integer.valueOf(pageSizeStr);
        Integer pageNo  = Integer.valueOf(pageNoStr);
        Integer pageStart = ((pageNo-1)*pageSize);
        Map<String,Object> map = new HashMap<>();
        map.put("pageStart",pageStart);
        map.put("pageSize",pageSize);
        map.put("fullname",fullname);
        map.put("company",company);
        map.put("mphone",mphone);
        map.put("source",source);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("state",state);
        ClueService clueService = (ClueService)ServiceFactory.getService(new ClueServiceImpl());
        PaginationVo<Clue> clueList = clueService.getPagination(map);
        PrintJson.printJsonObj(response,clueList);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        String id = UUIDUtil.getUUID();
        String createTime = DateTimeUtil.getSysTime();
        String fullname = request.getParameter("fullname");
        String appellation = request.getParameter("appellation");
        String owner = request.getParameter("owner");
        String company = request.getParameter("company");
        String job = request.getParameter("job");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String website = request.getParameter("website");
        String mphone = request.getParameter("mphone");
        String state = request.getParameter("state");
        String source = request.getParameter("source");
        String createBy = request.getParameter("createBy");
        String description = request.getParameter("description");
        String contactSummary = request.getParameter("contactSummary");
        String nextContactTime = request.getParameter("nextContactTime");
        String address = request.getParameter("address");

        Clue clue = new Clue();
        clue.setId(id);
        clue.setFullname(fullname);
        clue.setAppellation(appellation);
        clue.setOwner(owner);
        clue.setCompany(company);
        clue.setJob(job );
        clue.setEmail(email);
        clue.setPhone(phone);
        clue.setWebsite(website);
        clue.setMphone(mphone);
        clue.setSource(source);
        clue.setState(state);
        clue.setCreateBy(createBy);
        clue.setCreateTime(createTime);
        clue.setDescription(description);
        clue.setContactSummary(contactSummary);
        clue.setNextContactTime(nextContactTime);
        clue.setAddress(address);

        ClueService clueService = (ClueService) ServiceFactory.getService(new ClueServiceImpl());
        try {
            boolean flag = clueService.save(clue);
            PrintJson.printJsonFlag(response,flag);
        } catch (ClueSaveException e) {
            String message = e.getMessage();
            Map<String,Object> map = new HashMap<>();
            map.put("code",-1);map.put("msg",message);
            PrintJson.printJsonObj(response,map);
        }

    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        UserService service = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> users= service.getUserList();
        PrintJson.printJsonObj(response,users);
    }
}
