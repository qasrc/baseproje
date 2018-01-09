package com.basic.service.impl;

import com.google.common.collect.Lists;
import com.basic.annotation.DataSource;
import com.basic.exception.ServiceException;
import com.basic.mapper.RoleMapper;
import com.basic.mapper.RoleResourceMapper;
import com.basic.mapper.UserRoleMapper;
import com.basic.model.Role;
import com.basic.model.RoleResource;
import com.basic.service.RoleService;
import com.basic.utils.PageInfo;
import com.basic.utils.Tree;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class RoleServiceImpl implements RoleService {

    private static Logger LOGGER = LoggerFactory.getLogger(RoleServiceImpl.class);

    @Autowired
    private RoleMapper roleMapper;
    @Autowired
    private RoleResourceMapper roleResourceMapper;
    @Autowired
    private UserRoleMapper userRoleMapper;

    @Override
    @DataSource(name = "gzz")
    public void findDataGrid(PageInfo pageInfo) {
        try
        {
            pageInfo.setRows(roleMapper.findRolePageCondition(pageInfo));
            pageInfo.setTotal(roleMapper.findRolePageCount(pageInfo));
        } catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    @Override
    @DataSource(name = "gzz")
    public List<Tree> findTree() {
        List<Tree> trees = Lists.newArrayList();
        try
        {
            List<Role> roles = roleMapper.findRoleAll();
            for (Role role : roles) {
                Tree tree = new Tree();
                tree.setId(role.getId());
                tree.setText(role.getName());

                trees.add(tree);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
      
        return trees;
    }

    @Override
    @DataSource(name = "gzz")
    public void addRole(Role role) {
        try
        {
            int insert = roleMapper.insert(role);
            if (insert != 1) {
                LOGGER.warn("插入失败，参数：{}", role.toString());
                throw new ServiceException("插入失败");
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        
    }

    @Override
    @DataSource(name = "gzz")
    public void deleteRoleById(Long id) {
        int update;
        try
        {
            update = roleMapper.deleteRoleById(id);
            if (update != 1) {
                LOGGER.warn("删除失败，id：{}", id);
                throw new ServiceException("删除失败");
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }

    }

    @Override
    @DataSource(name = "gzz")
    public Role findRoleById(Long id) {
        try
        {
            return roleMapper.findRoleById(id);
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    @DataSource(name = "gzz")
    public void updateRole(Role role) {
        try
        {
            int update = roleMapper.updateRole(role);
            if (update != 1) {
                LOGGER.warn("更新失败，参数：{}", role.toString());
                throw new ServiceException("更新失败");
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }
       
    }

    @Override
    @DataSource(name = "gzz")
    public List<Long> findResourceIdListByRoleId(Long id) {
        try
        {
            return roleMapper.findResourceIdListByRoleId(id);
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    @DataSource(name = "gzz")
    public void updateRoleResource(Long id, String resourceIds) {
        // 先删除后添加,有点爆力
        List<Long> roleResourceIdList;
        try
        {
            roleResourceIdList = roleMapper.findRoleResourceIdListByRoleId(id);
            if (roleResourceIdList != null && (!roleResourceIdList.isEmpty())) {
                for (Long roleResourceId : roleResourceIdList) {
                    roleResourceMapper.deleteById(roleResourceId);
                }
            }
            String[] resources = resourceIds.split(",");
            RoleResource roleResource = new RoleResource();
            for (String string : resources) {
                roleResource.setRoleId(id);
                roleResource.setResourceId(Long.parseLong(string));
                roleResourceMapper.insert(roleResource);
            }
        } catch (Exception e)
        {
            e.printStackTrace();
        }

    }

    @Override
    @DataSource(name = "gzz")
    public List<Long> findRoleIdListByUserId(Long userId) {
        try
        {
            return userRoleMapper.findRoleIdListByUserId(userId);
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    @DataSource(name = "gzz")
    public List<String> findRoleNameListByUserId(Long userId) {
        try {
            return userRoleMapper.findRoleNameListByUserId(userId);
        } catch (Exception e) {
            LOGGER.error(e.toString());
            throw new ServiceException("获取角色名称失败");
        }
    }

    @Override
    @DataSource(name = "gzz")
    public List<Map<Long, String>> findRoleResourceListByRoleId(Long roleId) {
        try
        {
            return roleMapper.findRoleResourceListByRoleId(roleId);
        } catch (Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

}
