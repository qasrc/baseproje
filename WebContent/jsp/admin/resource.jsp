<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/commons/basejs.jsp" %>
    <meta http-equiv="X-UA-Compatible" content="edge"/>
    <title>资源管理</title>
    <script type="text/javascript">
        var treeGrid;
        $(function () {
            treeGrid = $('#treeGrid').treegrid({
                url: '${path }/resources/treeGrid',
                idField: 'id',
                treeField: 'name',
                parentField: 'pid',
                fit: true,
                fitColumns: false,
                border: false,
                columns: [[{
                    title: '编号',
                    field: 'id',
                    width: '6%'
                }, {
                    title: '资源名称',
                    field: 'name',
                    width: '20%'
                }, {
                    title: '资源路径',
                    field: 'url',
                    width: '28%'
                }, {
                    title: '排序',
                    field: 'seq',
                    width: '3%'
                }, {
                    title: '图标',
                    field: 'iconCls',
                    width: '6%'
                }, {
                    title: '资源类型',
                    field: 'resourcetype',
                    width: '6%',
                    formatter: function (value, row, index) {
                        switch (value) {
                            case 1:
                                return '菜单';
                            case 0:
                                return '按钮';
                        }
                    }
                }, {
                    title: '菜单类型',
                    field: 'menu',
                    width: '6%'
                }, {
                    title: '所属系统',
                    field: 'sysname',
                    width: '6%',
                    formatter: function (value) {
                        switch (value) {
                            case 'GW':
                                return '公卫';
                            case 'MB':
                                return '慢病';
                            case 'HIS':
                                return 'HIS';
                        }
                    }
                }, {
                    field: 'status',
                    title: '状态',
                    width: '4%',
                    formatter: function (value, row, index) {
                        switch (value) {
                            case 1:
                                return '正常';
                            case 0:
                                return '<span style="color: red;">停用</span>';
                        }
                    }
                }, {
                    field: 'action',
                    title: '操作',
                    width: '15%',
                    formatter: function (value, row, index) {
                        var str = '';
                        <shiro:hasAnyRoles name="管理员">
                        str += $.formatString('<a href="javascript:void(0)" class="resource-easyui-linkbutton-edit" data-options="plain:true,iconCls:\'icon-edit\'" onclick="editFun(\'{0}\');" >编辑</a>', row.id);
                        </shiro:hasAnyRoles>
                        <shiro:hasAnyRoles name="管理员">
                        str += '&nbsp;&nbsp;|&nbsp;&nbsp;';
                        str += $.formatString('<a href="javascript:void(0)" class="resource-easyui-linkbutton-del" data-options="plain:true,iconCls:\'icon-cancel\'" onclick="deleteFun(\'{0}\');" >删除</a>', row.id);
                        </shiro:hasAnyRoles>
                        return str;
                    }
                }]],
                onLoadSuccess: function (data) {
                    $('.resource-easyui-linkbutton-edit').linkbutton({text: '编辑', plain: true, iconCls: 'icon-edit'});
                    $('.resource-easyui-linkbutton-del').linkbutton({text: '删除', plain: true, iconCls: 'icon-cancel'});
                },
                toolbar: '#toolbar'
            });
        });

        function editFun(id) {
            if (id != undefined) {
                treeGrid.treegrid('select', id);
            }
            var node = treeGrid.treegrid('getSelected');
            if (node) {
                parent.$.modalDialog({
                    title: '编辑',
                    width: 500,
                    height: 350,
                    href: '${path }/resources/editPage?id=' + node.id,
                    buttons: [{
                        text: '确定',
                        handler: function () {
                            parent.$.modalDialog.openner_treeGrid = treeGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                            var f = parent.$.modalDialog.handler.find('#resourceEditForm');
                            f.submit();
                        }
                    }]
                });
            }
        }

        function deleteFun(id) {
            if (id != undefined) {
                treeGrid.treegrid('select', id);
            }
            var node = treeGrid.treegrid('getSelected');
            if (node) {
                parent.$.messager.confirm('询问', '您是否要删除当前资源？删除当前资源会连同子资源一起删除!', function (b) {
                    if (b) {
                        progressLoad();
                        $.post('${pageContext.request.contextPath}/resources/delete', {
                            id: node.id
                        }, function (result) {
                            if (result.success) {
                                parent.$.messager.alert('提示', result.msg, 'info');
                                treeGrid.treegrid('reload');
                                parent.layout_west_tree.tree('reload');
                            }
                            progressClose();
                        }, 'JSON');
                    }
                });
            }
        }

        function addFun() {
            parent.$.modalDialog({
                title: '添加',
                width: 500,
                height: 350,
                href: '${path }/resources/addPage',
                buttons: [{
                    text: '添加',
                    handler: function () {
                        parent.$.modalDialog.openner_treeGrid = treeGrid;//因为添加成功之后，需要刷新这个treeGrid，所以先预定义好
                        var f = parent.$.modalDialog.handler.find('#resourceAddForm');
                        f.submit();
                    }
                }]
            });
        }
    </script>
</head>
<body>
<div class="easyui-layout" data-options="fit:true,border:false">
    <div data-options="region:'center',border:false" style="overflow: hidden;">
        <table id="treeGrid"></table>
    </div>
</div>

<div id="toolbar" style="display: none;">
    <%--<shiro:hasPermission name="/resources/add">
        <a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-add'">添加</a>
    </shiro:hasPermission>--%>
    <shiro:hasAnyRoles name="管理员">
        <a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton"
           data-options="plain:true,iconCls:'icon-add'">添加</a>
    </shiro:hasAnyRoles>
</div>
</body>
</html>