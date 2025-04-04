package ysu.lgq.sale_erp.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import ysu.lgq.sale_erp.entity.Results;
import ysu.lgq.sale_erp.entity.User;
import ysu.lgq.sale_erp.mapper.UserMapper;
import ysu.lgq.sale_erp.service.IRoleService;
import ysu.lgq.sale_erp.service.IUserService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import ysu.lgq.sale_erp.util.JwtUtils;

import java.util.*;
import java.util.stream.Collectors;

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
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements IUserService{
    private final UserMapper userMapper;
    private final IRoleService roleService;
    private final AuthService authService;
    private final UserDetailsServiceImpl userDetailsService;

    // 使用构造器注入
    public UserServiceImpl(UserMapper userMapper, IRoleService roleService, AuthService authService, UserDetailsServiceImpl userDetailsService) {
        this.userMapper = userMapper;
        this.roleService = roleService;
        this.authService = authService;
        this.userDetailsService = userDetailsService;
    }


    /**
     * 用户登录业务逻辑
     */
    @Override
    public Results login(String account, String password) {
        System.out.println("输入account:" + account + " password:" + password + "\n");

        User user = userMapper.selectOne(new QueryWrapper<User>().eq("account", account));
        //  检查用户状态
        if (user == null) return Results.Error(400, "用户名不存在");
        if ("禁用".equals(user.getStatus())) return Results.Error(403, "账号已禁用");
        if ("冻结".equals(user.getStatus())) return Results.Error(403, "账号已冻结");
        if (!checkPassword(password, user.getPassword())) return Results.Error(400, "用户名或密码错误");
        // 生成 JWT（包含角色和权限）
        UserDetails userDetails = userDetailsService.loadUserByUsername(account);
        Map<String, Object> claims = new HashMap<>();
        claims.put("sub", user.getAccount());
        claims.put("username", user.getUsername());
        claims.put("role", roleService.getById(user.getRole()).getName());
        claims.put("permissions", userDetails.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList()));
        String jwt = JwtUtils.generateJwt(claims);
        System.out.println("jwt令牌：" + jwt + "\n");
        return Results.Success(jwt);
    }



    @Override
    public Results addUser(User user) {
        if (userMapper.selectOne(new QueryWrapper<User>().eq("account",user.getAccount())) != null){
            return Results.Error(422,"用户名已存在");
        }else {
            user.setPassword(hashPassword(user.getPassword()));
            userMapper.insert(user);
            return Results.Success();
        }

    }

    @Override
    public Results updateUser(User user) {
        User oldUser = userMapper.selectOne(new QueryWrapper<User>().eq("account",user.getAccount()));
        if (oldUser != null){
            // 更新密码
            if (user.getPassword() != null) {oldUser.setPassword(hashPassword(user.getPassword()));}
            // 更新用户名
            if (user.getUsername() != null) {oldUser.setUsername(user.getUsername());}
            // 更新角色
            if (user.getRole() != null) {oldUser.setRole(user.getRole());}
            // 更新部门
            if (user.getBranch() != null) {oldUser.setBranch(user.getBranch());}
            // 更新邮箱
            if (user.getEmail() != null) {oldUser.setEmail(user.getEmail());}
            // 更新电话
            if (user.getPhone() != null) {oldUser.setPhone(user.getPhone());}
            // 更新状态
            if (user.getStatus() != null) {oldUser.setStatus(user.getStatus());}
            // 更新用户信息
            userMapper.update(oldUser, new QueryWrapper<User>().eq("account",user.getAccount()));
            authService.clearRolePermissionsCache(oldUser.getRole());
            return Results.Success();
        }else {
            return Results.Error("用户名不存在");
        }
    }

}
