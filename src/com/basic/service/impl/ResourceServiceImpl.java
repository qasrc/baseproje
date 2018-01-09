package com.basic.service.impl;

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.basic.annotation.DataSource;
import com.basic.mapper.ResourceMapper;
import com.basic.mapper.RoleMapper;
import com.basic.mapper.UserRoleMapper;
import com.basic.model.Resource;
import com.basic.model.User;
import com.basic.service.ResourceService;
import com.basic.shiro.ShiroUser;
import com.basic.utils.Config;
import com.basic.utils.Tree;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Set;

@Service
public class ResourceServiceImpl implements ResourceService {

    private static Logger LOGGER = Logger.getLogger(ResourceServiceImpl.class);

    @Autowired
    private UserRoleMapper userRoleMapper;
    @Autowired
    private ResourceMapper resourceMapper;
    @Autowired
    private RoleMapper roleMapper;


    private List<String> getRoleNameList() {
        Subject subject = SecurityUtils.getSubject();
        PrincipalCollection principalCollection = subject.getPrincipals();
        ShiroUser shiroUser = (ShiroUser) principalCollection.getPrimaryPrincipal();
        return shiroUser.roleNameList;
    }

    /**
     * 根据用户获取功能菜单
     *
     * @param user 需要获取菜单的用户
     * @return 菜单集合
     */
    @Override
    @DataSource(name = "gzz")
    public List<Tree> findTree(User user, HttpSession httpSession) {
        List<String> s = this.getRoleNameList();
        List<Tree> trees = Lists.newArrayList();
        // 超级管理
        if (s.contains("管理员")) {
            return getAdminTree(trees, "工作", httpSession);
        } else {
            getOrdinaryTree(user, trees, null, "工作", httpSession);
        }

        return trees;
    }

    /**
     * 根据用户查询统计菜单列表
     *
     * @param currentUser
     * @param httpSession
     * @return
     */
    @Override
    public List<Tree> findCountTree(User currentUser, HttpSession httpSession) {
        return null;
    }

    /**
     * lfq
     * 根据用户查询患者菜单列表(无身份证号的患者在左侧菜单只显示HIS)
     *
     * @param currentUser 当前用户信息
     * @param httpSession 保存当前会话信息
     * @return 子元素为Tree的集合
     */
    @Override
    public List<Tree> findPatientTreeOnlyHIS(User currentUser, HttpSession httpSession) {
        return null;
    }

    /**
     * lfq
     * 根据用户查询患者菜单列表
     *
     * @param currentUser 当前用户信息
     * @param httpSession 保存当前会话信息
     * @return 子元素为Tree的集合
     */
    @Override
    public List<Tree> findPatientTree(User currentUser, HttpSession httpSession) {
        return null;
    }


    /**
     * 获取管理员的菜单
     *
     * @param trees 存储获取的菜单
     * @param menu  菜单类型--工作、统计或患者
     * @return 获取到的菜单集合
     */
    private List<Tree> getAdminTree(List<Tree> trees, String menu, HttpSession httpSession) {
        List<Resource> resourceFather;
        try {
            resourceFather = resourceMapper.findResourceAllByTypeAndPidNull(Config.RESOURCE_MENU);
            if (resourceFather == null) {
                return null;
            }

            for (Resource resourceOne : resourceFather) {
                if (resourceOne.getMenu().equals(menu) && resourceOne.getStatus() == 1) {
                    Tree treeOne = new Tree();
                    treeOne.setId(resourceOne.getId());
                    treeOne.setText(resourceOne.getName());
                    treeOne.setIconCls(resourceOne.getIcon());
                    treeOne.setAttributes(resourceOne.getUrl());
                    //获取子树
                    List<Resource> resourceSon = resourceMapper.findResourceAllByTypeAndPid(Config.RESOURCE_MENU, resourceOne.getId());
                    if (resourceSon != null) {
                        List<Tree> tree = Lists.newArrayList();
                        for (Resource resourceTwo : resourceSon) {
                            if (resourceTwo.getStatus() == 1) {
                                Tree treeTwo = new Tree();
                                treeTwo.setId(resourceTwo.getId());
                                treeTwo.setText(resourceTwo.getName());
                                treeTwo.setIconCls(resourceTwo.getIcon());
                                treeTwo.setAttributes(resourceTwo.getUrl());
                                //公共卫生下的二级菜单默认折叠
                                if (resourceTwo.getName().trim().equals("健康教育")
                                        || (resourceTwo.getName().trim().equals("老年人健康管理") && resourceTwo.getMenu().equals("工作"))
                                        || resourceTwo.getName().trim().equals("公卫儿童保健")
                                        || resourceTwo.getName().trim().equals("妇女保健")
                                        || resourceTwo.getName().trim().equals("公卫疾病管理")
                                        || resourceTwo.getName().trim().equals("档案管理")) {
                                    treeTwo.setState("closed");
                                }
                                //获取子树
                                List<Resource> resourceSonSon = resourceMapper.findResourceAllByTypeAndPid(Config.RESOURCE_MENU, resourceTwo.getId());
                                if (resourceSonSon != null) {
                                    List<Tree> treeList = Lists.newArrayList();
                                    for (Resource resourceThree : resourceSonSon) {
                                        if (resourceThree.getStatus() == 1) {
                                            Tree treeThree = new Tree();
                                            treeThree.setId(resourceThree.getId());
                                            treeThree.setText(resourceThree.getName());
                                            treeThree.setIconCls(resourceThree.getIcon());
                                            treeThree.setAttributes(resourceThree.getUrl());
                                            treeList.add(treeThree);
                                        }
                                    }
                                    treeTwo.setChildren(treeList);
                                }
                                tree.add(treeTwo);
                            }
                        }
                        treeOne.setChildren(tree);
                    } else {
                        treeOne.setState("closed");
                    }
                    trees.add(treeOne);
                }
            }
        } catch (Exception e) {
            LOGGER.error(e);
            e.printStackTrace();
        }
        System.out.println(trees);
        return trees;
    }



    /**
     * 获取普通用户的菜单
     *
     * @param user  需要获取菜单的用户
     * @param trees 存储用户菜单
     * @param flag  所属系统----HIS,MB,GW
     * @param menu  菜单类型---工作或统计
     */
    private void getOrdinaryTree(User user, List<Tree> trees, String flag, String menu, HttpSession httpSession) {
        Set<Resource> resourceIdList = Sets.newHashSet();
        List<Long> roleIdList;
        try {
            roleIdList = userRoleMapper.findRoleIdListByUserId(user.getId());
            for (Long i : roleIdList) {
                //根据角色获取资源
                List<Resource> resourceIdLists = roleMapper.findResourceIdListByRoleIdAndType(i);
                for (Resource resource : resourceIdLists) {
                    resourceIdList.add(resource);
                }
            }
            for (Resource resource : resourceIdList) {
                if (resource != null && resource.getMenu().equals(menu)) {
                    if (resource.getPid() == 0 && resource.getStatus() == 1 && (flag == null || resource.getSysname() == null || resource.getSysname().equals(flag))) {
                        Tree treeOne = new Tree();
                        treeOne.setId(resource.getId());
                        treeOne.setText(resource.getName());
                        treeOne.setIconCls(resource.getIcon());
                        treeOne.setAttributes(resource.getUrl());
                        List<Tree> tree = Lists.newArrayList();
                        for (Resource resourceTwo : resourceIdList) {
                            if (resourceTwo.getPid() != 0 && resourceTwo.getStatus() == 1 && resource.getId().longValue() == resourceTwo.getPid().longValue() && (flag == null || resource.getSysname() == null || resource.getSysname().equals(flag))) {
                                Tree treeTwo = new Tree();
                                treeTwo.setId(resourceTwo.getId());
                                treeTwo.setText(resourceTwo.getName());
                                treeTwo.setIconCls(resourceTwo.getIcon());
                                treeTwo.setAttributes(resourceTwo.getUrl());

                                //公共卫生下的二级菜单默认折叠
                                if (resourceTwo.getName().trim().equals("健康教育")
                                        || (resourceTwo.getName().trim().equals("老年人健康管理") && resourceTwo.getMenu().equals("工作"))
                                        || resourceTwo.getName().trim().equals("公卫儿童保健")
                                        || resourceTwo.getName().trim().equals("妇女保健")
                                        || resourceTwo.getName().trim().equals("公卫疾病管理")
                                        || resourceTwo.getName().trim().equals("档案管理")) {
                                    treeTwo.setState("closed");
                                }
                                List<Tree> treeList = Lists.newArrayList();
                                for (Resource resourceThree : resourceIdList) {
                                    if (resourceThree.getPid() != 0 && resourceThree.getStatus() == 1 && resourceTwo.getId().longValue() == resourceThree.getPid().longValue() && (flag == null || resource.getSysname() == null || resource.getSysname().equals(flag))) {
                                        Tree treeThree = new Tree();
                                        treeThree.setId(resourceThree.getId());
                                        treeThree.setText(resourceThree.getName());
                                        treeThree.setIconCls(resourceThree.getIcon());
                                        treeThree.setAttributes(resourceThree.getUrl());
                                        treeList.add(treeThree);
                                    }
                                }
                                treeTwo.setChildren(treeList);
                                tree.add(treeTwo);
                            }
                        }
                        treeOne.setChildren(tree);
                        trees.add(treeOne);
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.error(e);
            e.printStackTrace();
        }

    }



    @Override
    @DataSource(name = "gzz")
    public List<Resource> findResourceAll() {
        try {
            return resourceMapper.findResourceAll();
        } catch (Exception e) {
            LOGGER.error(e);
            e.printStackTrace();
        }
        return null;
    }

    @Override
    @DataSource(name = "gzz")
    public void addResource(Resource resource) {
        try {
            resourceMapper.insert(resource);
        } catch (Exception e) {
            LOGGER.error(e);
            e.printStackTrace();
        }
    }

    /**
     * 获取所有的树结点
     *
     * @return 所有的结点集合
     */
    @Override
    @DataSource(name = "gzz")
    public List<Tree> findAllTree() {
        List<Tree> trees = Lists.newArrayList();
        // 查询所有的一级树
        List<Resource> resources;
        try {
            resources = resourceMapper.findResourceAllByTypeAndPidNull(Config.RESOURCE_MENU);
            if (resources == null) {
                return null;
            }
            for (Resource resourceOne : resources) {
                Tree treeOne = new Tree();

                treeOne.setId(resourceOne.getId());
                treeOne.setText(resourceOne.getName());
                treeOne.setIconCls(resourceOne.getIcon());
                treeOne.setAttributes(resourceOne.getUrl());
                // 查询所有一级树下的二级树
                List<Resource> resourceSon = resourceMapper.findResourceAllByTypeAndPid(Config.RESOURCE_MENU, resourceOne.getId());

                if (resourceSon != null) {
                    List<Tree> tree = Lists.newArrayList();
                    for (Resource resourceTwo : resourceSon) {
                        Tree treeTwo = new Tree();
                        treeTwo.setId(resourceTwo.getId());
                        treeTwo.setText(resourceTwo.getName());
                        treeTwo.setIconCls(resourceTwo.getIcon());
                        treeTwo.setAttributes(resourceTwo.getUrl());
                        //查询所有二级树下的三级树
                        List<Resource> resourceSonSon = resourceMapper.findResourceAllByTypeAndPid(Config.RESOURCE_MENU, resourceTwo.getId());
                        if (resourceSonSon != null) {
                            List<Tree> treeList = Lists.newArrayList();
                            for (Resource resourceThree : resourceSonSon) {
                                Tree treeThree = new Tree();
                                treeThree.setId(resourceThree.getId());
                                treeThree.setText(resourceThree.getName());
                                treeThree.setIconCls(resourceThree.getIcon());
                                treeThree.setAttributes(resourceThree.getUrl());
                                treeList.add(treeThree);
                            }
                            treeTwo.setChildren(treeList);
                        }
                        tree.add(treeTwo);
                    }
                    treeOne.setChildren(tree);
                } else {
                    treeOne.setState("closed");
                }
                trees.add(treeOne);
            }
        } catch (Exception e) {
            LOGGER.error(e);
            e.printStackTrace();
        }

        return trees;
    }

    @Override
    @DataSource(name = "gzz")
    public List<Tree> findAllTrees() {
        List<Tree> treeOneList = Lists.newArrayList();

        // 查询所有的一级树
        List<Resource> resources;
        try {
            resources = resourceMapper.findResourceAllByTypeAndPidNull(Config.RESOURCE_MENU);
            if (resources == null) {
                return null;
            }

            for (Resource resourceOne : resources) {
                Tree treeOne = new Tree();

                treeOne.setId(resourceOne.getId());
                treeOne.setText(resourceOne.getName());
                treeOne.setIconCls(resourceOne.getIcon());
                treeOne.setAttributes(resourceOne.getUrl());

                List<Resource> resourceSon = resourceMapper.findResourceAllByTypeAndPid(Config.RESOURCE_MENU, resourceOne.getId());

                if (resourceSon == null) {
                    treeOne.setState("closed");
                } else {
                    List<Tree> treeTwoList = Lists.newArrayList();

                    for (Resource resourceTwo : resourceSon) {
                        Tree treeTwo = new Tree();

                        treeTwo.setId(resourceTwo.getId());
                        treeTwo.setText(resourceTwo.getName());
                        treeTwo.setIconCls(resourceTwo.getIcon());
                        treeTwo.setAttributes(resourceTwo.getUrl());

                        /***************************************************/
                        List<Resource> resourceSons = resourceMapper.findResourceAllByTypeAndPid(Config.RESOURCE_MENU, resourceTwo.getId());

                        if (resourceSons == null) {
                            treeTwo.setState("closed");
                        } else {
                            List<Tree> treeThreeList = Lists.newArrayList();

                            for (Resource resourceThree : resourceSons) {
                                Tree treeThree = new Tree();

                                treeThree.setId(resourceThree.getId());
                                treeThree.setText(resourceThree.getName());
                                treeThree.setIconCls(resourceThree.getIcon());
                                treeThree.setAttributes(resourceThree.getUrl());

                                treeThreeList.add(treeThree);
                            }
                            treeTwo.setChildren(treeThreeList);
                        }
                        /***************************************************/

                        treeTwoList.add(treeTwo);
                    }
                    treeOne.setChildren(treeTwoList);
                }

                treeOneList.add(treeOne);
            }
        } catch (Exception e) {
            LOGGER.error(e);
            e.printStackTrace();
        }

        return treeOneList;
    }

    @Override
    @DataSource(name = "gzz")
    public void updateResource(Resource resource) {
        int update;
        try {
            update = resourceMapper.updateResource(resource);
            if (update != 1) {
                throw new RuntimeException("更新失败");
            }
        } catch (Exception e) {
            LOGGER.error(e);
            e.printStackTrace();
        }
    }

    @Override
    @DataSource(name = "gzz")
    public Resource findResourceById(Long id) {
        try {
            return resourceMapper.findResourceById(id);
        } catch (Exception e) {
            LOGGER.error(e);
            e.printStackTrace();
        }
        return null;
    }

    @Override
    @DataSource(name = "gzz")
    public void deleteResourceById(Long id) {
        int delete;
        try {
            delete = resourceMapper.deleteResourceById(id);
            if (delete != 1) {
                throw new RuntimeException("删除失败");
            }
        } catch (Exception e) {
            LOGGER.error(e);
            e.printStackTrace();
        }
    }

}
