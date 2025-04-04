package ysu.lgq.sale_erp.service.impl;


import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
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
    private static final String PERMISSION_CACHE_NAME = "role_permissions";

    private final IRolePermissionService rolePermissionService;
    private final IPermissionService permissionService;

    public AuthService(IRolePermissionService rolePermissionService, IPermissionService permissionService) {

        this.rolePermissionService = rolePermissionService;
        this.permissionService = permissionService;
    }

    /**
    * 获取用户权限列表
    */
    @Cacheable(value = PERMISSION_CACHE_NAME, key = "#roleId", unless = "#result.isEmpty()")
    public HashMap<Object, String> QueryRolePermission(int roleId) {
        //System.out.println("方法被调用，roleId: " + roleId);

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

    // 添加缓存清理方法（当权限变更时调用）
    @CacheEvict(value = PERMISSION_CACHE_NAME, key = "#roleId")
    public void clearRolePermissionsCache(Integer roleId) {
        // 空方法，通过注解触发缓存清理
    }

}