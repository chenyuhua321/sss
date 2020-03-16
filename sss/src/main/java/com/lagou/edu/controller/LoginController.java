package com.lagou.edu.controller;

import com.lagou.edu.pojo.Resume;
import com.lagou.edu.service.ResumeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @author Chenyuhua
 * @date 2020/3/16 1:36
 */
@Controller
public class LoginController {
    @Autowired
    private ResumeService resumeService;

    @RequestMapping(value = "/login",method = RequestMethod.POST)
    public String login(HttpSession session, String name, String password, Model model) {

        if (name.equals("admin") && password.equals("admin")) {
            session.setAttribute("username", name);
            List<Resume> resumes = resumeService.queryAccountList();
            model.addAttribute("resume",resumes);
            return "userList";
        } else {
            model.addAttribute("msg", "用户名或密码不正确，请重新登录");
            return "forward:/login.jsp";
        }
    }
}
