package com.basic.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.basic.annotation.DataSource;
import com.basic.mapper.SlaveMapper;
import com.basic.service.SlaveService;

@Service
public class SlaveServiceImpl implements SlaveService {

    @Autowired
    private SlaveMapper slaveMapper;

    @Override
    @DataSource(name = "db2")
    public Integer count() {
        try
        {
            return slaveMapper.count();
        } catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return null;
    }
    @Override
    @DataSource(name = "db2")
    public Map<String, String> getValue() {
    	try
        {
            return slaveMapper.getValue();
        } catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return null;
    }


}
