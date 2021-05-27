package com.hjt.MyCRM.web.listener;

import com.hjt.MyCRM.utils.ServiceFactory;
import com.hjt.MyCRM.workbench.domain.DictValue;
import com.hjt.MyCRM.workbench.service.DictService;
import com.hjt.MyCRM.workbench.service.impl.DictServiceImpl;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

public class SysInitListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent event) {
        //event参数能够取得监听的对象
        ServletContext application = event.getServletContext();

        //数据字典
        DictService dictService = (DictService) ServiceFactory.getService(new DictServiceImpl());
        Map<String, List<DictValue>> map = dictService.getAll();
        Set<String> keySet = map.keySet();
        for(String key:keySet){
            application.setAttribute(key,map.get(key));
        }

        //处理Stage2Possibility.properties
        ResourceBundle rs = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> keys = rs.getKeys();
        Map<String,String> possibilityMap = new HashMap<>();
        while (keys.hasMoreElements()){
            String key = new String(keys.nextElement().getBytes());
            possibilityMap.put(key,rs.getString(key));
        }
        application.setAttribute("pMap",possibilityMap);
    }
}
