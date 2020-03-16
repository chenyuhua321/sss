package com.lagou.edu.mvcframework.annotations;

import java.lang.annotation.*;

/**
 * @author Chenyuhua
 * @date 2020/3/15 16:16
 */
@Documented
@Target({ElementType.TYPE,ElementType.METHOD})
@Retention(RetentionPolicy.RUNTIME)
public @interface LagouSecurity {
    String[] value() default "";
}
