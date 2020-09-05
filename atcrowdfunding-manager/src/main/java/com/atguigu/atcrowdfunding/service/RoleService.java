package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.github.pagehelper.PageInfo;

import java.util.Map;

public interface RoleService {
    PageInfo<TRole> listPage(Map<String, Object> paramMap);

    void add(TRole role);

    TRole getRoleById(Integer id);

    void update(TRole role);

    void deleteRole(Integer id);

    void batchDeleteRole(String idStr);
}
