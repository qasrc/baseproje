package com.basic.service.impl;

import com.basic.annotation.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.basic.mapper.SysLogMapper;
import com.basic.model.SysLog;
import com.basic.service.LogService;
import com.basic.utils.PageInfo;

import java.util.UUID;

/**
 * 系统日志
 */
@Service
public class LogServiceImpl implements LogService {
    @Autowired
    private SysLogMapper sysLogMapper;

    @Override
    @DataSource(name = "gzz")
    public void insertLog(SysLog sysLog) {
        try
        {
            sysLog.setId(UUID.randomUUID().toString());
            sysLogMapper.insert(sysLog);
        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    @Override
    @DataSource(name = "gzz")
    public void findDataGrid(PageInfo pageInfo) {
        try
        {
            pageInfo.setRows(sysLogMapper.findDataGrid(pageInfo));
            pageInfo.setTotal(sysLogMapper.findDataGridCount(pageInfo));
        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}
