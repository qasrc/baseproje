package com.basic.service.impl;

import com.basic.annotation.DataSource;
import com.basic.mapper.UserMapper;
import com.basic.mapper.UserRoleMapper;
import com.basic.model.User;
import com.basic.model.UserRole;
import com.basic.service.UserService;
import com.basic.utils.PageInfo;
import com.basic.utils.UserVo;
import org.apache.commons.beanutils.PropertyUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    private static Logger LOGGER = LoggerFactory.getLogger(UserServiceImpl.class);

    @Autowired
    private UserMapper userMapper;
    @Autowired
    private UserRoleMapper userRoleMapper;

    @Override
    @DataSource(name = "gzz")
    public User findUserByLoginName(String username) {
        try
        {
            return userMapper.findUserByLoginName(username);
        } catch (Exception e)
        {
            LOGGER.error(e.toString());
        }
        return null;
    }

    @Override
    @DataSource(name = "gzz")
    public User findUserById(Long id) {
        try
        {
            return userMapper.findUserById(id);
        } catch (Exception e)
        {
            LOGGER.error(e.toString());
        }
        return null;
    }

    @Override
    @DataSource(name = "gzz")
    public void findDataGrid(PageInfo pageInfo) {
        try
        {
            pageInfo.setRows(userMapper.findUserPageCondition(pageInfo));
            pageInfo.setTotal(userMapper.findUserPageCount(pageInfo));
        } catch (Exception e)
        {
            LOGGER.error(e.toString());
        }
    }

    @Override
    @DataSource(name = "gzz")
    public void addUser(UserVo userVo) {
        User user = new User();
        try {
            PropertyUtils.copyProperties(user, userVo);
        } catch (Exception e) {
            LOGGER.error("类转换异常：{}", e);
            throw new RuntimeException("类型转换异常：{}", e);
        }
        String userId;
        try
        {
            userId = userMapper.getUserId();
            user.setId(Long.valueOf(userId));
            userMapper.insert(user);
            
            Long id = user.getId();
            String[] roles = userVo.getRoleIds().split(",");
            UserRole userRole = new UserRole();
            
            for (String string : roles) {
                userRole.setUserId(id);
                userRole.setRoleId(Long.valueOf(string));
                userRoleMapper.insert(userRole);
            }
        } catch (Exception e)
        {
            LOGGER.error(e.toString());
        }
    }

    @Override
    @DataSource(name = "gzz")
    public void updateUserPwdById(Long userId, String pwd) {
        try
        {
            userMapper.updateUserPwdById(userId, pwd);
        } catch (Exception e)
        {
            LOGGER.error(e.toString());
        }
    }

    @Override
    @DataSource(name = "gzz")
    public UserVo findUserVoById(Long id) {
        try
        {
            return userMapper.findUserVoById(id);
        } catch (Exception e)
        {
            LOGGER.error(e.toString());
        }
        return null;
    }

    @Override
    @DataSource(name = "gzz")
    public void updateUser(UserVo userVo) {
        User user = new User();
        try {
            PropertyUtils.copyProperties(user, userVo);
        } catch (Exception e) {
            LOGGER.error("类转换异常：{}", e);
            throw new RuntimeException("类型转换异常：{}", e);
        }
        try
        {
            userMapper.updateUser(user);
            Long id = userVo.getId();
            List<UserRole> userRoles = userRoleMapper.findUserRoleByUserId(id);
            if (userRoles != null && (!userRoles.isEmpty())) {
                for (UserRole userRole : userRoles) {
                    userRoleMapper.deleteById(userRole.getId());
                }
            }
            
            String[] roles = userVo.getRoleIds().split(",");
            UserRole userRole = new UserRole();
            for (String string : roles) {
                userRole.setUserId(id);
                userRole.setRoleId(Long.valueOf(string));
                userRoleMapper.insert(userRole);
            }
        } catch (Exception e)
        {
            LOGGER.error(e.toString());
        }

    }

    @Override
    @DataSource(name = "gzz")
    public void deleteUserById(Long id) {
        try
        {
            userMapper.deleteById(id);
            List<UserRole> userRoles = userRoleMapper.findUserRoleByUserId(id);
            if (userRoles != null && (!userRoles.isEmpty())) {
                for (UserRole userRole : userRoles) {
                    userRoleMapper.deleteById(userRole.getId());
                }
            }
        } catch (Exception e)
        {
            LOGGER.error(e.toString());
        }
    }

}
