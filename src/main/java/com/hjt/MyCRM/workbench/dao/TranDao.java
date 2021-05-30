package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.vo.TranStageVo;
import com.hjt.MyCRM.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface TranDao {
    int save(Tran t);

    int getTotal(Map<String,Object> map);

    List<Tran> getPageList(Map<String, Object> map);

    Tran detail(String id);

    int modifyStage(Tran tran);

    List<TranStageVo> getTranStageCounts();
}
