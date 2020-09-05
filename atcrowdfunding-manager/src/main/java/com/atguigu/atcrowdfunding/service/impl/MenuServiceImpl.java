package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.mapper.TMenuMapper;
import com.atguigu.atcrowdfunding.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MenuServiceImpl implements MenuService {


    @Autowired
    TMenuMapper menuMapper;

    @Override
    public List<TMenu> listMenus() {

        //存放父类菜单集合pid 等于0
        List<TMenu> parentMenuList = new ArrayList<>();
        Map<Integer, TMenu> cache = new HashMap<>();

        //查询表的全部数据
        List<TMenu> menuList = menuMapper.selectByExample(null);

        //循环出父菜单
        for (TMenu tMenu : menuList) {
            if (tMenu.getPid() == 0) {
                parentMenuList.add(tMenu);
                cache.put(tMenu.getId(), tMenu);
            }
        }

        //找到子菜单
        for (TMenu menu : menuList) {
            if (menu.getPid() != 0) {
                Integer pid = menu.getPid();
                TMenu parentMenu = cache.get(pid);
                parentMenu.getChildren().add(menu);


            }
        }


        return parentMenuList;
    }

    @Override
    public List<TMenu> listAllTree() {

        return menuMapper.selectByExample(null);
    }
}
