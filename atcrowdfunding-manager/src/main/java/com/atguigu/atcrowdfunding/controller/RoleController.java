package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;


@Controller
public class RoleController {

    @Autowired
    RoleService roleService;

    @ResponseBody
    @RequestMapping("/role/loadDate")
    public PageInfo<TRole> loadDate(@RequestParam(value = "pageNum" , required = false ,defaultValue = "1") Integer pageNum,
                                    @RequestParam(value = "pageSize", required = false,defaultValue = "10") Integer pageSize,
                                    @RequestParam(value = "condition", required = false,defaultValue = "") String condition){
        PageHelper.startPage(pageNum, pageSize);
        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("condition", condition);

        PageInfo<TRole> pageInfo = roleService.listPage(paramMap);



        return pageInfo;
    }

    @RequestMapping("/role/index")
    public String index(){


        return "role/index";

    }
    @ResponseBody
    @RequestMapping("/role/add")
    public String add(TRole role){

        roleService.add(role);

        return "ok";

    }
    @ResponseBody
    @RequestMapping("/role/get")
    public TRole update(Integer id){



        return roleService.getRoleById(id);

    }
    @ResponseBody
    @RequestMapping("/role/doUpdate")
    public String doupdate(TRole role){


        roleService.update(role);

        return "ok";

    }
    @ResponseBody
    @RequestMapping("/role/delete")
    public String delete(Integer id){


        roleService.deleteRole(id);

        return "ok";

    }
    @ResponseBody
    @RequestMapping("/role/batchDelete")
    public String batchDelete(String roleList){


        roleService.batchDeleteRole(roleList);

        return "ok";

    }

}
