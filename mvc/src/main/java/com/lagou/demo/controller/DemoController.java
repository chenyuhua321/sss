package com.lagou.demo.controller;

import com.lagou.demo.service.IDemoService;
import com.lagou.edu.mvcframework.annotations.LagouAutowired;
import com.lagou.edu.mvcframework.annotations.LagouController;
import com.lagou.edu.mvcframework.annotations.LagouRequestMapping;
import com.lagou.edu.mvcframework.annotations.LagouSecurity;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@LagouController
@LagouRequestMapping("/demo")
public class DemoController {


    @LagouAutowired
    private IDemoService demoService;


    /**
     * URL: /demo/query?name=lisi
     * @param request
     * @param response
     * @param username
     * @return
     */
    @LagouSecurity(value = {"zhangsan"})
    @LagouRequestMapping("/query")
    public String query(HttpServletRequest request, HttpServletResponse response,String username) {
        return demoService.get(username);
    }

    /**
     * URL: /demo/query?name=lisi
     * @param request
     * @param response
     * @param username
     * @return
     */
    @LagouSecurity(value = {"wangwu"})
    @LagouRequestMapping("/handler2")
    public String handler2(HttpServletRequest request, HttpServletResponse response,String username) {
        return demoService.get(username);
    }

    /**
     * URL: /demo/query?name=lisi
     * @param request
     * @param response
     * @param username
     * @return
     */
    @LagouSecurity(value = {"lisi"})
    @LagouRequestMapping("/handler3")
    public String handler3(HttpServletRequest request, HttpServletResponse response,String username) {
        return demoService.get(username);
    }

    /**
     * URL: /demo/query?name=lisi
     * @param request
     * @param response
     * @param username
     * @return
     */
    @LagouSecurity(value = {"zhangsan","lisi"})
    @LagouRequestMapping("/handler4")
    public String handler4(HttpServletRequest request, HttpServletResponse response,String username) {
        return demoService.get(username);
    }
}
