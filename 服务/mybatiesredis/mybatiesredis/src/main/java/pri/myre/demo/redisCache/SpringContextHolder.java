package pri.myre.demo.redisCache;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.util.StringUtils;

/**
 * @author Twilight
 * @desc
 * @createTime 2019-06-18-23:18
 */
public class SpringContextHolder implements ApplicationContextAware {
    private static final Logger log = LoggerFactory.getLogger(SpringContextHolder.class);
    private static ApplicationContext context;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        context = applicationContext;
    }

    /**
     * desc: 从容器中获取bean
     *
     * @Return:Bean
     **/
    public static <T> T getBean(String name, Class<T> aClass) {
        T obj = null;
        if (StringUtils.isEmpty(String.valueOf(aClass))) {
            log.error("不支持按beanName获取bean");
            return null;
        }
        try {
            if (StringUtils.isEmpty(name)) {
                obj = context.getBean(aClass);
            } else {
                obj = context.getBean(name, aClass);
            }
            return obj;
        } catch (Exception e) {
            log.error("未取得bean:名：" + name + "，类名 ：" + aClass.getSimpleName());
            log.error("exception:" + e.getCause() + " :: message:" + e.getMessage());
            return null;
        }
    }
}
