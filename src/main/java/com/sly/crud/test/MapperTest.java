package com.sly.crud.test;

import com.sly.crud.bean.Department;
import com.sly.crud.bean.Employee;
import com.sly.crud.bean.EmployeeExample;
import com.sly.crud.dao.DepartmentMapper;
import com.sly.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;
import java.util.SortedMap;
import java.util.UUID;

/**
 * 测试dao
 * @author sly
 * @create 2021-05-02  9:20
 *
 * 推荐spring的项目就可以使用spring的单元测试,可以自动注入需要的组件
 * 1.导入springtest
 * 2.ContextConfiguration指定配置文件位置
 * 3.直接auto wire想用的组件
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void testCRUD() {
        //ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext");
        //DepartmentMapper d = ioc.getBean(DepartmentMapper.class);

        //System.out.println(departmentMapper);

    //    插入部门
    //    departmentMapper.insertSelective(new Department(null,"开发部"));
    //    departmentMapper.insertSelective(new Department(null,"测试部"));

    //员工
    //    employeeMapper.insertSelective(new Employee(null,"jerry","M","1232@qq.com",1));

    //    批量插入员工
    //    for () {
    //      这个不是批量 多次执行
    //    }

        //批量  配置能批量的SQL session
        //EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        //for (int i = 0; i < 1000; i++) {
        //    String uuid = UUID.randomUUID().toString().substring(0, 5) + i;
        //    mapper.insertSelective(new Employee(null, uuid, "M", uuid + "@sly.com",1));
        //}
        //System.out.println("批量完成");

        List<Employee> employees = employeeMapper.selectByExample(new EmployeeExample());
        for (Employee employee : employees) {
            System.out.println(employee);
        }

    }
}
