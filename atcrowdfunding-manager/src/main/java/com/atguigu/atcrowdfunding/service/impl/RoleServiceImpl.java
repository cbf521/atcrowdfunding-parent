package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.bean.TRoleExample;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.mapper.TRoleMapper;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class RoleServiceImpl implements RoleService {
    @Autowired
    TRoleMapper roleMapper;
    @Override
    public PageInfo<TRole> listPage(Map<String, Object> paramMap) {

        TRoleExample example = new TRoleExample();
        String condition = (String) paramMap.get("condition");
        if (!StringUtils.isEmpty(condition)){
            example.createCriteria().andNameLike("%"+condition+"%");
        }
        List<TRole> list = roleMapper.selectByExample(example);

        PageInfo<TRole> pageInfo = new PageInfo<>(list,5);

        return pageInfo;
    }

    @Override
    public void add(TRole role) {
        roleMapper.insertSelective(role);
    }

    @Override
    public TRole getRoleById(Integer id) {
        return roleMapper.selectByPrimaryKey(id);
    }

    @Override
    public void update(TRole role) {
        roleMapper.updateByPrimaryKeySelective(role);
    }

    @Override
    public void deleteRole(Integer id) {
        roleMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void batchDeleteRole(String idStr) {
        if (!StringUtils.isEmpty(idStr)){
            List<Integer> idList = new ArrayList<>();
            String[] split = idStr.split(",");
            for (String s : split) {
                int i = Integer.parseInt(s);
                idList.add(i);
            }
            TRoleExample example = new TRoleExample();
            example.createCriteria().andIdIn(idList);
            roleMapper.deleteByExample(example);
        }
    }
}
