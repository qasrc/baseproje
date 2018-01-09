<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<!DOCTYPE html>
<html>
<head>

    <%@ include file="/commons/basejs.jsp" %>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>主页</title>

    <script type="text/javascript" src="${staticPath }/static/echarts.min.js" charset="utf-8"></script>

    <script type="text/javascript">
        var index_layout;
        var index_tabs;
        var layout_west_tree;

        //首页顶部中间错误提示信息
        function showMessager(info) {
            $.messager.show({
                title: '提示',
                msg: info,
                timeout: 20000,
                showType: 'slide',
                style: {
                    right: '',
                    top: document.body.scrollTop + document.documentElement.scrollTop,
                    bottom: ''

                }
            })
        }


        //打开新的Table
        function addTab(params) {
            var iframe = '<iframe src="' + params.url + '" frameborder="0" style="border:0;width:100%;height:99.5%;"></iframe>';
            var t = $('#index_tabs');
            var opts = {
                title: params.title,
                closable: true,
                iconCls: params.iconCls,
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


        //退出登录
        function logout() {
            $.messager.confirm('提示', '确定要退出?', function (r) {
                if (r) {
                    progressLoad();
                    $.post('${path }/logout', function (result) {
                        if (result.success) {
                            progressClose();
                            window.location.href = '${path }';
                        }
                    }, 'json');
                }
            });
        }

        //修改密码
        function editUserPwd() {
            parent.$.modalDialog({
                title: '修改密码',
                width: 300,
                height: 250,
                href: '${path }/user/editPwdPage',
                buttons: [{
                    text: '确定',
                    handler: function () {
                        var f = parent.$.modalDialog.handler.find('#editUserPwdForm');
                        f.submit();
                    }
                }]
            });
        }


        $(function () {

            index_layout = $('#index_layout').layout({
                fit: true
            });

            index_tabs = $('#index_tabs').tabs({
                fit: true,
                border: false,
                tools: [{
                    iconCls: 'icon-home',
                    handler: function () {
                        index_tabs.tabs('select', 0);
                    }
                }, {
                    iconCls: 'icon-refresh',
                    handler: function () {
                        var index = index_tabs.tabs('getTabIndex', index_tabs.tabs('getSelected'));
                        index_tabs.tabs('getTab', index).panel('open').panel('refresh');
                    }
                }, {
                    iconCls: 'icon-del',
                    handler: function () {
                        var index = index_tabs.tabs('getTabIndex', index_tabs.tabs('getSelected'));
                        var tab = index_tabs.tabs('getTab', index);
                        if (tab.panel('options').closable) {
                            index_tabs.tabs('close', index);
                        }
                    }
                }]
            });

            //工作菜单
            layout_west_tree = $('#layout_west_tree').tree({
                url: '${path }/resources/tree',
                parentField: 'pid',
                animate: true,
                lines: true,
                onClick: function (node) {
                    if (node.attributes != null) {
                        if (node.attributes.indexOf("http") >= 0) {
                            var url = node.attributes;
                            addTab({
                                url: url,
                                title: node.text,
                                iconCls: node.iconCls
                            });
                        } else if (node.attributes) {
                            var url = '${path }' + node.attributes;
                            addTab({
                                url: url,
                                title: node.text,
                                iconCls: node.iconCls
                            });
                        }
                    }
                }
            });

        });

    </script>

</head>
<body >
<div id="loading"
     style="position: fixed;top: -50%;left: -50%;width: 200%;height: 200%;background: #fff;z-index: 100;overflow: hidden;">
    <img src="${staticPath }/static/style/images/ajax-loader.gif"
         style="position: absolute;top: 0;left: 0;right: 0;bottom: 0;margin: auto;"/>
</div>
<div id="index_layout">

    <div data-options="region:'north',split:true" style="background-color: #037cec;overflow: hidden;height: 10%;">

        <div style="float: left;">
            <img src="${staticPath}/images/logoAll.png"
                 style="width: 110px;height: 40px;margin-top: 10px;margin-left: 10px"/>
        </div>
        <div style="float: left;">
            <p style="color:white;font-size: large;font-weight: bold;margin-left: 5px;margin-top: 18px;">xxxxxxxxx</p>
        </div>
        <%--登录者信息--%>
        <div style="float:right;background-color: #3091f2;width: 20%;height: 100%">
            <div style="margin-left: 10%;margin-top:3%;float:left">
                <img src="${staticPath}/images/signperson.png" style="width:40px;height: 40px" class="img-circle">
            </div>
            <div style="margin-top: 3%;margin-left: 5%;float: left;">
                <p style="color:white;margin-bottom: 10px;font-weight: bold;">${msg}</p>
                <p style="color:white;font-weight: lighter">欢迎登录系统！</p>
            </div>
            <div style="float: right;margin-top: 4%;margin-right: 5px">
                <span onmouseover="toPointer(this)" id="logout" onclick="logout()" style="color: white;font-size: 30px"
                      class="glyphicon glyphicon-off"></span>
            </div>
            <div style="float: right;margin-top:4%;margin-right:10px">
                <span onmouseover="toPointer(this)" id="showMsg" onclick="showDoctorNeedReciInfo()"
                      style="color:white;font-size:30px" class="glyphicon glyphicon-comment"> </span>
                <span id="unReadMailCount" class="badge"></span>
            </div>

        </div>
    </div>
    <div data-options="region:'west',split:true" title="菜单"
         style="width: 16%;padding:0;overflow-x: hidden;">
        <div id="west_tree_id" >
            <ul id="layout_west_tree"></ul>
        </div>
    </div>

    <div data-options="region:'center'" style="overflow: hidden;">
        <div id="index_tabs" style="overflow: hidden;">
            <div title="首页" data-options="border:false" style="overflow: hidden;">
                <h1>hello world</h1>
            </div>
        </div>
    </div>

    <div data-options="region:'south',border:false"
         style="height: 30px;line-height:30px; overflow: hidden;text-align: center;background-color: #eee">Copyright
        ©
        2016 power by <a href="http://www.msunsoft.com/" target="_blank">XXXXX</a></div>
</div>


</body>

</html>