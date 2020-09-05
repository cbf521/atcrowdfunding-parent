<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">


    <%@include file="/WEB-INF/jsp/common/css.jsp"%>
    <style>
        .tree li {
            list-style-type: none;
            cursor:pointer;
        }
        table tbody tr:nth-child(odd){background:#F4F4F4;}
        table tbody td:nth-child(even){color:#C00;}
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/jsp/common/top.jsp"></jsp:include>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/jsp/common/menu.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form  class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input id="condition" class="form-control has-success" type="text" placeholder="请输入查询条件">

                            </div>
                        </div>
                        <button id="serachBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>
                    <button id=batchDelete type="button" onclick="batchDelete()" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button id="addBtn" type="button" class="btn btn-primary" style="float:right;" ><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input id="theadCheckbox" type="checkbox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>

                            </tr>
                            </thead>
                            <tbody class="itemClass">


                            </tbody>

                            <tfoot>
                                <tr >
                                    <td colspan="6" align="center">
                                        <ul class="pagination">

                                        </ul>
                                    </td>
                                </tr>

                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >修改角色 </h4>
            </div>
            <div class="modal-body">
                <form id="updateForm" role="form"  method="post">
                    <div class="form-group">
                        <label for="exampleInputPassword1">角色名称</label>
                        <input type="hidden" name="id">
                        <input type="text" class="form-control"  name="name" placeholder="请输入角色名称">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="updateBtn" type="button" class="btn btn-primary">修改</button>
            </div>
        </div>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加权限 </h4>
            </div>
            <div class="modal-body">
                <form id="addForm" role="form" >
                    <div class="form-group">
                        <label for="exampleInputPassword1">角色名称</label>
                        <input type="text" class="form-control" id="exampleInputPassword1" name="name" placeholder="请输入角色名称">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>


<%@include file="/WEB-INF/jsp/common/js.jsp"%>
<script type="text/javascript">
    $(function () {
        $(".list-group-item").click(function(){
            if ( $(this).find("ul") ) {
                $(this).toggleClass("tree-closed");
                if ( $(this).hasClass("tree-closed") ) {
                    $("ul", this).hide("fast");
                } else {
                    $("ul", this).show("fast");
                }
            }
        });
        showDate(1);
    });

    var json = {
        pageNum:1,
        pageSize:2,
        condition: ""
    };
    //异步请求
    function showDate(pageNum) {

        json.pageNum = pageNum;

        $.ajax({
            type:"post",
            url:"${PATH}/role/loadDate",
            data:json,
            success:function (result) {


                console.log(result);
                json.pages = result.pages;
                //显示列表数据
                showTable(result.list);

                //显示分页条
                showNavg(result);

            }
        });
    }
    function showTable(list) {

        var content = '';

        $.each(list,function (i,e) {

            content+='<tr>';
            content+='	<td>'+(i + 1)+'</td>';
            content+='	<td><input class="itemCheckbox" name="item" value="'+e.id+'" type="checkbox"></td>';
            content+='	<td>'+e.name+'</td>';
            content+='	<td>';
            content+='		<button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
            content+='		<button type="button" roleId ="'+e.id+'" class="updateBtnClass btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
            content+='		<button type="button" onclick="deleteRole('+e.id+',\''+e.name+'\')" class="btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
            content+='	</td>';
            content+='</tr>';

        });
        $("tbody").html(content);
    }
    function showNavg(result) {
        var content = '';
        if (result.isFirstPage){
            content+='<li class="disabled"><a href="#">上一页</a></li>';
        }else {
            content+='<li ><a onclick="showDate('+ (result.pageNum-1) +')">上一页</a></li>';
        }
        $.each(result.navigatepageNums,function (i,num) {

            if (result.pageNum == num){
                content+='<li class="active"><a onclick="showDate('+num+')">' + num + '</a></li>';
            }else {
                content+='<li ><a onclick="showDate('+num+')">'+ num +'</a></li>';
            }
        });
        if (result.isLastPage){
            content+='<li class="disabled"><a href="#">下一页</a></li>';
        }else{
            content+='<li><a onclick="showDate('+(result.pageNum+1)+')">下一页</a></li>';
        }

        $(".pagination").html(content);
    }

    $("#serachBtn").click(function () {


        var condition = $("#condition").val();

        json.condition = condition;

        showDate(1);
    });

    $("#addBtn").click(function () {

        $("#myModal").modal({
            show:true,
            backdrop:'static',
            keyboard:false
        });
    });
    $("#saveBtn").click(function () {

        var name = $("#myModal input[name= 'name']").val();

       $.ajax({
           type: "post",
           url: "${PATH}/role/add",
           data:{name},
           success:function (result) {

               console.log(result);
               $("#myModal").modal('hide');
               var name = $("#myModal input[name= 'name']").val("");
               if ("ok" == result){
                   layer.msg("添加课程");
                   showDate(json.pages + 1);
               }else {
                   layer.msg("失败");
               }


           }
       });

    });

    $("tbody").on("click",".updateBtnClass",function () {

        var roleId = $(this).attr("roleId");
        $.get("${PATH}/role/get",{id:roleId},function (result) {

            $("#updateModal input[name = 'id']").val(result.id);
            $("#updateModal input[name = 'name']").val(result.name);


            $("#updateModal").modal({
                show:true,
                backdrop: "hide",
                keyboard: false
            });

        });
    });
    $("#updateBtn").click(function (result) {

        var id = $("#updateModal input[name = 'id']").val();
        var name = $("#updateModal input[name = 'name']").val();
        $.post("${PATH}/role/doUpdate",{id:id,name:name},function (result) {

            $("#updateModal").modal('hide');
            if ("ok" == result){
                layer.msg("chengg");
                showDate(json.pageNum);
            }else {
                layer.msg("shibai");
            }
        });
    });

    function deleteRole(id,name) {
        layer.confirm("确定要删除"+name+"角色",{btn:["确认","取消"]},function () {

            layer.msg("确认",{time:1000},function () {

                $.post("${PATH}/role/delete",{id:id},function (result) {

                    if ("ok" == result){
                        showDate(json.pageNum);
                        layer.msg("gong");
                    }else {
                        layer.msg("shibai");
                    }
                });

            });

        },function () {

            layer.msg("取消");
        });

    }

    $("#theadCheckbox").click(function () {

        $(".itemCheckbox").prop("checked",this.checked)
    });


    <%--$("#batchDelete").click(function () {--%>

    <%--    var itemCheckArray = $(".itemCheckbox:checked");--%>

    <%--    if (itemCheckArray == 0){--%>
    <%--        layer.msg("请先选择删除的对象");--%>

    <%--        return false;--%>
    <%--    }--%>
    <%--    var  idStr = '';--%>
    <%--    var  array = new Array();--%>
    <%--    $.each(itemCheckArray, function (i,e) {--%>


    <%--        var adminId = e.id;--%>
    <%--        array.push(adminId);--%>
    <%--    });--%>

    <%--    idStr = array.join(",");--%>


    <%--    layer.confirm("确定要删除角色",{btn:["确认","取消"]},function () {--%>

    <%--        layer.msg("确认",{time:1000},function () {--%>

    <%--            $.post("${PATH}/role/batchDelete",{idStr:idStr},function (result) {--%>

    <%--                if ("ok" == result){--%>
    <%--                    showDate(json.pageNum);--%>
    <%--                    layer.msg("gong");--%>
    <%--                }else {--%>
    <%--                    layer.msg("shibai");--%>
    <%--                }--%>
    <%--            });--%>

    <%--        });--%>

    <%--    },function () {--%>

    <%--        layer.msg("取消");--%>
    <%--    });--%>


    <%--});--%>
    function batchDelete() {

        var checkNum = $(".itemClass input[name = 'item']:checked").length;

        if (checkNum == 0){
            layer.msg("至少选择一项");

        }else{
            layer.confirm("确定要删除角色",{btn:["确认","取消"]},function () {


                var roleList = new Array();
                $("input[name='item']:checked").each(function(){
                    roleList.push($(this).val());
                });

                layer.msg("确认",{time:1000},function () {

                    $.post("${PATH}/role/batchDelete",{roleList:roleList.toString()},function (result) {

                        if ("ok" == result){
                            showDate(json.pageNum);
                            layer.msg("gong");
                        }else {
                            layer.msg("shibai");
                        }
                    });

                });

            },function () {

                layer.msg("取消");
            });

        }



    }
</script>
</body>
</html>

