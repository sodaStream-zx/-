package pri.myre.demo.services;

import org.springframework.stereotype.Service;
import pri.myre.demo.entity.SysRole;
import pri.myre.demo.mappers.TestMapper;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Twilight
 * @desc
 * @createTime 2019-06-16-14:00
 */
@Service
public class TestService {
    @Resource
    private TestMapper testMapper;

    public Integer insertOne(SysRole sysRole) {
        return testMapper.insert(sysRole);
    }

    public List<SysRole> sysroles(Integer offset, Integer size) {
        List<SysRole> sysRoles = testMapper.listOfSysRoles(offset, size);
        return sysRoles;
    }
}
