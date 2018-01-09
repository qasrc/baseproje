<%-- 患者身份证号：${idCard} --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- [jQuery] -->
    <script type="text/javascript"
            src="${staticPath }/static/easyui/jquery.min.js" charset="utf-8"></script>
    <!-- [EasyUI] -->
    <link id="easyuiTheme" rel="stylesheet" type="text/css"
          href="${staticPath }/static/easyui/themes/gray/easyui.css"/>
    <link id="easyuiTheme" rel="stylesheet" type="text/css"
          href="${staticPath }/static/easyui/themes/icon.css"/>
    <script type="text/javascript"
            src="${staticPath }/static/easyui/jquery.easyui.min.js" charset="utf-8"></script> 
    <title>患者详情</title>
	<style type="text/css">
	    body {
	        margin: 0px auto;
	    }
	    
		/* 页面左侧悬浮的状态样式 */
	    #suspendleftPic {
	        position: absolute;
	        left: 0px;
	        top: 15%;
	        width: 12px;
	        height:190px;
	        z-index: 2;
	        background: url(../images/bg.png) 0px -419px;
	        cursor: pointer;
	    }
	    
	    /* 点击最左侧的悬浮物出现的列表的样式 */
	    #suspend {
	        display:none;
	        width: 185px;
	        height: 450px;
	        background: white;
	        z-index: 1000;
	        margin-top :100px;
	        margin-left: 12px;
	        border: 1px solid rgba(94, 135, 199, 0.78);
	        border-top-color: #fff;
	    }
	</style>
	<script type="text/javascript">
	    var healthService='http://8.8.7.6:82/ehrview';
	    var strurl= healthService+"/common/main.action?id=${idCard}";//跳转到首页
	    //跳转到处方页
	    var chufangUrl="http://8.8.7.1:81/XYGZZ/OrderCashSendDrug.aspx?userSysId=2630&amp;workstationId=-1&amp;Out_Pat_Code=${cardCode}&amp;Card_Type=1&amp;";
	    var patientDetailInfo=null;//用于存储详细患者的详细信息。
	    var idCardNumber='${idCard}';
	    //var idCardNumber=null;//用于模拟测试无身份证号的情况
	    var hdPersionId=null;
	    var hbpCustomerMainId=null;
	    var hisCardCode=null;

	    $(function () {
	    	/* $.post("${path }/patient/patientDetailsInfo",{idCardNo:idCardNumber},function(result){
	        	patientDetailInfo=eval('(' + result + ')');
	        	patientDetailInfo=eval("("+patientDetailInfo+")");
	        	hdPersionId=patientDetailInfo.hdPersionId;
	    	    hbpCustomerMainId=patientDetailInfo.hbpCustomerMainId;
	    	    hisCardCode=patientDetailInfo.hisCardCode;
	        }); */
	    	
	    	$.ajax({
	    		url:"${path }/patient/patientDetailsInfo",
	    		data:{idCardNo:idCardNumber},
	    		type:"POST",
	    		success:function(result){
	    			patientDetailInfo=eval("(" + result + ")");
		        	patientDetailInfo=eval("("+patientDetailInfo+")");
		        	hdPersionId=patientDetailInfo.hdPersionId;
		    	    hbpCustomerMainId=patientDetailInfo.hbpCustomerMainId;
		    	    hisCardCode=patientDetailInfo.hisCardCode;
	    		},
	    		async:false//同步请求将锁住浏览器，用户其它操作必须等待请求完成才可以执行
	    	});
	    	
	    	//$("#suspend").hide();
	        //患者菜单：有身份证时跳转到首页，否则跳转到处方页
	        if(idCardNumber!=null){
	        	$('#layout_west_tree').tree({
		            url: '${path }/resources/tree_patient',
		            parentField: 'pid',
		            lines: true,
		            onClick: function (node) {
		                if (node.attributes.indexOf("http") >= 0) {
		                    var url = node.attributes;
		                    addTab({
		                        url: url,
		                        title: node.text,
		                        closable:true
		                    });
		                } else if (node.attributes) {
		                    var url = '${path }' + node.attributes;
		                    addTab({
		                        url: url,
		                        title: node.text,
		                        closable:true
		                    });
		                }
		            }
		        });
	        }else{
	        	$('#layout_west_tree').tree({
		            url: '${path }/resources/tree_patient_onlyHIS',
		            parentField: 'pid',
		            lines: true,
		            onClick: function (node) {
		                if (node.attributes.indexOf("http") >= 0) {
		                    var url = node.attributes;
		                    addTab({
		                        url: url,
		                        title: node.text,
		                        closable:true
		                    });
		                } else if (node.attributes) {
		                    var url = '${path }' + node.attributes;
		                    addTab({
		                        url: url,
		                        title: node.text,
		                        closable:true
		                    });
		                }
		            }
		        });
	        }
	        /* $('#layout_west_tree').tree({
	            url: '${path }/resources/tree_patient',
	            parentField: 'pid',
	            lines: true,
	            onClick: function (node) {
	                if (node.attributes.indexOf("http") >= 0) {
	                    var url = node.attributes;
	                    addTab({
	                        url: url,
	                        title: node.text,
	                        closable:true
	                    });
	                } else if (node.attributes) {
	                    var url = '${path }' + node.attributes;
	                    addTab({
	                        url: url,
	                        title: node.text,
	                        closable:true
	                    });
	                }
	            }
	        }); */
	        
	        //设置为选项卡Tabs
	        $('#index_tabs').tabs({
	            fit: true,
	            border: false
	        });
	        
	        // 添加首页tab页签
	        if(idCardNumber!=null){
	        	addTab({
		            url: strurl,
		            title: '首页',
		            closable: false
		        });
	        }else{
	        	addTab({
		            url: chufangUrl,
		            title: '处方',
		            closable: false
		        });
	        }
	        
	        
	        
	        
	        /* 鼠标指针离开元素时激发事件调用suspendRightPic()函数，实现隐藏悬浮列表，展示悬浮图片的效果 */
	        $("#suspend,#layout_west_tree").mouseleave(function () {
	            suspendRightPic();
	        })
	        
	    });
	    
	    /* 点击悬浮列表中的文件时，将文件的标题显示到id="index_tabs"的选项卡上 */
	    function addTab(params) {
	        var iframe = '<iframe src="' + params.url + '" frameborder="0" style="border:0;width:100%;height:99.5%;"></iframe>';
	        var t = $('#index_tabs');
	        var opts = {
	            title: params.title,
	            closable: params.closable,
	            content: iframe,
	            border: false,
	            fit: true
	        };
	        if (t.tabs('exists', opts.title)) {
	            t.tabs('select', opts.title);
	        } else {
	            t.tabs('add', opts);
	        }
	    }
	    
	    /* 点击悬浮列表的图片部分实现隐藏悬浮列表，展示悬浮图片 */
	    function suspendRightPic() {
	        $("#suspend").hide();
	    }
	
	    /* 单击悬浮图片实现隐藏悬浮图片，展示列表 */
	    function show() {
	        $("#suspend").show();
	    }
	</script>
</head>
<body>
	<div id="suspendleftPic" onclick="show()">
	</div>
	
	<div id="index_layout" class="easyui-layout" data-options="fit:true">
	
	    <div id="suspend" data-options="region:'west',split:false">
	         
	        <img  src="../images/arrow.png" style="height: 20px;width:185px;display: block;" onclick="suspendRightPic()">
	        <div class="easyui-tabs" data-options="fit:true,border:true" style="width: 185px;" >
	            <div title="患者" data-options="iconCls:'icon-ok'" class="well well-small">
	                <ul id="layout_west_tree" class="easyui-tree" data-options="animate:true">
	                </ul>
	            </div>
	        </div>
	    </div>
	    
	    <div data-options="region:'center'" style="overflow: hidden;">
	        <div id="index_tabs" class="easyui-tabs" style="overflow: hidden;">

	        </div>
	    </div>
	    
	    <div data-options="region:'south',border:false"
	         style="height: 30px; line-height: 30px; overflow: hidden; text-align: center; background-color: #eee">
	        Copyright © 2016 power by <a href="http://www.msunsoft.com/"
	                                     target="_blank">山东众阳</a>
	    </div>
	    <br>
	</div>
</body>
</html>