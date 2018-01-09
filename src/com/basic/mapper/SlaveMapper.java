package com.basic.mapper;

import java.util.Map;

public interface SlaveMapper {
    Integer count() throws Exception;

	Map<String, String> getValue() throws Exception;
}
