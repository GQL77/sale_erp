package ysu.lgq.sale_erp.service.impl;


import org.springframework.stereotype.Service;
import ysu.lgq.sale_erp.entity.Permission;
import ysu.lgq.sale_erp.entity.RolePermission;
import ysu.lgq.sale_erp.service.IPermissionService;
import ysu.lgq.sale_erp.service.IRolePermissionService;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AuthService {

    private final IRolePermissionService rolePermissionService;
    private final IPermissionService permissionService;

    public AuthService(IRolePermissionService rolePermissionService, IPermissionService permissionService) {

        this.rolePermissionService = rolePermissionService;
        this.permissionService = permissionService;
    }

/**
 * 获取用户权限列表
 */
    public HashMap<Object, String> QueryRolePermission(int roleId) {

        //获得Permission.id的List
        Map<String,Object> queryCondition = new HashMap<>();
        queryCondition.put("role_id", roleId);
        List<RolePermission> rolePermissions = rolePermissionService.listByMap(queryCondition);
        List<Integer> permissionIds = rolePermissions.stream()
            .map(RolePermission::getPermissionId)
            .collect(Collectors.toList());

        if (permissionIds.isEmpty()) {
            return new HashMap<>(); // 返回空映射，避免空指针异常
        }

        //通过list获得permission.id和permission.name的数组
        List<Permission> permissions = permissionService.listByIds(permissionIds);
        HashMap<Object, String> result = new HashMap<>();
        for (Permission permission : permissions) {

            result.put( permission.getId() ,permission.getName());
        }
        return result;
    }

}