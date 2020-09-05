<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="zh-CN">
    <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">


    <%@include file="/WEB-INF/jsp/common/css.jsp" %>
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
    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 系统权限菜单</h3>
    </div>
    <div class="panel-body">

          <ul id="treeDemo" class="ztree"></ul>

    </div>
    </div>
    </div>
    </div>
    </div>

    <%@include file="/WEB-INF/jsp/common/js.jsp" %>
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

    showTree();
    });

    function showTree() {

        var setting = {
            data: {
                simpleData: {
                    enable: true,
                    pIdKey: "pid"
                }
            },
            view:{
                addDiyDom: addDiyIcon,
                addHoverDom:addHoverDom,
                removeHoverDom:removeHoverDom
            }
        };

            var zNodes ={};

            $.get("${PATH}/menu/loadTree",{},function(result) {

                zNodes = result;
                zNodes.push({id: 0,  name: "根", icon: "glyphicon glyphicon-asterisk",children: []});
                $.fn.zTree.init($("#treeDemo"), setting, zNodes);
                var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                treeObj.expandAll(true);

            });

    }

    function addDiyIcon(treeId , treeNode) {
        $("#"+treeNode.tId+"_ico").removeClass();
        $("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>");

    }

    function addHoverDom(treeId , treeNode) {

            var aObj = $("#" + treeNode.tId + "_a"); // tId = permissionTree_1, ==> $("#permissionTree_1_a")
            aObj.attr("href", "javascript:;");
            aObj.attr("onclick","return false;");
            if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;
            var s = '<span id="btnGroup'+treeNode.tId+'">';
            if ( treeNode.level == 0 ) {
                     s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
            } else if ( treeNode.level == 1 ) {
                     s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
            if (treeNode.children.length == 0) {
                     s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
            }
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
            } else if ( treeNode.level == 2 ) {
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
            }

            s += '</span>';
            aObj.after(s);

    }
    function removeHoverDom(treeId, treeNode){
        $("#btnGroup"+treeNode.tId).remove();
    }
</script>
</body>
</html>

