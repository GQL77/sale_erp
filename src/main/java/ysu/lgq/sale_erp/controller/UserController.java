package ysu.lgq.sale_erp.controller;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

//import javax.servlet.http.HttpServletRequest;


@RestController
@CrossOrigin(origins = "*")
@RequestMapping("/UserController")
public class UserController {

//    @Autowired
//    private UserService userService;
//    @RequestMapping("/addUser")
//    public Results addUser(HttpServletRequest Request, @RequestBody Map<String, Object> request) {
//        System.out.println("访问localhost:9000/UserController/addUser！");
//        int id = 0;
//        try{
//            String jwt = Request.getHeader("token");
//            System.out.println("解析jwt="+jwt);
//            Map<String, Object> claim =JwtUtils.ParseJwt(jwt);
//            id = (int) claim.get("id");
//            System.out.println("id :"+id);
//
//        }catch (Exception e){
//
//            return Results.Error("token过期，请重新登录！");
//        }
//        User user = new User();
//        //输入
//        user.setUserAccount((String)request.get("account"));
//        User u=userService.findUserByAccount(user.getUserAccount());
//        if(u!=null){
//            return Results.Error("该账号已被注册！");
//        }
//
//        user.setUserName((String)request.get("name"));
//        user.setUserEmail((String)request.get("email"));
//        //自动生成
//        user.setUserAuthority("员工");
//        Map<String, String> map = userService.encryptPasswords("123456");//新用户默认密码123456
//        String salt =map.get("salt");
//        String password =map.get("password");
//        user.setUserPassword(password);
//        user.setUserSalt(salt);
//        System.out.println("预览插入新用户："+user);
//        if(userService.insert(user)){
//            return Results.Success("添加成功！");
//        }else return Results.Error("添加失败！");
//    }
//    @RequestMapping("/deleteUser")
//    public Results deleteUser(HttpServletRequest Request, @RequestBody Map<String, Object> request) {
//        System.out.println("访问localhost:9000/UserController/deleteUser！");
//        int id = 0;
//        try{
//            String jwt = Request.getHeader("token");
//            System.out.println("解析jwt="+jwt);
//            Map<String, Object> claim =JwtUtils.ParseJwt(jwt);
//            id = (int) claim.get("id");
//            System.out.println("id :"+id);
//
//        }catch (Exception e){
//
//            return Results.Error("token过期，请重新登录！");
//        }
//        User u=userService.findByPrimaryKey((Integer)request.get("id"));
//        if(u==null){
//            return Results.Error("不存在该用户！");
//        }
//
//        if(userService.delete(u)){
//            return Results.Success("删除成功！");
//        }else return Results.Error("删除失败！");
//    }
//    @RequestMapping("/userUpdate")
//    public Results UserUpdate(HttpServletRequest Request, @RequestBody Map<String, Object> request) {
//        System.out.println("访问localhost:9000/UserController/userUpdate！");
//        int id=0;
//        try{
//            String jwt = Request.getHeader("token");
//            System.out.println("解析jwt="+jwt);
//            Map<String, Object> claim =JwtUtils.ParseJwt(jwt);
//            id = (int) claim.get("id");
//            System.out.println("id :"+id);
//        }catch (Exception e){
//
//            return Results.Error("token过期，请重新登录！");
//        }
//        String oldpassword = (String)request.get("oldpassword");
//
//        User user=userService.findByPrimaryKey(id);
//        boolean result = userService.cheakUserPassword(user,oldpassword);
//        System.out.println("原密码验证结果："+result);
//        if(result){
//            String name = (String)request.get("name");
//            String account = (String)request.get("account");
//            String email = (String)request.get("email");
//            String newpassword = (String)request.get("newpassword");
//
//            Map<String, String> map = userService.encryptPasswords(newpassword);
//            String salt =map.get("salt");
//            String password =map.get("password");
//
//            user.setUserName(name);
//            user.setUserAccount(account);
//            user.setUserEmail(email);
//            user.setUserPassword(password);
//            user.setUserSalt(salt);
//
//            System.out.println(user);
//            userService.update(user);
//            System.out.println(userService.findByPrimaryKey(id));
//            return Results.Success("信息更改成功！");
//        }else return Results.Error("原密码错误！");
//    }
//
//    @RequestMapping("/resetPassword")
//    public Results resetPassword(HttpServletRequest Request, @RequestBody Map<String, Object> request) {
//        System.out.println("访问localhost:9000/UserController/resetPassword！");
//        int id = 0;
//        try{
//            String jwt = Request.getHeader("token");
//            System.out.println("解析jwt="+jwt);
//            Map<String, Object> claim =JwtUtils.ParseJwt(jwt);
//            id = (int) claim.get("id");
//            System.out.println("id :"+id);
//
//        }catch (Exception e){
//
//            return Results.Error("token过期，请重新登录！");
//        }
//        User u=userService.findByPrimaryKey((Integer)request.get("id"));
//        if(u==null){
//            return Results.Error("不存在该用户！");
//        }
//
//        User user = new User();
//        user.setUserId((Integer)request.get("id"));
//        Map<String, String> map = userService.encryptPasswords("123456");
//        String salt =map.get("salt");
//        String password =map.get("password");
//        user.setUserPassword(password);
//        user.setUserSalt(salt);
//        userService.update(user);
//        return Results.Success("密码重置成功！");
//    }
//
//    @RequestMapping("/selectUser")
//    public Results selectUser(HttpServletRequest Request, @RequestBody Map<String, Object> request) {
//        System.out.println("访问localhost:9000/UserController/selectUser！");
//        int id = 0;
//        try{
//            String jwt = Request.getHeader("token");
//            System.out.println("解析jwt="+jwt);
//            Map<String, Object> claim =JwtUtils.ParseJwt(jwt);
//            id = (int) claim.get("id");
//            System.out.println("id :"+id);
//
//        }catch (Exception e){
//
//            return Results.Error("token过期，请重新登录！");
//        }
//        Integer userId=null;
//        if(request.get("id")!=null){
//              userId= Integer.valueOf((String) request.get("id"));
//        }
////        Integer userId= Integer.parseInt((String) request.get("id"));
//        String userName=(String) request.get("name");
//        String userAccount=(String) request.get("account");
//        String userEmail = (String) request.get("email");
//
//        User user =new User();
//        user.setUserId(userId);
//        user.setUserName(userName);
//        user.setUserAccount(userAccount);
//        user.setUserEmail(userEmail);
//        user.setUserAuthority("员工");
//        System.out.println("搜索条件："+user);
//        Map<String,Object> map = new HashMap<>();
//
//        List<User> list = userService.findUsersByUser(user);
//        map.put("staffList", list);
//        System.out.println(map);
//        return Results.Success(map);
//
//
//    }
//


}
