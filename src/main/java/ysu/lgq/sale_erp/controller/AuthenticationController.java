package ysu.lgq.sale_erp.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import ysu.lgq.sale_erp.entity.Results;
import ysu.lgq.sale_erp.service.IUserService;

import java.util.Map;



//register(): 用户注册。
//login(): 用户登录。
//logout(): 用户登出。//前端实现
//forgotPassword(): 密码重置请求。
//resetPassword(): 密码重置。
@RestController
@RequestMapping("")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class AuthenticationController {
    @Autowired
    private IUserService userService;

    @PostMapping("/login")
    public Results<String> login(@RequestBody Map<String, Object> request) {
        return userService.login((String)request.get("account"),(String)request.get("password"));
    }

    @PostMapping("/register")
    public Results<String> register(@RequestBody Map<String, Object> request) {
        String account = (String)request.get("account");
        String username = (String)request.get("username");
        int role =(int) request.get("role");
        String phone = (String)request.get("phone");
        return userService.register(account,username,role,phone);

    }

    @PostMapping("/forgotPassword")
    public Results<String> forgotPassword(@RequestBody Map<String, Object> request) {
//        String account = (String)request.get("account");
//        String password = (String)request.get("password");
//        String newPassword = (String)request.get("newPassword");
//        return userService.forgotPassword(account,password,newPassword);
        return Results.Error(503,"服务不可用");
    }

}