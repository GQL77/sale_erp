package ysu.lgq.sale_erp.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import ysu.lgq.sale_erp.entity.Results;
import ysu.lgq.sale_erp.entity.User;
import ysu.lgq.sale_erp.service.IUserService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

//import javax.servlet.http.HttpServletRequest;


@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/userController")
public class UserController {

    private final IUserService userService;
    public UserController(IUserService userService) {
        this.userService = userService;
    }


    @GetMapping("/selectAll")
    @PreAuthorize("hasAuthority('USER_OPER')")
    public Results selectAll() {

        System.out.println("查询结果：");
        List<User> userList = userService.list();
        Map<String, Object> response = new HashMap<>();
        response.put("users", userList);
        System.out.println("查询结果：" + Results.Success(response) + "\n");
        return Results.Success(response);
    }

    @PostMapping("/addUser")
    @PreAuthorize("hasAuthority('USER_OPER')")
    public Results addUser(@RequestBody Map<String, Object> request){
        User user = new User();
        user.setAccount((String)request.get("account"))
                .setUsername((String)request.get("username"))
                .setRole((int)request.get("role"))
                .setBranch((String)request.get("branch"))
                .setPhone((String)request.get("phone"));
        return userService.addUser(user);
    }
    @DeleteMapping("/deleteUser")
    @PreAuthorize("hasAuthority('USER_OPER')")
    public Results deleteUser(@RequestBody Map<String, Object> request){
        User user = new User();
        user.setAccount((String) request.get("account"))
                .setStatus("禁用");
        return userService.updateUser(user);
    }

    @PostMapping("/updateUser")
    @PreAuthorize("hasAuthority('USER_OPER')")
    public Results updateUser(@RequestBody Map<String, Object> request){
        User user = new User();
        user.setAccount((String)request.get("account"))
                .setUsername((String)request.get("username"))
                .setPassword((String) request.get("password"))
                .setRole((int)request.get("role"))
                .setBranch((String)request.get("branch"))
                .setPhone((String)request.get("phone"))
                .setStatus((String)request.get("status"))
                .setEmail((String)request.get("email"));
        return userService.updateUser( user);
    }

    @PostMapping("/userUpdate")
    public Results update(@RequestBody Map<String, Object> request){
        User user = new User();
        user.setAccount((String)request.get("account"))
                .setUsername((String)request.get("username"))
                .setPassword((String) request.get("password"))
                .setPhone((String)request.get("phone"))
                .setEmail((String)request.get("email"));
        return userService.updateUser( user);
    }


}
