package ysu.lgq.sale_erp.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;
import javax.crypto.SecretKey;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.Map;


public class JwtUtils {
    private static final SecretKey SECRET_KEY;
    private static final long EXPIRE = 3600000 * 24L;

    static {
        // 从环境变量或硬编码加载密钥（示例硬编码）
        String secretKeyBase64 = "kH3DydThy98FSdpdOqG8P5bqyYxXelDbsweOCuw9iJE=";
        byte[] decodedKey = Base64.getDecoder().decode(secretKeyBase64);
        SECRET_KEY = Keys.hmacShaKeyFor(decodedKey);
    }

    private JwtUtils() {}

    /**
     * 生成 JWT
     */
    public static String generateJwt(Map<String, Object> claims) {
        return Jwts.builder()
                .setClaims(claims)
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRE))
                .signWith(SECRET_KEY, SignatureAlgorithm.HS256)
                .compact();
    }

    /**
     * 解析 JWT
     */
    public static Claims parseJwt(String jwt) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(SECRET_KEY)
                    .build()
                    .parseClaimsJws(jwt)
                    .getBody();
        } catch (JwtException e) {
            throw new RuntimeException("Invalid JWT token", e);
        }
    }

    /**
     * 验证 JWT 是否过期
     */
    public static boolean isJwtExpired(String jwt) {
        try {
            Claims claims = parseJwt(jwt);
            return claims.getExpiration().after(new Date());
        } catch (RuntimeException e) {
            return true; // 解析失败视为过期
        }
    }

    /**
     * 从 JWT 中提取权限列表
     */
    public static List<String> getAuthoritiesFromToken(String token) {
        Claims claims = parseJwt(token);
        return (List<String>) claims.get("permissions");
    }

    /**
     * 从 JWT 中提取角色
     */
    public static String getRoleFromToken(String token) {
        Claims claims = parseJwt(token);
        return (String) claims.get("role");
    }

    /**
     * 生成 Base64 编码的密钥（用于初始化配置文件）
     */
    public static String generateBase64Key() {
        SecretKey key = Keys.secretKeyFor(SignatureAlgorithm.HS256);
        return Base64.getEncoder().encodeToString(key.getEncoded());
    }

    // 示例用法
    public static void main(String[] args) {
        // 生成密钥并打印（用于初始化配置文件）
        String base64Key = generateBase64Key();
        System.out.println("签名密钥（Base64）: " + base64Key);
    }
}