package com.hjt.MyCRM.workbench.web.controller;

import com.hjt.MyCRM.exception.TranModifyException;
import com.hjt.MyCRM.exception.TranSaveException;
import com.hjt.MyCRM.settings.domain.User;
import com.hjt.MyCRM.settings.service.UserService;
import com.hjt.MyCRM.settings.service.impl.UserServiceImpl;
import com.hjt.MyCRM.utils.DateTimeUtil;
import com.hjt.MyCRM.utils.PrintJson;
import com.hjt.MyCRM.utils.ServiceFactory;
import com.hjt.MyCRM.utils.UUIDUtil;
import com.hjt.MyCRM.vo.PaginationVo;
import com.hjt.MyCRM.vo.TranStageVo;
import com.hjt.MyCRM.workbench.domain.Activity;
import com.hjt.MyCRM.workbench.domain.Contacts;
import com.hjt.MyCRM.workbench.domain.Tran;
import com.hjt.MyCRM.workbench.domain.TranHistory;
import com.hjt.MyCRM.workbench.service.ClueService;
import com.hjt.MyCRM.workbench.service.CustomerService;
import com.hjt.MyCRM.workbench.service.TranService;
import com.hjt.MyCRM.workbench.service.impl.ClueServiceImpl;
import com.hjt.MyCRM.workbench.service.impl.CustomerServiceImpl;
import com.hjt.MyCRM.workbench.service.impl.TranServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TranController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if("/workbench/transaction/add.do".equals(path)){
            add(request,response);
        }
        else if("/workbench/transaction/getCustomerNames.do".equals(path)){
            getCustomerNames(request,response);
        }
        else if("/workbench/transaction/getActivityListByActivityName.do".equals(path)){
            getActivityListByActivityName(request,response);
        }
        else if("/workbench/transaction/getContactsListByContactsName.do".equals(path)){
            getContactsListByContactsName(request,response);
        }
        else if("/workbench/transaction/save.do".equals(path)){
            save(request,response);
        }
        else if("/workbench/transaction/pageList.do".equals(path)){
            pageList(request,response);
        }
        else if("/workbench/transaction/detail.do".equals(path)){
            detail(request,response);
        }
        else if("/workbench/transaction/getHistoryList.do".equals(path)){
            getHistoryList(request,response);
        }
        else if("/workbench/transaction/changeStage.do".equals(path)){
            changeStage(request,response);
        }
        else if("/workbench/transaction/getTranStageCounts.do".equals(path)){
            getTranStageCounts(request,response);
        }
    }

    private void getTranStageCounts(HttpServletRequest request, HttpServletResponse response) {
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranStageVo> maps = tranService.getTranStageCounts();
        PrintJson.printJsonObj(response,maps);
    }

    private void changeStage(HttpServletRequest request, HttpServletResponse response) {
        /*
        * {"tranId":"${tran.id}","stage":stage,"money":"","expectedDate":""}
        * */
        String tranId = request.getParameter("tranId");
        String stage = request.getParameter("stage");
        String money = request.getParameter("money");
        String expectedDate = request.getParameter("expectedDate");
        String editBy = ((User)request.getSession().getAttribute("user")).getName();
        String editTime = DateTimeUtil.getSysTime();
        Tran tran = new Tran();
        tran.setId(tranId);
        tran.setStage(stage);
        tran.setEditBy(editBy);
        tran.setEditTime(editTime);
        tran.setMoney(money);
        tran.setExpectedDate(expectedDate);
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Map<String,Object> map = new HashMap<>();
        try {
            tranService.changeStage(tran);
            String possibility = ((Map<String,String>)request.getServletContext().getAttribute("pMap")).get(stage);
            map.put("code",0);
            map.put("tran",tran);
            map.put("possibility",possibility);
        } catch (TranModifyException e) {
            map.put("code",-1);
            map.put("msg",e.getMessage());
        }
        PrintJson.printJsonObj(response,map);
    }
    private void getHistoryList(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        Map<String,String> map = (Map<String,String>)request.getServletContext().getAttribute("pMap");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<TranHistory> historyList  = tranService.getHistoryList(id);
        for(int i =0;i<historyList.size();i++){
            String stage = historyList.get(i).getStage();
            historyList.get(i).setPossibility(map.get(stage));
        }
        PrintJson.printJsonObj(response,historyList);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        System.out.println(request.getContextPath());
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        Tran tran = tranService.detail(id);
        request.setAttribute("tran",tran);
        request.getRequestDispatcher("/workbench/transaction/detail.jsp").forward(request,response);
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        /*
        *  返回的参数：
            data:{"total":,"dataList":[{'id':,'name':,customer:';,'stage':'','type':'',
		    'owner':'','source':'','contacts';''}],
		    []
        *  接收的参数#search-owner").v
            name
            customer
            stage
            source
            type
            contacts
        *
        * */
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");
        Integer pageSize = Integer.valueOf(pageSizeStr);
        Integer pageStart = (Integer.valueOf(pageNoStr)-1)*pageSize;
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String customer = request.getParameter("customer");
        String stage = request.getParameter("stage");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String contacts = request.getParameter("contacts");
        Map<String,Object> map = new HashMap<>();
        map.put("pageStart",pageStart);
        map.put("pageSize",pageSize);
        map.put("owner",owner);
        map.put("name",name);
        map.put("customer",customer);
        map.put("stage",stage);
        map.put("type",type);
        map.put("source",source);
        map.put("contacts",contacts);
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        PaginationVo<Tran> tranList = tranService.pageList(map);
        PrintJson.printJsonObj(response,tranList);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        String transactionOwner = request.getParameter("transactionOwner");
        String transactionMoney = request.getParameter("transactionMoney");
        String transactionName = request.getParameter("transactionName");
        String transactionExpectedDate = request.getParameter("transactionExpectedDate");
        String transactionStage = request.getParameter("transactionStage");
        String transactionType = request.getParameter("transactionType");
        String transactionSource = request.getParameter("transactionSource");
        String transactionActivityId = request.getParameter("transactionActivityId");
        String transactionContactsId = request.getParameter("transactionContactsId");
        String transactionDescription = request.getParameter("transactionDescription");
        String transactionContactsSummary = request.getParameter("transactionContactsSummary");
        String customerName = request.getParameter("customerName");
        String nextContactTime = request.getParameter("nextContactTime");

        Tran tran = new Tran();
        tran.setType(transactionType);
        tran.setNextContactTime(nextContactTime);
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateBy(((User)request.getSession()    .getAttribute("user")).getId());
        tran.setCreateTime(DateTimeUtil.getSysTime());
        tran.setMoney(transactionMoney);
        tran.setName(transactionName);
        tran.setExpectedDate(transactionExpectedDate);
        tran.setStage(transactionStage);
        tran.setActivityId(transactionActivityId);
        tran.setSource(transactionSource);
        tran.setOwner(transactionOwner);
        tran.setDescription(transactionDescription);
        tran.setContactSummary(transactionContactsSummary);
        tran.setContactsId(transactionContactsId);
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        try {
            boolean flag = tranService.save(tran,customerName);
            PrintJson.printJsonFlag(response,flag);
        } catch (TranSaveException e) {
            String message = e.getMessage();
            Map<String,Object> map = new HashMap<>();
            map.put("code",-1);
            map.put("msg",message);
            PrintJson.printJsonObj(response,map);
        }

    }

    private void getContactsListByContactsName(HttpServletRequest request, HttpServletResponse response) {
        String contactsName = request.getParameter("contactsName");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<Contacts>contactsList =  tranService.getContactsListByContactsName(contactsName);
        PrintJson.printJsonObj(response,contactsList);
    }

    private void getActivityListByActivityName(HttpServletRequest request, HttpServletResponse response) {
        //activityName
        //{[{'id':,'name':,'startDate':,'endDate':,'owner':}],[],[]}
        String activityName = request.getParameter("activityName");
        TranService tranService = (TranService) ServiceFactory.getService(new TranServiceImpl());
        List<Activity> activityList = tranService.getActivityListByActivityName(activityName);
        PrintJson.printJsonObj(response,activityList);
    }

    private void getCustomerNames(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("name");
        CustomerService customerService = (CustomerService)ServiceFactory.getService(new CustomerServiceImpl());
        List<String> nameList  = customerService.getCustomerNames(name);
        PrintJson.printJsonObj(response,nameList);
    }

    private void add(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> userList = userService.getUserList();
        request.setAttribute("userList",userList);
        request.getRequestDispatcher("/workbench/transaction/save.jsp").forward(request,response);
    }
}
