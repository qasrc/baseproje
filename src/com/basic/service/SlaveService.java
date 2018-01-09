package com.basic.service;

import java.util.Map;

/**
 * @description：主从库测试
 */
public interface SlaveService {

    Integer count();
    
    public Map<String, String> getValue();
}
