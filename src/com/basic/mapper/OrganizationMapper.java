package com.basic.mapper;

import java.util.List;

import com.basic.model.Organization;

public interface OrganizationMapper {
    /**
     * 删除部门
     *
     * @param id
     * @return
     */
    int deleteOrganizationById(Long id) throws Exception;

    /**
     * 添加部门
     *
     * @param organization
     * @return
     */
    int insert(Organization organization) throws Exception;

    /**
     * 更新部门
     *
     * @param organization
     * @return
     */
    int updateOrganization(Organization organization) throws Exception;

    /**
     * 查询一级部门
     *
     * @return
     */
    List<Organization> findOrganizationAllByPidNull() throws Exception;

    /**
     * 查询部门子集
     *
     * @param pid
     * @return
     */
    List<Organization> findOrganizationAllByPid(Long pid) throws Exception;

    /**
     * 查询所有部门集合
     *
     * @return
     */
    List<Organization> findOrganizationAll() throws Exception;

    /**
     * 根据id查询部门
     *
     * @param id
     * @return
     */
    Organization findOrganizationById(Long id) throws Exception;
}