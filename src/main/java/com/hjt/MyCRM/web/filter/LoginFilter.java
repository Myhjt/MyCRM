package com.hjt.MyCRM.web.filter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class LoginFilter extends HttpFilter {
    @Override
    protected void doFilter(HttpServletRequest req, HttpServletResponse res, FilterChain chain) throws IOException, ServletException {
        Object user = req.getSession().getAttribute("user");
        String uri = req.getServletPath();
        if("/login.jsp".equals(uri) || "/settings/user/login.do".equals(uri)){
            chain.doFilter(req,res);
        }else{
            if(user!=null){
                chain.doFilter(req,res);
            }
            else{
                /*
                 * 关于转发和重定向的路径问题：
                 *       转发使用的是【内部路径】，/代表的就是项目根路径
                 *           /login.jsp
                 *       重定向使用的是【传统路径】，前面必须以/项目名开头
                 *           /MyCRM/login.jsp
                 * */
                res.sendRedirect(req.getContextPath()+"/login.jsp");
            }
        }
    }
}
