package com.hjt.MyCRM.workbench.dao;

import com.hjt.MyCRM.workbench.domain.ClueActivityRelation;

import java.util.List;
import java.util.Map;

public interface ClueActivityRelationDao {
    int unbound(String relationId);

    int bound(List<Map<String, String>> map);

    List<ClueActivityRelation> getListByClueId(String clueId);

    int deleteByClueId(String clueId);
}
