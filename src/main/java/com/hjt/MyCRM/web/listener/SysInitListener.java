package com.hjt.MyCRM.web.listener;

import com.hjt.MyCRM.utils.ServiceFactory;
import com.hjt.MyCRM.workbench.domain.DictValue;
import com.hjt.MyCRM.workbench.service.DictService;
import com.hjt.MyCRM.workbench.service.impl.DictServiceImpl;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class SysInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent event) {
        //event参数能够取得监听的对象
        ServletContext application = event.getServletContext();
        DictService dictService = (DictService) ServiceFactory.getService(new DictServiceImpl());
        Map<String, List<DictValue>> map = dictService.getAll();
        Set<String> keySet = map.keySet();
        for(String key:keySet){
            application.setAttribute(key,map.get(key));
        }
    }
}
