package com.basic.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @description：测试主题切换
 */
@Controller
@RequestMapping("/testTheme")
public class TestThemeController {

    private static Logger LOGGER = LoggerFactory.getLogger(TestThemeController.class);

    /**
     * 首页
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/testTheme")
    public String basic(Model model) {
        return "/basic";
    }

}
