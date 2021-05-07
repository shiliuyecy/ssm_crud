<%@ page contentType="text/html;charset=UTF-8" language="java"  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>员工列表</title>
    <%
        //http://localhost:3306/ssm  映射到webapp
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>

    <%--    /是以服务器为根路径 http://localhost:3306--%>
    <%--    引入jQuery--%>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-1.12.4.min.js"></script>

    <%--    引入样式--%>
    <link href="${APP_PATH}/static/bootstrap-3.4.1-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.4.1-dist/js/bootstrap.min.js"></script>

</head>
<body>

<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_update_input" placeholder="email@sly.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId" id="dept_update_select">
                            </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="email" name="email" class="form-control" id="email_add_input" placeholder="email@sly.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <select class="form-control" name="dId" id="dept_add_select">
                            </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>


    <%--搭建显示页面--%>
    <div class="container">
        <%--标题行--%>
        <div class="row">
            <div class="col-md-12">
                <h1>SSM_CRUD</h1>
            </div>
        </div>
        <%--按钮行--%>
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
                <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
            </div>
        </div>
        <%--表格行--%>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover" id="emps_table">
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="check_all"/>
                            </th>
                            <th>#</th>
                            <th>empName</th>
                            <th>gender</th>
                            <th>email</th>
                            <th>deptName</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
        <%--分页--%>
        <div class="row">
            <%--分页文字信息--%>
            <div class="col-md-6" id="page_info_area"></div>
            <%--分页条信息--%>
            <div class="col-md-6" id="page_nav_area" >

            </div>
        </div>
    </div>


    <script type="text/javascript">

        //全局总记录数  记录当前页
        var totalRecord, currentPage;
        //1.页面加载完成之后,直接发送一个Ajax 请求,要到分页数据
        $(function () {
            //去首页
            to_page(1);
        });

        //跳转指定页码的页面
        function to_page(pn) {
            $.ajax({
                url:"${APP_PATH}/emps",
                data:"pn=" + pn,
                type:"get",
                success:function (result) {
                    // console.log(result);
                    // 1.解析并显示数据
                    build_emps_table(result);
                    // 2.解析并显示分页信息
                    build_page_info(result);
                    // 3.解析显示分页条
                    build_page_nav(result);
                }
            });
        }
        
        //解析表格信息
        function build_emps_table(result) {
            //构建前 清空
            $("#emps_table tbody").empty();

            var emps = result.extend.pageInfo.list;
            $.each(emps, function (index, item) {
                var checkBoxTd = $("<td></td>").append($("<input type='checkbox' class='check_item'/>"));
                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
                var emailTd = $("<td></td>").append(item.email);
                var deptNameTd = $("<td></td>").append(item.department.deptName);
                var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                                .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                                .append("编辑");
                //为编辑按钮添加自定义属性来表示当前员工id
                editBtn.attr("edit-id", item.empId);
                var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                                .append("删除");
                //为删除按钮添加自定义属性来表示当前员工id
                delBtn.attr("del-id", item.empId);
                var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
                //append方法执行完成以后还是返回原来的元素
                $("<tr></tr>").append(checkBoxTd).append(empIdTd).append(empNameTd)
                    .append(genderTd).append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    .appendTo("#emps_table tbody")
            })
        }
        
        //解析分页信息
        function build_page_info(result) {
            $("#page_info_area").empty();

            $("#page_info_area").append("当前第"+ result.extend.pageInfo.pageNum +
                "页,总共"+ result.extend.pageInfo.pages +"页,总共"+ result.extend.pageInfo.total +"条记录")
            totalRecord = result.extend.pageInfo.total;
            currentPage = result.extend.pageInfo.pageNum;
        }
        

        //解析分页条
        function build_page_nav(result) {
            $("#page_nav_area").empty();

            var ul = $("<ul></ul>").addClass("pagination")

            //构建元素
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
            //第一页时 首页 前一页不能点击,
            if (result.extend.pageInfo.hasPreviousPage == false) {
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            } else {
                // 为元素添加单击事件
                firstPageLi.click(function () {
                    to_page(1);
                });
                prePageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum - 1);
                });
            }
            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
            var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
            // 最后一页时,末页 下一页不能点击
            if (result.extend.pageInfo.hasNextPage == false) {
                lastPageLi.addClass("disabled");
                nextPageLi.addClass("disabled");
            } else {
                // 为元素添加单击事件
                nextPageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum + 1);
                });
                lastPageLi.click(function () {
                    to_page(result.extend.pageInfo.pages);
                });
            }

            //添加首页和前一页的提示
            ul.append(firstPageLi).append(prePageLi);
            //不传index item 用this也能拿出
            //遍历给UL中添加页码提示
            $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {

                var numLi = $("<li></li>").append($("<a></a>").append(item));
                if (result.extend.pageInfo.pageNum == item) {
                    numLi.addClass("active");
                }
                numLi.click(function () {
                    to_page(item)
                });
                ul.append(numLi);
            });
            //添加下一页和末页
            ul.append(nextPageLi).append(lastPageLi);
            //把ul加入到nav中
            var navEle = $("<nav></nav>").append(ul);
            navEle.appendTo("#page_nav_area");
        }
        
        
        //清空表单样式 内容
        function reset_form(ele) {
            $(ele)[0].reset();
            $(ele).find("*").removeClass("has-success has-error");
            $(ele).find(".help-block").text("");
        }

        //新增按钮弹出模态框
        $("#emp_add_modal_btn").click(function () {
            //清楚表单数据(表单完全重置)
            reset_form("#empAddModal form");
            //发送Ajax请求 查出部门信息,显示在下拉列表中
            getDepts("#empAddModal select");
            // 模态框弹出
            $("#empAddModal").modal({
                //弹出后点背景不会返回
                backdrop:"static"
            });
        });

        //查出所有部门信息
        function getDepts(ele) {
            //清空之前下拉列表的内容
            $(ele).empty();
           $.ajax({
              url: "${APP_PATH}/depts",
               type: "get",
               success:function (result) {
                  // console.log(result);
                  //  "extend":{"depts":[{"deptId":1,"deptName":"开发部"},{"deptId":2,"deptName":"测试部"}]}}
                  //  显示部门信息在下拉列表中
                   $.each(result.extend.depts, function (index, item) {
                       var optionEle = $("<option></option>").append(item.deptName).attr("value", item.deptId);
                       optionEle.appendTo(ele);
                   });
               }
           });
        }

        //保存员工
        $("#emp_save_btn").click(function () {

            //1.将模态框中的数据提交给服务器保存
            //判断之前Ajax请求校验用户名是否存在才往下走
            if ($("#emp_save_btn").attr("ajax_va") == "error") {
                return false;
            }

            //1.先对数据进行校验
            if (!validate_add_form()) {
                //校验失败
                return false;
            }

            //2.发送Ajax 请求保存员工
            $("#empAddModal form").serialize();
            $.ajax({
                url: "${APP_PATH}/emp",
                type:"post",
                data: $("#empAddModal form").serialize(),
                success:function (result) {
                    //判断
                    if (result.code == 100) {
                        //保存成功
                        // 1.关闭模态框
                        $('#empAddModal').modal('hide');
                        // 2.来到末页
                        //发送Ajax 请求显示最后一页  总记录数比总页码大 超过页码自动跳到末页
                        to_page(totalRecord);
                    } else {
                        //显示错误信息
                        // {"code":200,"msg":"处理失败!","extend":{"errorFields":{"email":"邮箱不合法"}}}
                        // console.log(result);
                        if ( undefined != result.extend.errorFields.email) {
                            show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                        }
                        if ( undefined != result.extend.errorFields.empName) {
                            show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                        }
                    }

                }
            });
        });

        //检查用户名是否可用
        $("#empName_add_input").change(function () {
            //发送Ajax请求 校验用户名是否可用
            var empName = this.value;
            $.ajax({
                url:"${APP_PATH}/checkuser",
                data:"empName="+empName,
                type:"post",
                success:function (result) {
                    if (result.code == 100) {
                        show_validate_msg("#empName_add_input", "success", result.extend.va_msg);
                        $("#emp_save_btn").attr("ajax_va", "success");
                    } else {
                        show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
                        $("#emp_save_btn").attr("ajax_va", "error");
                    }
                }
            });
        });


        //校验表单数据方法
        function validate_add_form() {
            // 1.拿到要校验的数据, 使用正则表达式
            var empName = $("#empName_add_input").val();
            var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
            if (!regName.test(empName)) {
                //用户名不合法
                show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位数字字母_ -");
                return false;
            } else {
                show_validate_msg("#empName_add_input", "success", "");
            }
            //校验邮箱
            var email = $("#email_add_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if (!regEmail.test(email)) {
                // alert("邮箱不正确");
                show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
                return false;
            } else {
                show_validate_msg("#email_add_input", "success", "");
            }
            return true;
        }

        //显示输入框状态 内容
        function show_validate_msg(ele, status, msg) {
            //清楚当前元素的校验状态
            $(ele).parent().removeClass("has-success has-error");
            $(ele).next("span").text("");
            if ("success" == status) {
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);
            } else if ("error" == status) {
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);
            }
        }

        //1.我们是按钮创建之前绑定了click,所以绑不上
        //①创建按钮是绑点 事件.  ②绑定单击事件.live() 后来的元素也能绑定
        //jquery新版没有live方法, 使用on替代
        $(document).on("click", ".edit_btn", function () {
            //查询员工信息 部门信息
            getEmp($(this).attr("edit-id"));
            getDepts("#empUpdateModal select");

            //把员工id传递给更新按钮
            $("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));
            $("#empUpdateModal").modal({
                //弹出后点背景不会返回
                backdrop:"static"
            });
        });

        //获取员工 ID
        function getEmp(id) {
            $.ajax({
                url:"${APP_PATH}/emp/"+ id,
                type:"get",
                success:function (result) {
                    // {"code":100,"msg":"处理成功!","extend":{"emp":{"empId":3,"empName":"b54531","gender":"M",
                    //     "email":"b54531@sly.com","dId":1,"department":null}}}
                    var empData = result.extend.emp;
                    $("#empName_update_static").text(empData.empName);
                    $("#email_update_input").val(empData.email);
                    $("#empUpdateModal input[name=gender]").val([empData.gender]);
                    $("#empUpdateModal select").val([empData.dId]);
                }
            });
        }

        //更新按钮点击事件
        $("#emp_update_btn").click(function () {
            //验证邮箱是否合法
            //校验邮箱
            var email = $("#email_update_input").val();
            var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
            if (!regEmail.test(email)) {
                show_validate_msg("#emp_update_btn", "error", "邮箱格式不正确");
                return false;
            } else {
                show_validate_msg("#emp_update_btn", "success", "");
            }
            //2.发送Ajax请求保存跟新的员工数据
            $.ajax({
                url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
                type:"put",
                data:$("#empUpdateModal form").serialize(),
                success:function (result) {
                    $('#empUpdateModal').modal('hide');
                    to_page(currentPage);
                }
            });
        });

        //单个删除
        $(document).on("click", ".delete_btn", function () {
            //1.弹出是否确认删除对话框
            var empName = $(this).parents("tr").find("td:eq(2)").text();
            if (confirm("确认删除["+ empName +"]吗?")) {
                $.ajax({
                    url:"${APP_PATH}/emp/" + $(this).attr("del-id"),
                    type:"delete",
                    success:function (result) {
                        to_page(currentPage);
                    }
                });
            }


        });

        //全选
        $("#check_all").click(function () {
            var status = $(this).prop("checked");
            $(".check_item").prop("checked", status);
        });

        //选满了 全选也得选上
        $(document).on("click", ".check_item", function () {
            //判断是否选中五个
            var flag = $(".check_item:checked").length == $(".check_item").length
            $("#check_all").prop("checked", flag);
        });

        $("#emp_delete_all_btn").click(function () {
            var empNames = "";
            var del_idstr = "";
            $.each($(".check_item:checked"), function () {
                empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
                del_idstr += $(this).parents("tr").find("td:eq(1)").text()+"-";
            });
            //去除多余的逗号
             empNames = empNames.substring(0,empNames.length-1);
            del_idstr = del_idstr.substring(0,del_idstr.length-1);

            if (confirm("确认删除["+ empNames +"]吗?")) {
                //发送Ajax 请求删除
                $.ajax({
                    url:"${APP_PATH}/emp/"+ del_idstr ,
                    type:"delete",
                    success:function (result) {
                        to_page(currentPage);
                    }
                });
            }

        });

    </script>
</body>
</html>
