<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>userList</title>
    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"/>
    <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script type="text/javascript" src="js/jquery-3.3.1.js"></script>
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="/js/bootstrap.js"></script>
</head>

<script type="text/javascript">
    $(document).ready(function () {
        bindEvent();
        //跳转到该页面时就发送ajax请求显示所有用户
        queryAllUsers();
        // bindBtnDel();
    });

    function bindEvent() {
        //点击新增弹出模态框
        $("#userAddBtn").click(function () {
            $("#userAddModal").modal('show');
        })
        //为保存按钮绑定click
        $("#userAddModalSaveBtn").click(function () {
            var formObject = {}
            var formData = $("#userAddModalForm").serializeArray();
            $.each(formData, function (i, item) {
                formObject[item.name] = item.value;
            });
            doAdd(formObject);
        })
        // 查询单个用户
        $("#userQueryBtn").click(function () {
            var id = $("#userID").val();
            doQuery(id);
        })
        //查询并显示所有用户
        $("#allUserQueryBtn").click(function () {
            //首先清空表格残留数据
            $("#user_table_tbody").empty();
            queryAllUsers();
        })

    }

    function doAdd(formData) {
        $.ajax({
            type: "POST",
            url: "/resume/add",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(formData),
            dataType: "json",
            success: function (result) {
                //关闭模态框
                $("#userAddModal").modal("hide");
                alert("添加成功");
                $("#user_table_tbody").empty();
                queryAllUsers();
            }
        });
    }

    // 查询单个用户调用的方法
    function doQuery(id) {
        $.ajax({
            type: "POST",
            url: "queryUser/" + id,
            dataType: "json",
            success: function (data) {
                if (data.user == null) {
                    //当查询的用户不存在时，清空表格上面上次查询的结果
                    $("#user_table_tbody").empty();
                    alert(data.queryinfo);
                } else {
                    //清空表格
                    $("#user_table_tbody").empty();
                    show_user_table(data.user);
                    console.log(data.user);
                }
            }
        });
    }

    //查询所有用户
    function queryAllUsers() {
        $.ajax({
            type: "POST",
            url: "/resume/queryAll",
            dataType: "json",
            success: function (data) {
                console.log(data);
                //遍历data循环构建表体
                $.each(data, function (index, item) {
                    show_user_table(item);
                })
            }
        })
    }

    //在table里呈现单条查询的结果
    function show_user_table(result) {
        var useridTD = $("<td></td>").append(result.id);
        var address = $("<td></td>").append(result.address);
        var name = $("<td></td>").append(result.name);
        var phone = $("<td></td>").append(result.phone);
        var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm user-edit-btn").append("编辑");
        editBtn.attr("user-edit-id", result.id);
        var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm user-del-btn").append("删除");
        delBtn.attr("user-del-id", result.id);
        var operate = $("<td></td>").append(editBtn).append("&nbsp;").append(delBtn);
        $("<tr></tr>").append(useridTD)
            .append(address)
            .append(name)
            .append(phone)
            .append(operate)
            .appendTo("#user_table_tbody");
    }

    //删除单个用户
    function doDelete(id) {
        $.ajax({
            type: "DELETE",
            url: "resume/delete?id=" + id,
            success: function (data) {
                console.log(data);
                alert("删除成功")
                //首先清空表格残留数据
                $("#user_table_tbody").empty();
                queryAllUsers();
            }
        })
    }

    //为删除按钮绑定事件
    $(document).on("click", ".user-del-btn", function () {
        if (confirm("确定删除该用户")) {
            var id = $(this).attr("user-del-id");
            console.log(id);
            doDelete(id);
            //下面两行是删除用户后刷新表体数据
            $("#user_table_tbody").empty();
            queryAllUsers();
        }
    })
    //为编辑用户按钮绑定事件
    $(document).on("click", ".user-edit-btn", function () {
        var id = $(this).attr("user-edit-id");
        console.log(id);
        doQueryByID(id);
        //显示修改模态框
        $("#userModifyModal").modal('show');
    })
    //为修改的确定按钮绑定事件，由于作用与此处的修改按钮是动态创建的，所以不能使用这方法
    /*    $("#userModifyModalSaveBtn").click(function () {
            var formData = $("#userModifyModalForm").serialize();
            doUpdate(formData);
        })*/
    $(document).on("click", "#userModifyModalSaveBtn", function () {
        var formObject = {};
        var formData = $("#userModifyModalForm").serializeArray();
        $.each(formData, function (i, item) {
            formObject[item.name] = item.value;
        });
        doUpdate(formObject);
    })

    //根据ID查询到user并赋值给模态框
    function doQueryByID(id) {
        $.ajax({
            type: "POST",
            url: "resume/queryById?id=" + id,
            dataType: "json",
            success: function (data) {
                if (data != null) {
                    //赋值
                    $("#userModifyModal_id").val(data.id);
                    $("#userModifyModal_address").val(data.address);
                    $("#userModifyModal_name").val(data.name);
                    $("#userModifyModal_phone").val(data.phone);
                }
            }
        });
    }

    //修改用户
    function doUpdate(formData) {
        $.ajax({
            type: "POST",
            url: "/resume/update",
            contentType: "application/json; charset=utf-8",
            data: JSON.stringify(formData),
            dataType: "json",
            success: function (result) {
                //关闭模态框
                $("#userModifyModal").modal("hide");
                if (result) {
                    //下面两行是删除用户后刷新表体数据
                    $("#user_table_tbody").empty();
                    queryAllUsers();
                } else {
                    alert("修改失败");
                }
            }
        });
    }

</script>

<body onload="doQuery()">

<div class="container">
    <div class="row">
        <div class="col-sm-12">
            <h2>UserManager</h2>
        </div>
    </div>

    <div class="row">
        <%--添加用户查询表单--%>
        <div class="col-sm-offset-4">
            <form id="userQuery" method="post">
                <input type="text" id="userID" name="userID" placeholder="用户ID"/>&nbsp;&nbsp;
                <input name="userName" id="userName" placeholder="用户名"/>
                <BUTTON type="button" class="btn btn-primary btn-sm" id="userQueryBtn">查询</BUTTON>
                <BUTTON type="button" class="btn btn-primary btn-sm" id="allUserQueryBtn">显示所有用户</BUTTON>
            </form>
        </div>
        <%--添加“增加”和“批量删除”按钮--%>
        <div class="col-sm-4 col-sm-offset-11">
            <BUTTON type="button" class="btn btn-primary btn-sm" data-toggle="modal" id="userAddBtn">增加</BUTTON>
            <BUTTON type="button" class="btn btn-primary btn-sm" id="userDelBtn">批量删除</BUTTON>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-12">
            <table class="table  table-hover" id="user_table">
                <thead>
                <tr>
                    <th width="20%">用户ID</th>
                    <th width="20%">address</th>
                    <th width="20%">name</th>
                    <th width="20%">phone</th>
                    <th width="20%">操作</th>
                </tr>
                </thead>
                <tbody id="user_table_tbody">

                </tbody>
            </table>
        </div>
    </div>
</div>

<%--新增用户的模态框--%>
<div class="modal" id="userAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document" style="width: 35%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h5 class="modal-title" id="myModalLabel">新增</h5>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="userAddModalForm" method="post">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">name</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" name="name" placeholder="name"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">address</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" name="address" placeholder="address"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">phone</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" name="phone" placeholder="phone"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary btn-sm" id="userAddModalSaveBtn">保存</button>
            </div>
        </div>
    </div>
</div>


<%--修改用户的模态框--%>
<div class="modal" id="userModifyModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document" style="width: 35%">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h5 class="modal-title">修改</h5>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="userModifyModalForm" method="post">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">用户ID</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="userModifyModal_id" name="id" readonly/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">address</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="userModifyModal_address" name="address"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">name</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="userModifyModal_name" name="name"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">phone</label>
                        <div class="col-sm-8">
                            <input type="text" class="form-control" id="userModifyModal_phone" name="phone"/>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default btn-sm" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary btn-sm" id="userModifyModalSaveBtn">保存</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>