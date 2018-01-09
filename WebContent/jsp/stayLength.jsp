<%--
  Created by IntelliJ IDEA.
  User: zhan
  Date: 2016/12/5
  Time: 14:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/commons/basejs.jsp" %>
    <script type="text/javascript" src="${staticPath }/static/echarts.min.js" charset="utf-8"></script>

    <title>图表展示</title>
</head>
<body>
<input id="flag" hidden="hidden" value="${flag}">
<div id="stayechart" style="width:800px;height: 500px;">

</div>

<script type="text/javascript">
    $(function () {
        var myChart = echarts.init(document.getElementById("stayechart"));
        var flag = $("#flag").val();
        myChart.showLoading();
        if (flag == 'days') {
            $.post('${path}/patients/gridDate', function (result) {
                myChart.hideLoading();
                myChart.setOption(option = result, true);
            }, 'JSON');
        } else if (flag == 'fees') {
            $.post('${path}/patients/feeGrid', function (result) {
                myChart.hideLoading();
                myChart.setOption(option = result, true);
            }, 'JSON');
        } else {
            $.messager.alert("错误", "参数传递不正确", "error");
        }
    })


</script>
</body>
</html>
