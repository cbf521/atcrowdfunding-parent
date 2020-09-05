package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.exception.LoginException;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.util.Const;
import com.atguigu.atcrowdfunding.util.DateUtil;
import com.atguigu.atcrowdfunding.util.MD5Util;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    TAdminMapper adminMapper;

    @Override
    public TAdmin getAdminByLogin(String loginacct, String userpswd) {

        TAdminExample example = new TAdminExample();

        example.createCriteria().andLoginacctEqualTo(loginacct);
        List<TAdmin> list = adminMapper.selectByExample(example);

        if (list == null || list.size() == 0){
            throw  new LoginException(Const.LOGIN_LOGINACCT_ERROR);
        }

        TAdmin admin = list.get(0);

        if (! admin.getUserpswd().equals(MD5Util.digest(userpswd))){
            throw  new LoginException(Const.LOGIN_USERPSWD_ERROR);
        }
        return admin;
    }

    @Override
    public PageInfo<TAdmin> listPage(Map<String, Object> paramMap) {
        TAdminExample example = new TAdminExample();

        String condition = (String) paramMap.get("condition");
        if (!StringUtils.isEmpty(condition)){
            example.createCriteria().andLoginacctLike("%"+condition+"%");

            TAdminExample.Criteria criteria2 = example.createCriteria();
            criteria2.andUsernameLike("%"+condition+"%");
            TAdminExample.Criteria criteria3 = example.createCriteria();
            criteria3.andEmailLike("%"+condition+"%");
            example.or(criteria2);
            example.or(criteria3);
        }


        List<TAdmin> list = adminMapper.selectByExample(example);

        PageInfo<TAdmin> pageInfo = new PageInfo<>(list,5);

        return pageInfo;
    }

    @Override
    public void saveAdmin(TAdmin admin) {
        admin.setUserpswd(MD5Util.digest(Const.DEFALUT_PASSWORD));
        admin.setCreatetime(DateUtil.getFormatTime());
        adminMapper.insertSelective(admin);
    }

    @Override
    public TAdmin getAdminById(Integer id) {
        TAdmin admin = adminMapper.selectByPrimaryKey(id);

        return admin;
    }

    @Override
    public void updateAdmin(TAdmin admin) {
        adminMapper.updateByPrimaryKeySelective(admin);
    }

    @Override
    public void deleteAdmin(Integer id) {
        adminMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void deleteBatchAdmin(String idStr) {
        if (!StringUtils.isEmpty(idStr)){
            List<Integer> idList = new ArrayList<>();
            String[] split = idStr.split(",");
            for (String s : split) {
                int i = Integer.parseInt(s);
                idList.add(i);

            }
            TAdminExample example = new TAdminExample();

            example.createCriteria().andIdIn(idList);
            adminMapper.deleteByExample(example);
        }


    }
}
