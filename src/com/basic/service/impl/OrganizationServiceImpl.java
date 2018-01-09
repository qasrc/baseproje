package com.basic.service.impl;

import com.google.common.collect.Lists;
import com.basic.annotation.DataSource;
import com.basic.mapper.OrganizationMapper;
import com.basic.model.Organization;
import com.basic.service.OrganizationService;
import com.basic.utils.Tree;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class OrganizationServiceImpl implements OrganizationService {
    @Autowired
    private OrganizationMapper organizationMapper;

    @Override
    @DataSource(name = "gzz")
    public List<Tree> findTree() {
        List<Tree> trees = Lists.newArrayList();

        List<Organization> organizationFather;
        try
        {
            organizationFather = organizationMapper.findOrganizationAllByPidNull();
            
            if (organizationFather != null) {
                for (Organization organizationOne : organizationFather) {
                    Tree treeOne = new Tree();
                    
                    treeOne.setId(organizationOne.getId());
                    treeOne.setText(organizationOne.getName());
                    treeOne.setIconCls(organizationOne.getIcon());
                    
                    List<Organization> organizationSon = organizationMapper.findOrganizationAllByPid(organizationOne.getId());
                    
                    if (organizationSon != null) {
                        List<Tree> tree = Lists.newArrayList();
                        for (Organization organizationTwo : organizationSon) {
                            Tree treeTwo = new Tree();
                            treeTwo.setId(organizationTwo.getId());
                            treeTwo.setText(organizationTwo.getName());
                            treeTwo.setIconCls(organizationTwo.getIcon());
                            tree.add(treeTwo);
                        }
                        treeOne.setChildren(tree);
                    } else {
                        treeOne.setState("closed");
                    }
                    trees.add(treeOne);
                }
            }
        } catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return trees;
    }

    @Override
    @DataSource(name = "gzz")
    public List<Organization> findTreeGrid() {
        try
        {
            return organizationMapper.findOrganizationAll();
        } catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return new ArrayList<Organization>();
    }

    @Override
    @DataSource(name = "gzz")
    public void addOrganization(Organization organization) {
        try
        {
            organizationMapper.insert(organization);
        } catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    @Override
    @DataSource(name = "gzz")
    public Organization findOrganizationById(Long id) {
        try
        {
            return organizationMapper.findOrganizationById(id);
        } catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return new Organization();
    }

    @Override
    @DataSource(name = "gzz")
    public void updateOrganization(Organization organization) {
        try
        {
            organizationMapper.updateOrganization(organization);
        } catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    @Override
    @DataSource(name = "gzz")
    public void deleteOrganizationById(Long id) {
        try
        {
            organizationMapper.deleteOrganizationById(id);
        } catch (Exception e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

}
