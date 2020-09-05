<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Maibenben
  Date: 2020/8/25
  Time: 23:56
  To change this template use File | Settings | File Templates.
--%>
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

                    <form id="serachFrom" class="form-inline" role="form" style="float:left;" action="${PATH}/admin/index" method="post">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input class="form-control has-success" type="text" name="condition" value="${param.condition}" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="searchBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>


                    <button type="button" id="batchDelete" class="btn btn-danger" style="float:right;margin-left:10px;"  ><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" class="btn btn-primary" style="float:right;" onclick="window.location.href='${PATH}/admin/toAdd'"><i class="glyphicon glyphicon-plus"></i> 新增</button>



                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">序号</th>
                                <th width="30"><input id="theadCheckbox" type="checkbox"></th>
                                <th>账号</th>
                                <th>名称</th>
                                <th>邮箱地址</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${pageInfo.list}" var="admin" varStatus="status">
                                    <tr>
                                        <td>${status.count}</td>
                                        <td><input class="itemCheckbox" adminId = "${admin.id}"type="checkbox"></td>
                                        <td>${admin.loginacct}</td>
                                        <td>${admin.username}</td>
                                        <td>${admin.email}</td>
                                        <td>
                                            <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>
                                            <button type="button" class="btn btn-primary btn-xs" onclick="window.location.href = '${PATH}/admin/toUpdate?id=${admin.id}&pageNum=${pageInfo.pageNum}'"><i class=" glyphicon glyphicon-pencil"></i></button>
                                            <button type="button" class="btn btn-danger btn-xs"  onclick="deleteAdmin('${admin.loginacct}','${admin.id}')"><i class=" glyphicon glyphicon-remove"></i></button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">
                                        <c:if test="${pageInfo.isFirstPage}">
                                            <li class="disabled"><a href="#">上一页</a></li>
                                        </c:if>
                                        <c:if test="${!pageInfo.isFirstPage}">
                                            <li ><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${pageInfo.pageNum-1}">上一页</a></li>
                                        </c:if>
                                        <c:forEach items="${pageInfo.navigatepageNums}" var="num">
                                            <c:if test="${num == pageInfo.pageNum}">
                                                <li class="active"><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${num}">${num}<span class="sr-only">(current)</span> </a></li>
                                            </c:if>
                                            <c:if test="${num != pageInfo.pageNum}">
                                                <li><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${num}">${num}</a></li>
                                            </c:if>
                                        </c:forEach>
                                        <c:if test="${pageInfo.isLastPage}">
                                            <li class="disabled"><a href="#">下一页</a></li>
                                        </c:if>
                                        <c:if test="${! pageInfo.isLastPage}">
                                            <li><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${pageInfo.pageNum+1}">下一页</a></li>
                                        </c:if>
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
    });

    $("#searchBtn").click(function () {
        $("#serachFrom").submit();
    });
    function deleteAdmin(loginacct,id) {

      layer.confirm("你确定要删除"+loginacct+"账号吗",{
          btn:["确认","取消"]
      },function() {
            layer.msg("删除成功了",function(){
                window.location.href="${PATH}/admin/delete?id="+id+"&pageNum=${pageInfo.pageNum}";
            });
      },function(){
          layer.msg("删除取消");

      });

    }

    $("#theadCheckbox").click(function () {

        $(".itemCheckbox").prop("checked",this.checked)
    });

    $("#batchDelete").click(function () {

        var  itemcheckedArray = $(".itemCheckbox:checked");
        if (itemcheckedArray == 0){
            layer.msg("请先选择删除的对象");
            return false;
        }
        var idStr = '';
        var  array = new  Array();
        $.each(itemcheckedArray,function (i,e) {

            var adminId = $(e).attr("adminId");
            array.push(adminId);
        });
        idStr =array.join(",");


        layer.confirm("你确定要删除这些账号吗",{
            btn:["确认","取消"]
        },function() {
            layer.msg("删除成功了",function(){
                window.location.href="${PATH}/admin/deleteBatch?idStr="+idStr+"&pageNum=${pageInfo.pageNum}";
            });
        },function(){
            layer.msg("删除取消");

        });
    });
</script>
</body>
</html>
