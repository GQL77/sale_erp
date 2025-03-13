package ysu.lgq.sale_erp.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.springframework.web.bind.annotation.RequestBody;
import ysu.lgq.sale_erp.entity.Results;
import ysu.lgq.sale_erp.entity.User;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.Map;

import static ysu.lgq.sale_erp.util.BCryptUtil.hashPassword;

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
    Results register(String account, String username, int role, String phone);
}
