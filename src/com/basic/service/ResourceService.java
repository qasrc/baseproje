package com.basic.service;

import com.basic.model.Resource;
import com.basic.model.User;
import com.basic.utils.Tree;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @description：资源管理
 */
public interface ResourceService {

    /**
     * 根据用户查询工作菜单列表
     *
     * @param currentUser
     * @return
     */
    List<Tree> findTree(User currentUser, HttpSession httpSession);

    /**
     * 根据用户查询统计菜单列表
     *
     * @param currentUser
     * @return
     */
    List<Tree> findCountTree(User currentUser, HttpSession httpSession);
    
    /**
     * lfq
     * 根据用户查询患者菜单列表(无身份证号的患者在左侧菜单只显示HIS)
     * @param currentUser 当前用户信息
     * @param httpSession 保存当前会话信息
     * @return 子元素为Tree的集合
     */
     List<Tree> findPatientTreeOnlyHIS(User currentUser,HttpSession httpSession);
    
     /**
      * lfq
      * 根据用户查询患者菜单列表
      * @param currentUser 当前用户信息
      * @param httpSession 保存当前会话信息
      * @return 子元素为Tree的集合
      */
      List<Tree> findPatientTree(User currentUser,HttpSession httpSession);
     
    /**
     * 查询所有资源
     *
     * @return
     */
    List<Resource> findResourceAll();

    /**
     * 添加资源
     *
     * @param resource
     */
    void addResource(Resource resource);


    //抽取到工具类中
//    JsonObj getJsonRemote(String code);

    /**
     * 查询二级数
     *
     * @return
     */
    List<Tree> findAllTree();

    /**
     * 查询三级数
     *
     * @return
     */
    List<Tree> findAllTrees();

    /**
     * 更新资源
     *
     * @param resource
     */
    void updateResource(Resource resource);

    /**
     * 根据id查询资源
     *
     * @param id
     * @return
     */
    Resource findResourceById(Long id);

    /**
     * 根据id删除资源
     *
     * @param id
     */
    void deleteResourceById(Long id);

}
