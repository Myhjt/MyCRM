package com.hjt.MyCRM.workbench.service;

import com.hjt.MyCRM.exception.*;
import com.hjt.MyCRM.vo.PaginationVo;
import com.hjt.MyCRM.workbench.domain.Activity;
import com.hjt.MyCRM.workbench.domain.Clue;
import com.hjt.MyCRM.workbench.domain.Tran;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue clue) throws ClueSaveException;

    PaginationVo<Clue> getPagination(Map<String, Object> map);

    Clue getByIdForDetail(String clueId);

    Clue getByIdForModify(String clueId);

    boolean modify(Clue clue) throws ClueModifyException;

    List<Activity> getActivityListByActivityNameNotClueId(String activityName, String clueId);

    List<Activity> getActivityListByClueId(String clueId);

    boolean unbound(String relationId) throws ClueActivityRelationUnboundException;

    boolean bound(List<Map<String,String>> datas) throws ClueActivityRelationBoundException;

    List<Activity> getActivityListByActivityName(String activityName);

    boolean convert(String clueId, Tran t, String createBy) throws ClueConvertException;
}
