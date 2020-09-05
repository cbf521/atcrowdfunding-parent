package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.exception.LoginException;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.MenuService;
import com.atguigu.atcrowdfunding.util.Const;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class DispatcherController {


    @Autowired
    AdminService adminService;


    @Autowired
    MenuService menuService;

    @RequestMapping("/main")
    public String main(HttpSession session){

        List<TMenu> menuList = menuService.listMenus();

        session.setAttribute("menuList", menuList);

        return "main";
    }

    @RequestMapping("/logout")
    public String logout(HttpSession session){

        if (session != null){
            session.invalidate();
        }

        return "redirect:/login.jsp";
    }
    @RequestMapping("/login")
    public  String login(String loginacct , String userpswd, HttpSession session, Model model){
        System.out.println("loginacct = " + loginacct);
        System.out.println("userpswd = " + userpswd);

        try {
            TAdmin admin = adminService.getAdminByLogin(loginacct,userpswd);
            session.setAttribute(Const.LOGIN_ADMIN, admin);

            return "redirect:/main";
        } catch (LoginException e) {
            e.printStackTrace();
            model.addAttribute("message", e.getMessage());
            return "forward:/login.jsp";
        }catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message", "系统出现问题,请稍后再试");
            return "forward:/login.jsp";
        }


    }
}
