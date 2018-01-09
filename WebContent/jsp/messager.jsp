<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">
	var htmmb;//慢病显示
	var htmyf;//孕妇显示
	var htmcf;//产妇显示
	var htmxs;//新生儿显示
	var dieaseObj=null;
	var DieaseMangernum=null;
	var PregnantMangernum=null;
	var PuerperaMangernum=null;
	var NewBornMangernum=null;
    var phsServiceUrl = '${phsService}';
	$(function(){
		$.get('${path}/warn/patientList?userSysId=${userSysId}&mbUserId=${mbUserId}&mtcId=${mtcId}&pUserId=${pUserId}&queryType=2',function(result){
			//JSON的字符串解析成JSON数据格式
			var obj2 = eval('('+result+')');
			obj2=eval('('+obj2+')');
			dieaseObj=obj2.mbglMessageList;//获得慢病列表对象
			DieaseMangernum=obj2.hbpmessageCount;//获得慢病病人的数量
			if(dieaseObj != "" || dieaseObj != null){
				htmmb = '<div id="mn" onmouseover="iScrollAmount=0" style=" margin:0 auto;" onmouseout="iScrollAmount=1">';
				for (var i in dieaseObj) {
					var m=dieaseObj[i];
					htmmb += '<div style="font-size:10pt;text-decoration:underline;cursor:pointer;" onclick="addNewWinHbpm(\''
	                    + m.MessageDealUrl + '\')">'
	                    + m.MessageContent + '</div>';
	            }
				htmmb += '<div style="float:right;margin-right:20px;"><input type="button" class="button" value="更多>>" onclick="selectMoreMB();" /></div>';
	            htmmb += '</div>';
			}
			$.get('${path}/warn/warnInfo?bdUserId=${bdUserId}',function(result){
				//JSON的字符串解析成JSON数据格式
				var obj1 = eval('('+result+')');
				obj1=eval('('+obj1+')');
                if (obj1.pregnantManger != undefined && obj1.puerperaManger != undefined && obj1.newBornManger != undefined) {
                    PregnantMangernum = obj1.pregnantManger.pregnantMangerNum;
                    PuerperaMangernum = obj1.puerperaManger.puerperaMangerNum;
                    NewBornMangernum = obj1.newBornManger.newBornMangerNum;
                    messager(DieaseMangernum, PregnantMangernum, PuerperaMangernum, NewBornMangernum);
                    pregnantObj = obj1.pregnantManger.list;
                    puerperaObj = obj1.puerperaManger.list;
                    newBornObj = obj1.newBornManger.list;
                    /* rgba(0,0,0,0) 改为red */
                    if (dieaseObj != "" || dieaseObj != null) {
                        $('#mb').css('background-color', '#FFFFFF');
                        $('#yf').css('background-color', '#CCFFFF');
                        $('#cf').css('background-color', '#CCFFFF');
                        $('#xs').css('background-color', '#CCFFFF');
                        $("#mq").append(htmmb);
                    }

                    //获取与孕妇相关的数据
                    if (pregnantObj != "" || pregnantObj != null) {
                        htmyf = '<div id="mn" onmouseover="iScrollAmount=0" style=" margin:0 auto;" onmouseout="iScrollAmount=1">';
                        for (var i in pregnantObj) {
                            htmyf += '<div style="font-size:10pt;text-decoration:underline;cursor:pointer;" onclick="addNewWinyf()">'
                                + pregnantObj[i].CHECK_TIME
                                + ' '
                                + pregnantObj[i].NAME
                                + '在'
                                + pregnantObj[i].ORGNAME + '诊断为孕妇。' + '</div>';
                        }
                        htmyf += '</div>';
                    }

                    //获取与产妇相关的数据
                    if (puerperaObj != "" || puerperaObj != null) {
                        htmcf = '<div id="mn" onmouseover="iScrollAmount=0" style=" margin:0 auto;" onmouseout="iScrollAmount=1">';
                        for (var i in puerperaObj) {
                            htmcf += '<div style="font-size:10pt;text-decoration:underline;cursor:pointer;" onclick="addNewWincf()">'
                                + puerperaObj[i].CHECK_TIME
                                + ' '
                                + puerperaObj[i].NAME
                                + '在'
                                + puerperaObj[i].ORGNAME + '诊断为产妇。' + '</div>';
                        }
                        htmcf += '</div>';
                    }

                    //获取与新生儿相关的数据
                    if (newBornObj != "" || newBornObj != null) {
                        htmxs = '<div id="mn" onmouseover="iScrollAmount=0" style=" margin:0 auto;" onmouseout="iScrollAmount=1">';
                        for (var i in newBornObj) {
                            htmxs += '<div style="font-size:10pt;text-decoration:underline;cursor:pointer;" onclick="addNewWinxse()">'
                                + newBornObj[i].CHECK_TIME
                                + ' '
                                + newBornObj[i].NAME
                                + '在'
                                + newBornObj[i].ORGNAME + '成为新生儿</div>';
                        }
                        htmxs += '</div>';
                    }
                }
			});
		});
		
		
		function messager(DieaseMangernum,PregnantMangernum,PuerperaMangernum,NewBornMangernum){
			html='<table id="tab_1" class="tb_tab" style="width: 90%"> <tr> <td id="mb" style="cursor:pointer;" onclick="mb(htmmb)"><span style="color:black;">慢病</span><span style=" color:#84BFED">(' + DieaseMangernum + ')</span></td><td id="yf" style="cursor:pointer;" onclick="yf(htmyf)"><span style="color:black;cursor:pointer;">孕妇</span><span style=" color:#84BFED">(' + PregnantMangernum + ')</span></td><td id="cf" style="cursor:pointer;" onclick="cf(htmcf)"><span style="color:black;cursor:pointer;">产妇</span><span style=" color:#84BFED">(' + PuerperaMangernum + ')</span></td><td id="xs" style="cursor:pointer;" onclick="xs(htmxs)"><span style="color:black;cursor:pointer;">新生儿</span><span style=" color:#84BFED">(' + NewBornMangernum + ')</span></td></tr></table>';
			htm = '<div id="mq" onmouseover="iScrollAmount=0" style=" margin:0 auto;" onmouseout="iScrollAmount=1"></div>';
			$.messager.show({
				title:html,
				msg:htm,
				showSpeed:'slow',
				timeout:0,
				showType:'slide',
				draggable: false, 
				width:400,
				height:225,
				collapsible: true,
				closable: true
			});
		}
	});
	

	function mb(param){
		$('#mb').css('background-color','#FFFFFF');
		$('#yf').css('background-color','#CCFFFF');
		$('#cf').css('background-color','#CCFFFF');
		$('#xs').css('background-color','#CCFFFF');
		$("#mq").empty();
		$("#mq").append(param);
	}
	
	function yf(param){
		$('#mb').css('background-color','#CCFFFF');
		$('#yf').css('background-color','#FFFFFF');
		$('#cf').css('background-color','#CCFFFF');
		$('#xs').css('background-color','#CCFFFF');
		$("#mq").empty();
		$("#mq").append(param);
	}
	
	function cf(param){
		$('#mb').css('background-color','#CCFFFF');
		$('#yf').css('background-color','#CCFFFF');
		$('#cf').css('background-color','#FFFFFF');
		$('#xs').css('background-color','#CCFFFF');
		$("#mq").empty();
		$("#mq").append(param);
	}
	
	function xs(param){
		$('#mb').css('background-color','#CCFFFF');
		$('#yf').css('background-color','#CCFFFF');
		$('#cf').css('background-color','#CCFFFF');
		$('#xs').css('background-color','#FFFFFF');
		$("#mq").empty();
		$("#mq").append(param);
	}
	
	//获得一个慢病病人的详细信息
	function addNewWinHbpm(url) {
		var person=window.open (url, "个人慢病提醒", "height=140, width=235, top=200, left=575,menubar=no, scrollbars=no, resizable=no, location=no, status=no");
	}
	
	//点击首页右下角上的更多按钮时所调用的相关函数
	function selectMoreMB(){
        var win = window.open("${BAILINGGJK}/ncdms/hbpCustomerMain/jumpToPopAll.action", "慢病提醒", "height=320, width=925, top=125, left=200,menubar=no, scrollbars=no, resizable=no, location=no, status=no");
		//win.document.title = "慢病提醒";
	}
	
	//点击每条孕妇记录弹出一个对话框
	function addNewWinyf() {
	    var url = phsServiceUrl + "/person/pregnantMessage.action?cardid=" + 1 + "&pregnantName=" + 1;
	    window.open(url, "孕妇提醒", "height=140, width=235, top=200, left=575,menubar=no, scrollbars=no, resizable=no, location=no, status=no");
	}
	
	//点击每条产妇记录弹出一个对话框
	function addNewWincf() {
	    var url = phsServiceUrl + "/person/puerperaMessage.action?cardid=" + 1 + "&puerperaName=" + 1;
	    window.open(url, "产妇提醒", "height=140, width=235, top=200, left=575,menubar=no, scrollbars=no, resizable=no, location=no, status=no");
	}
	
	//点击每条新生儿记录弹出一个对话框
	function addNewWinxse() {
	    var url = phsServiceUrl + "/person/newbornMessage.action?cardid=" + 1 + "&newbornName=" + 1;
	    window.open(url, "新生儿提醒", "height=140, width=250, top=200, left=575,menubar=no, scrollbars=no, resizable=no, location=no, status=no");
	}
	
</script>
