<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/commons/basejs.jsp" %>
    <script type="text/javascript" src="${staticPath }/static/echarts.min.js" charset="utf-8"></script>

    <title>图表展示</title>
    <style>
        table td {
            height: 40px;
        }
    </style>
</head>
<body>
<input style="width:0;height: 0;border-width: 0" id="flag" hidden="hidden" value="${flag}">
<div id="stayechart" style="width:90%;height: 320px;">

</div>

<c:if test="${flag=='days'}">
    <input style="width:0;height: 0;border-width: 0" id="tableHref" hidden="hidden" value="${path}/patient/getDayData">
    <input style="width:0;height: 0;border-width: 0" id="tableTitle" hidden="hidden" value="平均住院天数">

</c:if>
<c:if test="${flag=='fees'}">
    <input style="width:0;height: 0;border-width: 0" id="tableHref" hidden="hidden" value="${path}/patient/getFeeData">
    <input style="width:0;height: 0;border-width: 0" id="tableTitle" hidden="hidden" value="平均住院费用">

</c:if>
<div id="dayData">
    <table id="dayTable"></table>
</div>

<script type="text/javascript">
    $(function () {
        var myChart = echarts.init(document.getElementById("stayechart"));
        var flag = $("#flag").val();
        myChart.showLoading();
        if (flag == 'days') {
            $.post('${path}/patient/gridDate', function (result) {

                myChart.hideLoading();
                myChart.setOption(option = result, true);
                getTableData();
            }, 'JSON');
        } else if (flag == 'fees') {
            $.post('${path}/patient/feeGrid', function (result) {
                myChart.hideLoading();
                myChart.setOption(option = result, true);
                getTableData();
            }, 'JSON');
        } else {
            $.messager.alert("错误", "参数传递不正确", "error");
        }

        function getTableData() {
            $("#dayTable").datagrid({
                url: $("#tableHref").val(),
                singleSelect: true,
                iconCls: 'icon-ok',

                title: $("#tableTitle").val(),
                columns: [[{
                    field: 'desc',
                    title: '年份',
                    align: 'center',
                    width: '15%'
                }, {
                    field: '0',
                    title: '一月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }, {
                    field: '1',
                    title: '二月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }, {
                    field: '2',
                    title: '三月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }, {
                    field: '3',
                    title: '四月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }, {
                    field: '4',
                    title: '五月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }, {
                    field: '5',
                    title: '六月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }, {
                    field: '6',
                    title: '七月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }, {
                    field: '7',
                    title: '八月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }, {
                    field: '8',
                    title: '九月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }, {
                    field: '9',
                    title: '十月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }, {
                    field: '10',
                    title: '十一月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }, {
                    field: '11',
                    title: '十二月',
                    formatter: function (value, row, index) {
                        if (value == "无数据") {
                            return "<span style='color: red;'>无数据</span>";
                        } else {
                            return value;
                        }
                    },
                    width: '7%'
                }]]
            });
        }
    })


</script>

</body>
</html>
