package com.basic.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.basic.model.User;
import com.basic.utils.PageInfo;
import com.basic.utils.UserVo;

public interface UserMapper {
    /**
     * 删除用户
     *
     * @param id
     * @return
     */
    int deleteById(Long id) throws Exception;

    /**
     * 添加用户
     *
     * @param user
     * @return
     */
    int insert(User user) throws Exception;

    /**
     * 修改用户
     *
     * @param user
     * @return
     */
    int updateUser(User user) throws Exception;

    /**
     * 根据用户名查询用户
     *
     * @param username
     * @return
     */
    User findUserByLoginName(String username) throws Exception;

    /**
     * 根据用户id查询用户
     *
     * @param id
     * @return
     */
    User findUserById(Long id) throws Exception;

    /**
     * 用户列表
     *
     * @param pageInfo
     * @return
     */
    List findUserPageCondition(PageInfo pageInfo) throws Exception;

    /**
     * 统计用户
     *
     * @param pageInfo
     * @return
     */
    int findUserPageCount(PageInfo pageInfo) throws Exception;

    /**
     * 修改用户密码
     *
     * @param userId
     * @param pwd
     */
    void updateUserPwdById(@Param("userId") Long userId, @Param("pwd") String pwd) throws Exception;

    /**
     * 根据用户id查询用户带部门
     *
     * @param id
     * @return
     */
    UserVo findUserVoById(Long id) throws Exception;

    /**
     * 
     * 方法描述 : 获取主键
     * @return
     */
	String getUserId() throws Exception;
}