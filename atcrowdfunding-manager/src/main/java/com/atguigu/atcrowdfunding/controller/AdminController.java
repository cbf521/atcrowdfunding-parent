package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.Map;

@Controller
public class AdminController {
    @Autowired
    AdminService adminService;

    @RequestMapping("/admin/toAdd")
    public String toAdd(){



        return "/admin/add";
    }

    @RequestMapping("/admin/doAdd")
    public String doAdd(TAdmin admin){
        adminService.saveAdmin(admin);


        return "redirect:/admin/index?pageNum="+Integer.MAX_VALUE;
    }
    @RequestMapping("/admin/doUpdate")
    public String doUpdate(TAdmin admin,Integer pageNum){
        adminService.updateAdmin(admin);


        return "redirect:/admin/index?pageNum="+pageNum;
    }
    @RequestMapping("/admin/toUpdate")
    public String toUpdate(Integer id,Model model){
        TAdmin admin = adminService.getAdminById(id);
        model.addAttribute("admin", admin);



        return "admin/update";
    }
    @RequestMapping("/admin/delete")
    public String delete(Integer id,Integer pageNum){
        adminService.deleteAdmin(id);


        return "redirect:/admin/index?pageNum="+pageNum;
    }
    @RequestMapping("/admin/deleteBatch")
    public String deleteBatch(String idStr,Integer pageNum){
        adminService.deleteBatchAdmin(idStr);


        return "redirect:/admin/index?pageNum="+pageNum;
    }
    @RequestMapping("/admin/index")
    public String index(@RequestParam(value = "pageNum" , required = false , defaultValue = "1") Integer pageNum,
                        @RequestParam(value = "pageSize" , required = false ,defaultValue = "2") Integer pageSize,
                        @RequestParam(value = "condition", required = false , defaultValue = "") String condition,
                        Model model){
        //开启分页功能
        PageHelper.startPage(pageNum, pageSize);

        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("condition", condition);

        PageInfo<TAdmin> pageInfo = adminService.listPage(paramMap);

        model.addAttribute("pageInfo",pageInfo);
        return "admin/index";
    }
}
