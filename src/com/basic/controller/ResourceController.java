package com.basic.controller;

import com.google.common.collect.Maps;
import com.basic.model.Resource;
import com.basic.model.User;
import com.basic.service.ResourceService;
import com.basic.utils.Result;
import com.basic.utils.Tree;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 * 资源管理
 */
@Controller
@RequestMapping("/resources")
public class ResourceController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(ResourceController.class);

    private static final String MSUNECG_ADDRESS = "msunECGAddress";
    private static final String RMC_ADDRESS = "rmcAddress";
    private static final String NCDMS_ADDRESS = "ncdmsAddress";
    private static final String DSIGN_ADDRESS = "dsignAddress";
    private static final String PHS_ADDRESS = "phsAddress";
    private static final String HIS_ADDRESS = "hisAddress";
    //存放替换的资源路径
    private Map<String, String> menuMap = Maps.newHashMap();
    @Autowired
    private ResourceService resourceService;

    /**
     * 菜单树，工作菜单
     */
    @RequestMapping(value = "/tree", method = RequestMethod.POST)
    @ResponseBody
    public List<Tree> tree(HttpSession httpSession) {
        User currentUser = getCurrentUser();
        List<Tree> trees = resourceService.findTree(currentUser, httpSession);
        return this.getRealTree(trees, httpSession);
    }

    /**
     * 菜单树，统计菜单
     */
    @RequestMapping(value = "/tree_count", method = RequestMethod.POST)
    @ResponseBody
    public List<Tree> treeCount(HttpSession httpSession) {
        User currentUser = getCurrentUser();
        List<Tree> trees = resourceService.findCountTree(currentUser, httpSession);
        return this.getRealTree(trees, httpSession);
    }



    /**
     * 资源管理页
     */
    @RequestMapping(value = "/manager", method = RequestMethod.GET)
    public String manager() {
        return "/admin/resource";
    }

    /**
     * 资源管理列表
     */
    @RequestMapping(value = "/treeGrid", method = RequestMethod.POST)
    @ResponseBody
    public List<Resource> treeGrid() {
        return resourceService.findResourceAll();
    }

    /**
     * 添加资源页
     */
    @RequestMapping("/addPage")
    public String addPage() {
        return "/admin/resourceAdd";
    }

    /**
     * 添加资源
     */
    @RequestMapping("/add")
    @ResponseBody
    public Result add(Resource resource) {
        Result result = new Result();
        try {
            if (resource.getPid() == null) {
                resource.setPid(0L);
            }
            resourceService.addResource(resource);
            result.setSuccess(true);
            result.setMsg("添加成功！");
            return result;
        } catch (RuntimeException e) {
            logger.error("添加资源失败：{}", e);
            result.setMsg(e.getMessage());
            return result;
        }
    }

    /**
     * 获取替换路径之后的菜单
     *
     * @param trees 需要替换路径的菜单
     */
    private List<Tree> getRealTree(List<Tree> trees, HttpSession httpSession) {

        return trees;
    }


    /**
     * 替换患者菜单中的参数
     *
     * @param patientUrl 需要替换的患者菜单链接
     * @param paramName  被替换的参数名
     */
    private String getPatientParam(String patientUrl, String paramName, HttpSession httpSession) {
        Map<String, String> params = (Map<String, String>) httpSession.getAttribute("patientParam");
        //System.err.println(params+" : "+paramName);
        return patientUrl.replaceAll(paramName, params.get(paramName) == null ? paramName : params.get(paramName));
    }



    /**
     * 二级资源树
     */
    @RequestMapping("/allTree")
    @ResponseBody
    public List<Tree> allTree() {
        return resourceService.findAllTree();
    }

    /**
     * 三级资源树
     */
    @RequestMapping(value = "/allTrees", method = RequestMethod.POST)
    @ResponseBody
    public List<Tree> allTrees() {
        return resourceService.findAllTrees();
    }

    /**
     * 编辑资源页
     */
    @RequestMapping("/editPage")
    public String editPage(Model model, Long id) {
        Resource resource = resourceService.findResourceById(id);
        model.addAttribute("resource", resource);
        return "/admin/resourceEdit";
    }

    /**
     * 编辑资源
     */
    @RequestMapping("/edit")
    @ResponseBody
    public Result edit(Resource resource) {
        Result result = new Result();
        try {
            resourceService.updateResource(resource);
            result.setSuccess(true);
            result.setMsg("编辑成功！");
            return result;
        } catch (RuntimeException e) {
            logger.error("编辑资源失败：{}", e);
            result.setMsg(e.getMessage());
            return result;
        }
    }

    /**
     * 删除资源
     */
    @RequestMapping("/delete")
    @ResponseBody
    public Result delete(Long id) {
        Result result = new Result();
        try {
            resourceService.deleteResourceById(id);
            result.setMsg("删除成功！");
            result.setSuccess(true);
            return result;
        } catch (RuntimeException e) {
            logger.error("删除资源失败：{}", e);
            result.setMsg(e.getMessage());
            return result;
        }
    }

}
