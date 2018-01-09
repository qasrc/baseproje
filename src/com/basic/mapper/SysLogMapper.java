package com.basic.mapper;

import java.util.List;

import com.basic.model.SysLog;
import com.basic.utils.PageInfo;

public interface SysLogMapper {
    int deleteByPrimaryKey(Long id) throws Exception;

    int insert(SysLog record) throws Exception;

    int insertSelective(SysLog record) throws Exception;

    SysLog selectByPrimaryKey(Long id) throws Exception;

    int updateByPrimaryKeySelective(SysLog record) throws Exception;

    int updateByPrimaryKey(SysLog record) throws Exception;

    List findDataGrid(PageInfo pageInfo) throws Exception;

    int findDataGridCount(PageInfo pageInfo) throws Exception;
}