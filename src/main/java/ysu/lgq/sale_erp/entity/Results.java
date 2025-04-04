package ysu.lgq.sale_erp.entity;


import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

//成功类
//        200：操作成功。
//客户端错误
//        400：请求参数错误。
//        401：未登录或登录已过期。
//        403：没有权限访问。
//        404：资源不存在。
//        422：数据校验失败。
//服务器错误
//        500：服务器内部错误。
//        503：服务不可用。

@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
//@JsonInclude(JsonInclude.Include.NON_NULL)  // 忽略 null 字段
@ApiModel(description = "统一返回结果")
public class Results {

    @ApiModelProperty(value = "是否成功")
    private Boolean success;

    @ApiModelProperty(value = "返回码")
    private Integer code;

    @ApiModelProperty(value = "返回消息")
    private String message;

    @ApiModelProperty(value = "返回数据")
    private Object data;

    // 私有构造方法，确保通过工厂方法创建对象
    private Results(Boolean success, Integer code, String message, Object data) {
        this.success = success;
        this.code = code;
        this.message = message;
        this.data = data;
    }

    // 成功结果工厂方法
    public static Results Success() {
        return new Results(true, 200, "操作成功", null);
    }

    public static Results Success(Object data) {
        return new Results(true, 200, "操作成功", data);
    }

    // 错误结果工厂方法
    public static Results Error(String message) {
        return new Results(false, 404, message, null);
    }

    public static Results Error(Integer code, String message) {
        return new Results(false, code, message, null);
    }

}