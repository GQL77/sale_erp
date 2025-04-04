package ysu.lgq.sale_erp.controller;

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
public class AuthenticationController {

    private final IUserService userService;


    public AuthenticationController(IUserService userService) {
        this.userService = userService;
    }


    @PostMapping("/login")
    public Results login(@RequestBody Map<String, Object> request) {
        return userService.login((String)request.get("account"),(String)request.get("password"));
    }



}