package ysu.lgq.sale_erp;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.github.pagehelper.autoconfigure.PageHelperAutoConfiguration;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.scheduling.annotation.EnableScheduling;

import ysu.lgq.sale_erp.util.JwtUtils;

/**
 * 
* @Title: App
* @Description:
* 主程序入口 
* @Version:1.0.0  

 */
@EnableCaching
@EnableScheduling
@SpringBootApplication(exclude = PageHelperAutoConfiguration.class)
@MapperScan("ysu.lgq.sale_erp.mapper")
public class App 
{
    public static void main( String[] args )
    {

		SpringApplication.run(App.class, args);
        System.out.println("程序正在运行...");

    }
}
