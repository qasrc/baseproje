<%--
  Created by IntelliJ IDEA.
  User: 张战
  Date: 2017/1/13
  Time: 9:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>

<html>
<head>
    <%@ include file="/commons/basejs.jsp" %>

    <title>辖区人口详细信息</title>

</head>
<body>
<script type="text/javascript" src="${staticPath}/static/echarts.min.js" charset="utf-8"></script>
<script type="text/javascript">
    $(document).ready(function () {

        var myEcharts = echarts.init(document.getElementById("xqrkEcharts"));
        var bdOrgId = '${param.bdOrgId}';
        myEcharts.showLoading();
        $.ajax({
            url: '${path}/xqrkDetail',
            type: 'post',
            data: {'bdOrgId': bdOrgId},
            success: function (result) {
                var data = eval("(" + result + ")");
                var age0To6 = data[0];
                var age15To49 = data[1];
                var gtAge65 = data[2];
                var other = data[3];
                myEcharts.hideLoading();
                myEcharts.setOption(option = {
                    title: {
                        text: '人群分布情况',
                        x: 'center'
                    },
                    tooltip: {
                        trigger: 'item',
                        formatter: "{a} <br/>{b} : {c} ({d}%)"
                    },
                    legend: {
                        orient: 'vertical',
                        left: 'left',
                        data: ['0-6岁儿童', '育龄妇女', '65岁以上老人', '其他']
                    },
                    series: [
                        {
                            label: {
                                normal: {
                                    show: true,
                                    formatter: '{b} : {c}人 ({d}%)'
                                }
                            },
                            name: '分类',
                            type: 'pie',
                            radius: '55%',
                            center: ['50%', '60%'],
                            data: [
                                {value: age0To6, name: '0-6岁儿童'},
                                {value: age15To49, name: '育龄妇女'},
                                {value: gtAge65, name: '65岁以上老人'},
                                {value: other, name: '其他'}
                            ],
                            itemStyle: {
                                emphasis: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            }
                        }
                    ]
                }, true);
            }
        });

    })
</script>
<div id="xqrkEcharts" style="width: 100%;height: 100%"></div>

</body>
</html>
