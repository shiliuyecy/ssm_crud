package com.sly.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.sly.crud.bean.Employee;
import com.sly.crud.bean.Msg;
import com.sly.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author sly
 * @create 2021-05-02  16:38
 * 处理员工CRUD请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;



    /**
     * 单个 批量二合一
     * 批量删除:1-2-3-4
     * 单个删除:1
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteEmp(@PathVariable("ids") String ids) {
        if (ids.contains("-")) {
            //批量删除
            List<Integer> delId = new ArrayList<>();
            String[] strIds = ids.split("-");
            //转成数组
            for (String strId : strIds) {
                delId.add(Integer.parseInt(strId));
            }
            employeeService.deleteBatch(delId);
            return Msg.success();
        } else {
            //单个删除
            int id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
            return Msg.success();
        }
    }

    /**
     * 员工更新方法
     * @param employee
     * @return
     */
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg saveEmp(Employee employee) {
        employeeService.updateEmp(employee);
        return Msg.success();
    }


    /**
     * 根据ID查询员工
     * @param id
     * @return
     */
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id) {
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp", employee);
    }


    /**
     * 检查用户名 是否可用
     * @param empName
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/checkuser")
    public Msg checkuser(@RequestParam("empName") String empName) {
        //先判断用户名是否合法的表达式
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regx)) {
            return Msg.fail().add("va_msg", "用户名可以是2-5位中文或者6-16位数字字母_ -");
        }
        //数据库用户名重复校验
        boolean b = employeeService.checkUser(empName);
        if (b) {
            return Msg.success().add("va_msg", "用户名可用");
        } else {
            return Msg.fail().add("va_msg", "用户名不可用");
        }
    }

    /**
     * 员工保存
     * 1.支持JSR303校验
     * 2.导入hibernate-validator
     * @return
     *
     */
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Msg save(@Valid Employee employee, BindingResult result) {//自动封装对象
        if (result.hasErrors()) {
            //校验失败,应该返回失败,在模态框中显示校验失败的错误信息
            List<FieldError> fieldErrors = result.getFieldErrors();
            Map<String, Object> map = new HashMap<>();
            for (FieldError error : fieldErrors) {
                map.put(error.getField(), error.getDefaultMessage());
            }
            return Msg.fail().add("errorFields", map);
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }


    /**
     * 导入Jackson 包
     * @param pn
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        //不是分页查询
        //引入pagehelp插件 , 插入页码 条目
        PageHelper.startPage(pn, 5);
        //start Page 紧跟的查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        //用pageinfo 包装查询后的结果

        //封装了详细的分页信息  连续显示的页数
        PageInfo<Employee> pageInfo = new PageInfo<>(emps, 5);
        return Msg.success().add("pageInfo", pageInfo);
    }




    /**
     * 查询员工数据(分页查询)
     * @return
     */
    //@RequestMapping(value = "/emps")
    public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
        //不是分页查询
        //引入pagehelp插件 , 插入页码 条目
        PageHelper.startPage(pn, 5);
        //start Page 紧跟的查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        //用pageinfo 包装查询后的结果

        //封装了详细的分页信息  连续显示的页数
        PageInfo<Employee> pageInfo = new PageInfo<>(emps, 5);

        model.addAttribute("pageInfo", pageInfo);
        return "list";
    }
}
