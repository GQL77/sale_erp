package ysu.lgq.sale_erp.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import ysu.lgq.sale_erp.entity.Results;

import java.io.IOException;

public class CustomAccessDeniedHandler implements AccessDeniedHandler {
    private final ObjectMapper objectMapper;

    // 通过构造器注入 ObjectMapper
    public CustomAccessDeniedHandler(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
    }
    @Override
    public void handle(
            HttpServletRequest request,
            HttpServletResponse response,
            AccessDeniedException accessDeniedException
    ) throws IOException {
        // 设置响应状态码为 403
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        // 返回自定义的 Results 对象
        response.setContentType("application/json;charset=UTF-8");
        Results result = Results.Error(403, "权限不足，请联系管理员");
        response.getWriter().write(objectMapper.writeValueAsString(result));
    }
}