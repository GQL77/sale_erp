package ysu.lgq.sale_erp.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.springframework.beans.factory.annotation.Autowired;
import ysu.lgq.sale_erp.entity.Results;
import ysu.lgq.sale_erp.entity.User;
import ysu.lgq.sale_erp.mapper.UserMapper;
import ysu.lgq.sale_erp.service.IUserService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import ysu.lgq.sale_erp.util.JwtUtils;

import java.util.HashMap;
import java.util.Map;

import static ysu.lgq.sale_erp.util.BCryptUtil.checkPassword;
import static ysu.lgq.sale_erp.util.BCryptUtil.hashPassword;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author lgq
 * @since 2025-02-08
 */
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService {
    @Autowired
    private UserMapper userMapper;

    @Override
    public Results<String> login(String account, String password) {
        System.out.println("输入account:"+account+" password:"+password);
        //判断账号是否存在
        User user=userMapper.selectOne(new QueryWrapper<User>().eq("account", account));
        System.out.println("findUserByAccount:"+user);
        if(user!=null&&!user.getStatus().equals("禁用")){
            if(user.getStatus().equals("冻结")){
                return Results.Error(403,"账号已冻结，联系相关部门处理");
            }else if(checkPassword(password,user.getPassword())){
                System.out.println("成功登录!");
                Map<String, Object> claims = new HashMap<>();
                claims.put("account", user.getAccount());
                claims.put("username", user.getUsername());
                claims.put("role", user.getRole());
                claims.put("email", user.getEmail());
                claims.put("phone", user.getPhone());
                String jwt = JwtUtils.generateJwt(claims);
                System.out.println("jwt令牌："+jwt);
                return Results.Success(jwt);
            }else return Results.Error(400,"用户名或密码错误");
        }else return Results.Error(400,"用户名不存在");

    }

    @Override
    public Results<String> register(String account, String username, int role, String phone) {
        if (userMapper.selectOne(new QueryWrapper<User>().eq("account",account)) != null){
            return Results.Error(422,"用户名已存在");
        }else {
            User user = new User();
            user.setAccount(account);
            user.setPassword(hashPassword("123456"));
            user.setUsername(username);
            user.setRole(role);
            user.setPhone(phone);
            userMapper.insert(user);
            return Results.Success();
        }

    }


}
