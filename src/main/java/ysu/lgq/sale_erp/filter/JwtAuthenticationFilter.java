package ysu.lgq.sale_erp.filter;

import io.jsonwebtoken.Claims;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;
import ysu.lgq.sale_erp.util.JwtUtils;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
@Configuration
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        // 跳过无需 JWT 的路径（如登录接口）
        String requestURI = request.getRequestURI();
        if ("/login".equals(requestURI)) {
            filterChain.doFilter(request, response);
            return;
        }

        String authHeader = request.getHeader("Authorization");
        if (authHeader == null ) {//|| !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        //String jwt = authHeader.substring(7);
        //logger.info("JWT: " + jwt);
        try {
            Claims claims = JwtUtils.parseJwt(authHeader);
            String username = claims.getSubject();//sub
            System.out.println("JWT account: " + username);
            System.out.println("JWT Claims: " + claims + "\n");

            if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                // 1. 从 JWT 中提取权限
                List<String> permissions = (List<String>) claims.get("permissions");
                List<GrantedAuthority> authorities = permissions.stream()
                        .map(SimpleGrantedAuthority::new)
                        .collect(Collectors.toList());

                // 2. 直接构建认证对象
                UsernamePasswordAuthenticationToken authenticationToken =
                        new UsernamePasswordAuthenticationToken(
                                username,
                                null,
                                authorities
                        );
                authenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authenticationToken);
            }
        } catch (Exception e) {
            logger.error("JWT 解析失败: " + e.getMessage());
        }

        filterChain.doFilter(request, response);
    }
}