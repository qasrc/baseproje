<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp"%>
<%@ include file="/commons/basejs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>患者列表</title>
</head>

<script type="text/javascript">
</script>

<style type="text/css">
input
{
  border-top:0px;
  border-left:0px ;
  border-right:0px ;
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
					<td><input id="cardid" /></td>
					<th>电话:</th>
					<td><input id="tel" /></td>

					<td>
						<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchFun();">查询</a> 
					</td>
				</tr>
			</table>
		</form>

	</DIV>
	<table id="dg" title="" style="width:700px;height:300px" data-options="
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
    var rows = [];
    var outpatname = $("#outpatname").val().replace(/\s+/g, "");
    var cardid = $("#cardid").val().replace(/\s+/g, "");
    var tel = $("#tel").val().replace(/\s+/g, "");
    if(outpatname.length == 0 && cardid.length == 0 && tel.length == 0){
        $('#dg').datagrid({loadFilter: pagerFilter}).datagrid('loadData', rows);
        $.messager.alert("提示", "查询内容不能为空!", "info");
    	return;
    }
    var url = '${path}/patient/getPatientsByOrgCode?outpatname=' + outpatname + '&cardid=' + cardid + '&tel=' + tel + "&orgcode=370124D60070";
    url = encodeURI(encodeURI(url));
    $.ajax({
        type: "get",
        async: false,
        url: url,
        dataType: "jsonp",
        contentType: "application/x-www-form-urlencoded; charset=utf-8",
        jsonp: "callback",
        success: function (data) {
            rows.length = 0;
            var temp;
            for (var i in data) {
            	
            	
            	temp = getidcard(data[i].idcard);
            	console.log(temp);
                rows.push({
                    oper: temp,
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
            var rows = [];//返回空数组
            $('#dg').datagrid({loadFilter: pagerFilter}).datagrid('loadData', rows);
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
    
     $(document).ready(function(){
  		$("#sendIdCard").hide();
	});

    function searchFun() {
        getData();
    }

    $(function () {
        getData();
    });
    
    
    function getidcard(idCard){
     return '<a href="javaScript:void(0);" onclick=" viewDetails('+idCard+')">详情</a>'; 
    }
 
    
    //查看患者详情
    function viewDetails(idCard) {
		console.log("进来了");
        var url = '${path}/patient/patientDetails?idCard=' + idCard;
        alert(url);
    	 window.open(
    			 /*URL*/url,
    			 /*Name*/"患者详情",
    			 'width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)
    			 );
    }
    
    
</script>

</body>
</html>