<?xml version="1.0" encoding="UTF-8" ?>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="UTF-8">
    <title>Fluid Window </title>
    <link rel="stylesheet" type="text/css" href="${staticPath }/static/easyui/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="${staticPath }/static/easyui/themes/icon.css">
    <script type="text/javascript" src="${staticPath }/static/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="${staticPath }/static/easyui/jquery.easyui.min.js"></script>
</head>

<SCRIPT type="text/javascript">

    var NewBornMangernum = 0; //新生儿
    var PuerperaMangernum = 0; //产妇
    var PregnantMangernum = 0; //孕妇
    var DieaseMangernum = 0; //慢病
    $(function () {
        var title = '<table id="tab_1" class="tb_tab" style="width: 90%"> <tr> <td  id="mb" onclick="mb()" ><span >慢病</span><span style=" color:#84BFED">('
            + DieaseMangernum
            + ')</span></td><td  id="yf" onclick="yf( )">孕妇<span style=" color:#84BFED">('
            + PregnantMangernum
            + ')</span></td><td  id="cf" onclick="cf( )" >产妇<span style=" color:#84BFED">('
            + PuerperaMangernum
            + ')</span></td> <td   id="xse" onclick="xse( )" >新生儿<span style=" color:#84BFED">('
            + NewBornMangernum + ')</span></td></tr></table>';
        var msg = '<div id="mq" onmouseover="iScrollAmount=0" style=" margin:0 auto;" onmouseout="iScrollAmount=1"></div>';
        $.messager.show({
            title: title,
            msg: msg,
            showType: 'show',
            timeout: 0,
            width: '385',
            height: '250',
            draggable: true, //定义是否窗口可以拖。
            resizable: true, //定义是否窗口可以调整大小
            //minimizable:true,
            //maximizable:true,
            closable: true, //定义是否显示关闭按钮
            collapsible: true
            //定义是否显示折叠按钮
        });
        /*    mb();*/
    })
    function mb() {
        $("#mq").empty();

        if (EnableHbpm && o2oMessageData && o2oMessageData.mbglMessageList) {
            var msgs = o2oMessageData.mbglMessageList;

            var htmmb = '<div id="mq" onmouseover="iScrollAmount=0" style=" margin:0 auto;" onmouseout="iScrollAmount=1">';
            for (var i in msgs) {
                var m = msgs[i];
                htmmb += '<div style="font-size:10pt;text-decoration:underline;cursor:pointer;" onclick="addNewWinHbpm(\''
                    + m.MessageDealUrl
                    + '\')">'
                    + m.MessageContent
                    + '</div>';

            }
            htmmb += '<div style="float:right;margin-right:20px;"><input type="button" class="button" value="更多>>" onclick="selectMoreMB();" /></div>';
            htmmb += '</div>';
            $("#mq").append(htmmb);

        } else {
            var json = msgData.dieaseManger.list;
            if (json != "" || json != null) {
                var htmmb = '<div id="mq" onmouseover="iScrollAmount=0" style=" margin:0 auto;" onmouseout="iScrollAmount=1">';
                for (var i in json) {
                    htmmb += '<div style="font-size:10pt;text-decoration:underline;cursor:pointer;" onclick="addNewWin(\''
                        + json[i].CARDID
                        + '\',\''
                        + json[i].DISEASE_NAME
                        + '\',\''
                        + json[i].PERSONALID
                        + '\')">'
                        + json[i].CHECK_TIME
                        + ' '
                        + json[i].NAME
                        + '在'
                        + json[i].ORGNAME
                        + '确诊为'
                        + json[i].DISEASE_NAME
                        + '</div>';
                }
                htmmb += '<div style="float:right;margin-right:20px;"><input type="button" class="button" value="更多>>" onclick="selectMoreMB();" /></div>';
                htmmb += '</div>';
                $("#mq").append(htmmb);
            }

        }

        $("#cf").css("background", "#F6F7FB");
        $("#yf").css("background", "#F6F7FB");
        $("#mb").css("background", "white");
        $("#xse").css("background", "#F6F7FB");
        document.getElementById("mb").className = "messageTabTitleOn";
        document.getElementById("cf").className = "messageTabTitleOff";
        document.getElementById("yf").className = "messageTabTitleOff";
        document.getElementById("xse").className = "messageTabTitleOff";
    }
    function cf() {
        $("#mq").empty();
        if (!msgData || !msgData.puerperaManger || !msgData.puerperaManger.list) {
            return;
        }
        var jsoncf = msgData.puerperaManger.list;

        if (jsoncf != "" || jsoncf != null) {
            var htmcf = '<div id="mq" onmouseover="iScrollAmount=0" style="margin:0 auto;" onmouseout="iScrollAmount=1">';
            for (var i in jsoncf) {
                htmcf += '<div style="font-size:10pt;text-decoration:underline;cursor:pointer;" onclick="addNewWincf()">'
                    + jsoncf[i].CHECK_TIME
                    + ' '
                    + jsoncf[i].NAME
                    + '在'
                    + jsoncf[i].ORGNAME + '诊断为产妇' + '</div>';
            }
            htmcf += '</div>';
            $("#mq").append(htmcf);
        }
        $("#cf").css("background", "white");
        $("#yf").css("background", "#F6F7FB");
        $("#mb").css("background", "#F6F7FB");
        $("#xse").css("background", "#F6F7FB");
        document.getElementById("mb").className = "messageTabTitleOff";
        document.getElementById("cf").className = "messageTabTitleOn";
        document.getElementById("yf").className = "messageTabTitleOff";
        document.getElementById("xse").className = "messageTabTitleOff";
    }
    function yf() {
        $("#mq").empty();
        //var PregnantManger = '${PregnantManger}';
        if (!msgData || !msgData.pregnantManger || !msgData.pregnantManger.list) {
            return;
        }
        var jsonyf = msgData.pregnantManger.list;

        if (jsonyf != "" || jsonyf != null) {
            var htmyf = '<div id="mq" onmouseover="iScrollAmount=0" style="margin:0 auto;" onmouseout="iScrollAmount=1">';
            for (var i in jsonyf) {
                htmyf += '<div style="font-size:10pt;text-decoration:underline;cursor:pointer;" onclick="addNewWinyf()">'
                    + jsonyf[i].CHECK_TIME
                    + ' '
                    + jsonyf[i].NAME
                    + '在'
                    + jsonyf[i].ORGNAME + '诊断为孕妇</div>';
            }
            htmyf += '</div>';
            $("#mq").append(htmyf);
        }
        $("#yf").css("background", "white");
        $("#cf").css("background", "#F6F7FB");
        $("#mb").css("background", "#F6F7FB");
        $("#xse").css("background", "#F6F7FB");
        document.getElementById("mb").className = "messageTabTitleOff";
        document.getElementById("cf").className = "messageTabTitleOff";
        document.getElementById("yf").className = "messageTabTitleOn";
        document.getElementById("xse").className = "messageTabTitleOff";
    }
    function xse() {
        $("#mq").empty();
        //var NewBornManger = '${NewBornManger}';
        if (!msgData || !msgData.newBornManger || !msgData.newBornManger.list) {
            return;
        }
        var jsonxse = msgData.newBornManger.list;

        if (jsonxse != "" || jsonxse != null) {
            var htmxse = '<div id="mq" onmouseover="iScrollAmount=0" style="margin:0 auto;" onmouseout="iScrollAmount=1">';
            for (var i in jsonxse) {
                htmxse += '<div style="font-size:10pt;text-decoration:underline;cursor:pointer;" onclick="addNewWinxse()">'
                    + jsonxse[i].CHECK_TIME
                    + ' '
                    + jsonxse[i].NAME
                    + '在'
                    + jsonxse[i].ORGNAME + '成为新生儿</div>';
            }
            htmxse += '</div>';
            $("#mq").append(htmxse);
        }
        $("#xse").css("background", "white");
        $("#cf").css("background", "#F6F7FB");
        $("#yf").css("background", "#F6F7FB");
        $("#mb").css("background", "#F6F7FB");
        document.getElementById("mb").className = "messageTabTitleOff";
        document.getElementById("cf").className = "messageTabTitleOff";
        document.getElementById("yf").className = "messageTabTitleOff";
        document.getElementById("xse").className = "messageTabTitleOn";
    }
</SCRIPT>

<BODY>
</BODY>
</html>

