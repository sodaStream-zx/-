package pri.myre.demo.controllers;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import pri.myre.demo.entity.SysRole;
import pri.myre.demo.services.TestService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

/**
 * @author Twilight
 * @desc
 * @createTime 2019-06-16-14:00
 */
@RestController
public class TestController {

    private static String[] name = new String[]{"张三", "李四", "王二", "血不染", "持之不败", "随心不欲"};
    @Autowired
    private TestService testService;

    @GetMapping(value = "/insert")
    public void myTest() {
        Long st = System.currentTimeMillis();
//        for (int i = 0; i < 1000; i++) {
        SysRole sysRole = new SysRole();
        sysRole.setRole_name(name[new Random().nextInt(6)]);
        sysRole.setEnabled(new Random().nextInt(2));
        sysRole.setCreate_time(LocalDateTime.now());
//        sysRole.setCreate_time(LocalDateTime.now().minusMonths(Long.valueOf(i)));
        sysRole.setCreate_by(new Random().nextLong());
        testService.insertOne(sysRole);
//        }
        System.out.println((System.currentTimeMillis() - st));
    }

    @GetMapping(value = "/find")
    public String list(Integer page, Integer size) {
        List<SysRole> sysroles = testService.sysroles((page - 1) * size, size);
        return JSON.toJSONString(sysroles, SerializerFeature.PrettyFormat);
    }
}
