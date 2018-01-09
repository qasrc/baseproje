<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2016/12/16
  Time: 14:11
  To change this template use File | Settings | File Templates.
--%>
<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<%@ include file="/commons/basejs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>患者列表</title>
    <%--<link rel="stylesheet" type="text/css" href="${staticPath }/static/easyui/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="${staticPath }/static/easyui/themes/icon.css">
    <script type="text/javascript" src="${staticPath }/static/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="${staticPath }/static/easyui/jquery.easyui.min.js"></script>--%>
</head>


<style type="text/css">
    input {
        border-top: 0px;
        border-left: 0px;
        border-right: 0px;
        text-align: left;
        width: 100px
    }
</style>

<body>

<DIV>
    <form id="searchForm">
        <table>
            <tr>
                <th>姓名:</th>
                <td><input id="outpatname" value="${patientName}"/></td>
                <th>身份证号:</th>
                <td><input id="cardid"/></td>
                <th>电话:</th>
                <td><input id="tel"/></td>

                <td>
                    <a href="####" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true"
                       onclick="searchFun();">查询</a>
                    <a href="javascript:window.opener=null;window.open('','_self');window.close();"
                       class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true">关闭</a>
                </td>
            </tr>
        </table>
    </form>
</DIV>
<table id="dg" title="患者列表" style="width:700px;height:300px" data-options="
				rownumbers:true,
				singleSelect:true,
				autoRowHeight:false,
				pagination:true,
				pageSize:10">
    <thead>
    <tr>
        <th field="oper" width="60">操作</th>
        <th field="name" width="50">姓名</th>
        <th field="idcard" width="170">身份证号</th>
        <th field="sex" width="40" align="right">性别</th>
        <th field="birthday" width="80">出生日期</th>
        <th field="address" width="145">地址</th>
        <th field="tel" width="105">电话</th>
    </tr>
    </thead>
</table>

<script type="text/javascript">

    function getData() {
        var outpatname;
        var temp = '${patientName}';
        console.log("------" + temp);
        if (temp != null && temp != "") {
            outpatname = temp;
        } else {
            outpatname = $("#outpatname").val().replace(/\s+/g, "");
        }

        var cardid = $("#cardid").val().replace(/\s+/g, "");
        var tel = $("#tel").val().replace(/\s+/g, "");
        var url = '${path}/patient/getPatientsByOrgCode?outpatname=' + outpatname + '&cardid=' + cardid + '&tel=' + tel + "&orgcode=370124D60070";

        $.ajax({
            type: "get",
            async: false,
            url: url,
            dataType: "jsonp",
            contentType: "application/x-www-form-urlencoded; charset=utf-8",
            jsonp: "callback",//传递给请求处理程序或页面的，用以获得jsonp回调函数名的参数名(自己取名字)
            success: function (data) {
                var rows = [];
                for (var i in data) {
                    console.log(data[i].patientname);
                    rows.push({
                        oper: '<a href="#" value=' + data[i].idcard + '>详情</a>',
                        name: data[i].patientname,
                        idcard: data[i].idcard,
                        sex: data[i].sex,
                        birthday: data[i].birthday,
                        address: data[i].address,
                        tel: data[i].telphone
                    });
                }

                $('#dg').datagrid({loadFilter: pagerFilter}).datagrid('loadData', rows);
            },
            error: function (data) {
                alert(data + "查询失败");
            }
        });
    }

    function pagerFilter(data) {
        if (typeof data.length == 'number' && typeof data.splice == 'function') {
            data = {
                total: data.length,
                rows: data
            }
        }
        var dg = $(this);
        var opts = dg.datagrid('options');
        var pager = dg.datagrid('getPager');
        pager.pagination({
            onSelectPage: function (pageNum, pageSize) {
                opts.pageNumber = pageNum;
                opts.pageSize = pageSize;
                pager.pagination('refresh', {
                    pageNumber: pageNum,
                    pageSize: pageSize
                });
                dg.datagrid('loadData', data);
            }
        });
        if (!data.originalRows) {
            data.originalRows = (data.rows);
        }
        var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
        var end = start + parseInt(opts.pageSize);
        data.rows = (data.originalRows.slice(start, end));
        return data;
    }

    //自己添加的功能
    function searchFun() {
        getData();
    }

    $(function () {
        console.log("=========")
        getData();
    });

</script>

</body>
</html>
