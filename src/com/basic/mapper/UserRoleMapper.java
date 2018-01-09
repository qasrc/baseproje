package com.basic.mapper;

import com.basic.model.UserRole;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface UserRoleMapper {

    int insert(UserRole userRole) throws Exception;

    int updateByPrimaryKeySelective(UserRole userRole) throws Exception;

    List<UserRole> findUserRoleByUserId(Long userId) throws Exception;

    int deleteById(Long id) throws Exception;

    List<Long> findRoleIdListByUserId(Long userId) throws Exception;

    List<String> findRoleNameListByUserId(Long userId) throws Exception;


}