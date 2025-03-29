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

    Results<String> login(String account, String password);
    Results<String> register(String account, String username, int role, String phone);
}
