package ysu.lgq.sale_erp.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.Map;

public class JwtUtils {


    // 使用安全的密钥生成方法生成密钥
    private static final SecretKey SECRET_KEY =  Keys.secretKeyFor(SignatureAlgorithm.HS256);
    private static final long EXPIRE = 3600000 * 24L; // 24小时

    private JwtUtils() {}

    /**
     * 生成 JWT 字符串
     *
     * @param claims 自定义声明
     * @return JWT 字符串
     */
    public static String generateJwt(Map<String, Object> claims) {
        String jwt = Jwts.builder()
                .setClaims(claims) // 设置自定义声明
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRE)) // 设置过期时间
                .signWith(SignatureAlgorithm.HS256, SECRET_KEY) // 签名
                .compact(); // 压缩为字符串
        return jwt;
    }

    /**
     * 解析 JWT 并返回声明
     *
     * @param jwt JWT 字符串
     * @return 声明对象
     * @throws RuntimeException 如果 JWT 无效或签名验证失败
     */
    public static Claims parseJwt(String jwt) {
        try {
            Claims claims = Jwts.parserBuilder()
                    .setSigningKey(SECRET_KEY) // 设置签名密钥
                    .build()
                    .parseClaimsJws(jwt) // 解析 JWS
                    .getBody(); // 获取声明
            return claims;
        } catch (JwtException e) {
            // 处理解析异常，例如签名验证失败
            throw new RuntimeException("Invalid JWT token", e);
        }
    }

    /**
     * 验证 JWT 是否过期
     *
     * @param jwt JWT 字符串
     * @return 如果未过期则返回 true，否则返回 false
     */

    public static boolean isJwtExpired(String jwt) {
        try {
            Claims claims = parseJwt(jwt);
            Date expiration = claims.getExpiration();
            return expiration.after(new Date());
        } catch (RuntimeException e) {
            return true; // 如果解析失败，认为 JWT 已过期或无效
        }
    }

    public static String getSecretKey(){
        return SECRET_KEY.toString();
    }

    // 示例用法
    public static void main(String[] args) {
        System.out.println("JwtUtils.main" + "----当前签名密钥："+ SECRET_KEY+ " 请谨慎保存");
        Map<String, Object> claims = Map.of(
                "sub"  , "1234567890",
                "name" , "John Doe"  ,
                "admin", true
        );

        String jwt = generateJwt(claims);
        System.out.println("生成的 JWT: " + jwt);

        Claims parsedClaims = parseJwt(jwt);
        System.out.println("Subject: " + parsedClaims.getSubject());
        System.out.println("Name: "    + parsedClaims.get("name"));
        System.out.println("Admin: "   + parsedClaims.get("admin"));
        System.out.println("Expiration: " + parsedClaims.getExpiration());

        boolean isExpired = isJwtExpired(jwt);
        System.out.println("JWT 是否过期: " + isExpired);
    }
}