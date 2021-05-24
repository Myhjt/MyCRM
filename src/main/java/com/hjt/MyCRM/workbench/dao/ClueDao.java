package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    int save(Clue clue);

    Integer getTotal(Map<String,Object> map);

    List<Clue> getPageList(Map<String, Object> map);

    Clue getByIdForDetail(String clueId);

    Clue getByIdForModify(String clueId);

    int modify(Clue clue);

    Clue getById(String clueId);

    int deleteById(String id);
}
