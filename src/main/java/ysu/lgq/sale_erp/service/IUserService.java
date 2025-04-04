package ysu.lgq.sale_erp.service;


import ysu.lgq.sale_erp.entity.Results;
import ysu.lgq.sale_erp.entity.User;
import com.baomidou.mybatisplus.extension.service.IService;


/**
 * <p>
 *  服务类
 * </p>
 *
 * @author lgq
 * @since 2025-02-08
 */
public interface IUserService extends IService<User> {

    Results login(String account, String password);
    Results addUser(User user);
    Results updateUser(User user);
}
