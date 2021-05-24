package com.hjt.MyCRM.workbench;

import com.hjt.MyCRM.exception.ActivitySaveException;
import com.hjt.MyCRM.utils.ServiceFactory;
import com.hjt.MyCRM.utils.UUIDUtil;
import com.hjt.MyCRM.workbench.domain.Activity;
import com.hjt.MyCRM.workbench.service.ActivityService;
import com.hjt.MyCRM.workbench.service.impl.ActivityServiceImpl;
import org.junit.Test;

public class ActivityTest {
    @Test
    public void saveTest(){
        Activity activity = new Activity();
        activity.setId(UUIDUtil.getUUID());
        activity.setName("测试");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        try {
           boolean flag =  activityService.save(activity);
            System.out.println(flag);
        } catch (ActivitySaveException e) {
            e.printStackTrace();
        }
    }
}
