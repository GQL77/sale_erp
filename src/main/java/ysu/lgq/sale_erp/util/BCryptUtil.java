package ysu.lgq.sale_erp.util;

import org.mindrot.jbcrypt.BCrypt;

public class BCryptUtil{
    /**
     * 生成一个加盐的 bcrypt 哈希
     *
     * @param password 原始密码
     * @return 加盐的 bcrypt 哈希
     */
    public static String hashPassword(String password) {
        // gensalt() 的参数是哈希的复杂度，默认为 10，可以根据需要调整
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    /**
     * 验证密码是否与哈希匹配
     *
     * @param password     原始密码
     * @param hashed       哈希后的密码
     * @return 如果匹配则返回 true，否则返回 false
     */
    public static boolean checkPassword(String password, String hashed) {

        return BCrypt.checkpw(password, hashed);
    }

    /**
     * 示例用法
     */
    public static void main(String[] args) {
        String password = "123456";

        // 哈希密码
        String hashedPassword = hashPassword(password);
        System.out.println("哈希后的密码: " + hashedPassword);

        // 验证密码
        boolean isValid = checkPassword("mySecurePassword123", hashedPassword);
        System.out.println("密码验证结果: " + isValid); // 应输出 true

        boolean isInvalid = checkPassword("wrongPassword", hashedPassword);
        System.out.println("错误密码验证结果: " + isInvalid); // 应输出 false
    }

}
