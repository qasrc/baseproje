package com.basic.controller;

import com.basic.utils.Result;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.DisabledAccountException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 登录退出
 */
@Controller
public class LoginController extends BaseController {

    private static Logger LOGGER = Logger.getLogger(LoginController.class);


    /**
     * 首页
     */
    @RequestMapping(value = "/")
    public String index() {
        return "redirect:/index";
    }


    /**
     * 首页
     *
     * @param model 存储数据
     * @return 登录页面
     */
    @RequestMapping(value = "/index")
    public String index(Model model, HttpSession httpSession) {


        model.addAttribute("msg", "hello world");
        return "/index";
    }




    /**
     * GET 登录
     */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login() {
        LOGGER.info("GET请求登录");
        if (SecurityUtils.getSubject().isAuthenticated()) {
            return "redirect:/index";
        }
        return "/login";
    }


    /**
     * POST 登录 shiro 写法
     *
     * @param username 用户名
     * @param password 密码
     */
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    @ResponseBody
    public Result loginPost(String username, String password) {
        LOGGER.info("POST请求登录");
        Result result = new Result();
        if (StringUtils.isBlank(username)) {
            result.setMsg("用户名不能为空");
            return result;
        }
        if (StringUtils.isBlank(password)) {
            result.setMsg("密码不能为空");
            return result;
        }
        Subject user = SecurityUtils.getSubject();
        UsernamePasswordToken token = new UsernamePasswordToken(username, DigestUtils.md5Hex(password).toCharArray());
        token.setRememberMe(true);
        try {
            user.login(token);
        } catch (UnknownAccountException e) {
            LOGGER.error("账号不存在：{}", e);
            result.setMsg("账号不存在");
            return result;
        } catch (DisabledAccountException e) {
            LOGGER.error("账号未启用：{}", e);
            result.setMsg("账号未启用");
            return result;
        } catch (IncorrectCredentialsException e) {
            LOGGER.error("密码错误：{}", e);
            result.setMsg("密码错误");
            return result;
        } catch (RuntimeException e) {
            LOGGER.error("未知错误,请联系管理员：{}", e);
            result.setMsg("未知错误,请联系管理员");
            return result;
        }
        result.setSuccess(true);
        return result;
    }

    /**
     * 未授权
     */
    @RequestMapping(value = "/unauth")
    public String unauth() {
        if (SecurityUtils.getSubject().isAuthenticated() == false) {
            return "redirect:/login";
        }
        return "/unauth";
    }

    /**
     * 退出
     */
    @RequestMapping(value = "/logout")
    @ResponseBody
    public Result logout() {
        LOGGER.info("登出");
        Subject subject = SecurityUtils.getSubject();
        Result result = new Result();
        subject.logout();
        result.setSuccess(true);
        return result;
    }
}
