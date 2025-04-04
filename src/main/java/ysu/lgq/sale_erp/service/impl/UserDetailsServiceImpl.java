package ysu.lgq.sale_erp.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;
import ysu.lgq.sale_erp.entity.User;
import ysu.lgq.sale_erp.mapper.UserMapper;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    private final UserMapper userMapper;
    private final AuthService authService;

    public UserDetailsServiceImpl(UserMapper userMapper, AuthService authService) {
        this.userMapper = userMapper;
        this.authService = authService;
    }

    @Override
    public UserDetails loadUserByUsername(String account) {

        User user = userMapper.selectOne(new QueryWrapper<User>().eq("account", account));

        Map<Object, String> permissions = authService.QueryRolePermission(user.getRole());
        List<GrantedAuthority> authorities = permissions.values().stream()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());

        return new org.springframework.security.core.userdetails.User(
                user.getAccount(),
                user.getPassword(),
                authorities
        );
    }
}