package com.basic.mapper;

import com.basic.model.Resource;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public interface ResourceMapper {
    /**
     * 添加资源
     *
     * @param resource
     * @return
     */
    int insert(Resource resource) throws Exception;

    /**
     * 修改资源
     *
     * @param resource
     * @return
     */
    int updateResource(Resource resource) throws Exception;

    /**
     * 查询菜单资源
     *
     * @param resourceType
     * @param pid
     * @return
     */
    List<Resource> findResourceAllByTypeAndPid(@Param("resourceType") Integer resourceType, @Param("pid") Long pid) throws Exception;
    
    List<Resource> findResourceAllByTypeAndPidAndOnlyHIS(@Param("resourceType") Integer resourceType, @Param("pid") Long pid) throws Exception;

    /**
     * 查询所有资源
     *
     * @return
     */
    List<Resource> findResourceAll() throws Exception;

    /**
     * 查询一级资源
     *
     * @param resourceMenu
     * @return
     */
    List<Resource> findResourceAllByTypeAndPidNull(Integer resourceMenu) throws Exception;
    
    /**
     * 查询一级资源
     *
     * @param resourceMenu
     * @return
     */
    List<Resource> findResourceAllByTypeAndPidNullOnlyHIS(Integer resourceMenu) throws Exception;

    /**
     * 根据id查询资源
     *
     * @param id
     * @return
     */
    Resource findResourceById(Long id) throws Exception;

    /**
     * 删除资源
     *
     * @param id
     * @return
     */
    int deleteResourceById(Long id) throws Exception;
}