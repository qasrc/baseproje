package com.basic.mapper;

import com.basic.model.Resource;
import com.basic.model.Role;
import com.basic.utils.PageInfo;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

@Component
public interface RoleMapper {
    /**
     * 添加角色
     *
     * @param role
     * @return
     */
    int insert(Role role) throws Exception;

    /**
     * 查询角色列表
     *
     * @param pageInfo
     * @return
     */
    List findRolePageCondition(PageInfo pageInfo) throws Exception;

    /**
     * 角色统计
     *
     * @param pageInfo
     * @return
     */
    int findRolePageCount(PageInfo pageInfo) throws Exception;

    /**
     * 角色列表
     *
     * @return
     */
    List<Role> findRoleAll() throws Exception;

    /**
     * 根据id查询角色
     *
     * @param id
     * @return
     */
    Role findRoleById(Long id) throws Exception;

    /**
     * 更新角色
     *
     * @param role
     * @return
     */
    int updateRole(Role role) throws Exception;

    /**
     * 删除角色
     *
     * @param id
     * @return
     */
    int deleteRoleById(Long id) throws Exception;

    /**
     * 根据角色查询资源id列表
     *
     * @param id
     * @return
     */
    List<Long> findResourceIdListByRoleId(Long id) throws Exception;

    /**
     * 根据角色id查询资源角色关联id列表
     *
     * @param
     * @return
     */
    List<Long> findRoleResourceIdListByRoleId(Long id) throws Exception;

    /**
     * 根据角色id查询资源id、链接列表
     *
     * @param id
     * @return
     */
    List<Map<Long, String>> findRoleResourceListByRoleId(Long id) throws Exception;

    /**
     * 查询角色下的菜单列表
     *
     * @param i
     * @return
     */
    List<Resource> findResourceIdListByRoleIdAndTypeOnlyHIS(Long i) throws Exception;
    
    /**
     * 查询角色下的菜单列表(无身份证下只含HIS)
     *
     * @param i
     * @return
     */
    List<Resource> findResourceIdListByRoleIdAndType(Long i) throws Exception;

}