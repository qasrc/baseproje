package com.basic.service;

import com.basic.model.SysLog;
import com.basic.utils.PageInfo;

/**
 * @description：操作日志
 */
public interface LogService {

    void insertLog(SysLog sysLog);

    void findDataGrid(PageInfo pageInfo);
}
