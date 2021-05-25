package com.hjt.MyCRM.workbench.web.controller;

import com.hjt.MyCRM.settings.domain.User;
import com.hjt.MyCRM.settings.service.UserService;
import com.hjt.MyCRM.settings.service.impl.UserServiceImpl;
import com.hjt.MyCRM.utils.PrintJson;
import com.hjt.MyCRM.utils.ServiceFactory;
import com.hjt.MyCRM.workbench.service.CustomerService;
import com.hjt.MyCRM.workbench.service.impl.CustomerServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.ResourceBundle;

public class TranController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if("/workbench/transaction/save.do".equals(path)){
            add(request,response);
        }
        else if("/workbench/transaction/getCustomerNames.do".equals(path)){
            getCustomerNames(request,response);
        }
        else if("/workbench/transaction/.do".equals(path)){

        }
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
