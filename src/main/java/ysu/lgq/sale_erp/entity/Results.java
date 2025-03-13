package ysu.lgq.sale_erp.entity;


import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

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
@ApiModel(description = "统一返回结果")
public class Results<T> {

    @ApiModelProperty(value = "是否成功")
    private Boolean success;

    @ApiModelProperty(value = "返回码")
    private Integer code;

    @ApiModelProperty(value = "返回消息")
    private String message;

    @ApiModelProperty(value = "返回数据")
    private T data;


    public static <T> Results<T> Success() {
        Results<T> result = new Results<>();
        result.setSuccess(true);
        result.setCode(200);
        result.setMessage("操作成功");
        return result;
    }
    public static <T> Results<T> Success(T data) {
        Results<T> result = new Results<>();
        result.setSuccess(true);
        result.setCode(200);
        result.setMessage("操作成功");
        result.setData(data);
        return result;
    }


    public static <T> Results<T> Error(Integer code, String message) {
        Results<T> result = new Results<>();
        result.setSuccess(false);
        result.setCode(code);
        result.setMessage(message);
        return result;
    }

}