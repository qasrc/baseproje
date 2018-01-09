<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<title>患者首页</title>
<!-- [jQuery] -->
<script type="text/javascript"
	src="${staticPath }/static/easyui/jquery.min.js" charset="utf-8"></script>
<!-- [EasyUI] -->
<link id="easyuiTheme" rel="stylesheet" type="text/css"
	href="${staticPath }/static/easyui/themes/default/easyui.css" />
<link id="easyuiTheme" rel="stylesheet" type="text/css"
	href="${staticPath }/static/easyui/themes/icon.css" />
<link id="pageStyleFile" rel="stylesheet" type="text/css"
	href="${staticPath }/styles/patient/patienthome.css" />
<script type="text/javascript"
	src="${staticPath }/static/easyui/jquery.easyui.min.js" charset="utf-8"></script>
<script type="text/javascript"
	src="${staticPath }/static/easyui/locale/easyui-lang-zh_CN.js"
	charset="utf-8"></script>
<script type="text/javascript"
	src="${staticPath }/static/msunsoftlib.js" charset="utf-8"></script>
<script type="text/javascript"
	src="${staticPath }/scripts/patient/patient.js" charset="utf-8"></script>

<style type="text/css">
</style>
<script type="text/javascript">
	var patCardId = "${idcardNo}";
    var phsService = '${phsService}';
    var healthService = '${healthService}';
    var msunService = '${msunService}';
	var isOldMan = "${isOldMan}";
	var birthday = "${birthday}";
	var patTreatInfo = ${patTreatInfo};
	var timelinestart = "${startDateStr}";
</script>
</head>
<body style="height: 100%;">
	<div id="divall">
		<div id="divpatinfo">
			<table style="width: 100%; text-align: left;">
				<tr>
					<td style="width: 20%">姓名：${name }</td>
					<td style="width: 20%">性别：${sex }</td>
					<td style="width: 20%">出生日期：${birthday }(<span id="spanage"></span>)</td>
					<td>健康卡号：${healthCardNo }</td>
				</tr>
				<tr>
					<td>身份证号：${idcardNo }</td>
					<td>健康档案号:${personalId }</td>
					<td>家庭签约类型：</td>
					<td>住址：${address }</td>
				</tr>
			</table>
		</div>



		<!-- 患者概况 -->
		<div id="pathealthInfo">
			<div
				style="padding: 0 3px 0 3px; margin: 3px 10px 3px 0px; vertical-align: middle; font-family: 宋体, Arial, Helvetica, sans-serif; font-size: 13px; font-weight: bold; color: #586487; font-weight: bold; text-align: left;">近期基本情况</div>
			<table style="width: 100%; font-size: 13px;" class="CommTableStyle1">
				<tr>
					<td style="width: 10%; font-weight: bold;">身高：${height }</td>
					<td style="width: 10%; font-weight: bold;">体重：${weight }</td>
					<td style="width: 10%; font-weight: bold;">心率：${heartRate }</td>
					<td style="width: 10%; font-weight: bold;">脉搏：${heat }</td>
					<td style="width: 10%; font-weight: bold;">呼吸：${respiratory }</td>
					<td style="width: 10%; font-weight: bold;">腰围：${waistline }</td>
					<td style="width: 20%; font-weight: bold;">吸烟：${smoke }</td>
					<td style="width: 20%; font-weight: bold;">喝酒：${drink }</td>
				</tr>
				<tr>
					<td colspan="2" style="font-weight: bold;">过敏史：${allergy }</td>
					<td colspan="3" style="font-weight: bold;">既往史:</td>
					<td colspan="2" style="font-weight: bold;">家族史:${jzs }</td>
					<td style="font-weight: bold;">其他情况：</td>
				</tr>
			</table>
		</div>

		<!-- 分屏 -->
		<div id="divContent" style="display: block;">
			<table style="width: 100%; height: 100%;">
				<tr style="width: 100%; height: 100%;">
					<td style="width: 55%; height: 50%;">
						<div id="divLeft" style="display: block;">


							<div class="easyui-accordion" data-options="multiple:true"
								style="width: 100%;">
								<div title="诊疗服务"
									data-options="iconCls:'icon-ok',collapsed:false"
									style="overflow: auto; padding: 10px;">
									<!-- 患者诊疗 -->
									<div id="patClinicinfo" style="overflow: auto; display: block;">
										<table style="width: 100%;" class="CommTableStyle1">
											<tr>
												<td style="width: 15%;">您可以进行：</td>
												<td><a>处方</a><a>计费</a> <a>查看健康档案</a></td>
											</tr>
											<tr>
												<td style="width: 15%;">近期门诊：</td>
												<td><span id="nearMzinfo"></span></td>
											</tr>
											<tr>
												<td style="width: 15%;">近期住院：</td>
												<td><span id="nearzyinfo"></span></td>
											</tr>
											<tr>
												<td style="width: 15%;">近期会诊：</td>
												<td>正在获取...</td>
											</tr>
											<tr>
												<td style="width: 15%;">当前状态：</td>
												<td></td>
											</tr>
										</table>
									</div>
								</div>
								<div title="签约和慢病管理"
									data-options="iconCls:'icon-ok',collapsed:false"
									style="padding: 10px;">
									<div id="patSignandmb" style="overflow: auto; display: block;">
										<table style="width: 100%;" class="CommTableStyle1">
											<tr>
												<td style="width: 15%;">医生签约：</td>
												<td>正在获取...</td>
											</tr>
											<tr>
												<td style="width: 15%;">签约服务情况：</td>
												<td>正在获取...</td>
											</tr>
											<tr>
												<td style="width: 15%;">高血压管理：</td>
												<td>正在获取...</td>
											</tr>
											<tr>
												<td style="width: 15%;">其他：</td>
												<td></td>
											</tr>
										</table>
									</div>
								</div>
								<div title="公共卫生"
									data-options="iconCls:'icon-ok',collapsed:false"
									style="padding: 10px;">
									<div id="patpubhealthy" style="overflow: auto; display: block;">
										<table style="width: 100%;" class="CommTableStyle1">
											<tr>
												<td style="width: 15%;">居民服务：</td>
												<td></td>
											</tr>
											<tr>
												<td style="width: 15%;">随访情况：</td>
												<td></td>
											</tr>
											<tr>
												<td style="width: 15%;">检查情况：</td>
												<td></td>
											</tr>
											<tr>
												<td style="width: 15%;">其他：</td>
												<td></td>
											</tr>
										</table>
									</div>
								</div>
							</div>
						</div>
					</td>
					<td style="width: 45%;">
						<div id="divRight" style="display: block; overflow-y: auto;"
							class="sjzcss"></div>
					</td>
				</tr>
			</table>

		</div>

	</div>
	<!-- divall -->
</body>
</html>