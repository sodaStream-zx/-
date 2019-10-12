package pri.myre.demo.mappers;

import org.apache.ibatis.annotations.*;
import pri.myre.demo.entity.SysRole;
import pri.myre.demo.redisCache.RedisCache;

import java.util.List;

/**
 * @author Twilight
 * @desc
 * @createTime 2019-06-16-14:00
 */
@Mapper
@CacheNamespace(implementation = RedisCache.class,flushInterval = 10000)
public interface TestMapper {

    @Insert(value = "insert into sys_role (role_name,enabled,create_time,create_by) values (" +
            "#{u.role_name},#{u.enabled},#{u.create_time},#{u.create_by}" +
            ")")
    Integer insert(@Param(value = "u") SysRole u);

    @Select(value = "select * from sys_role limit #{offset},#{size}")
    List<SysRole> listOfSysRoles(@Param(value = "offset") Integer offset, @Param(value = "size") Integer size);
}
