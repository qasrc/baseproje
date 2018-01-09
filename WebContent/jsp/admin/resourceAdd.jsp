<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function () {

        $('#pid').combotree({
            url: '${path }/resources/allTree',
            parentField: 'pid',
            lines: true,
            panelHeight: 'auto'
        });

        $('#resourceAddForm').form({
            url: '${path }/resources/add',
            onSubmit: function () {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                return isValid;
            },
            success: function (result) {
                progressClose();
                result = $.parseJSON(result);
                if (result.success) {
                    $.messager.alert("提示", result.msg, "info");
                    parent.$.modalDialog.openner_treeGrid.treegrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_treeGrid这个对象，是因为resource.jsp页面预定义好了
                    //parent.layout_west_tree.tree('reload');
                    parent.$.modalDialog.handler.dialog('close');
                }
            }
        });

    });
</script>
<div style="padding: 3px;">
    <form id="resourceAddForm" method="post">
        <table class="grid">
            <tr>
                <td>资源名称</td>
                <td><input name="name" type="text" placeholder="请输入资源名称" class="easyui-validatebox span2"
                           data-options="required:true"></td>
                <td>资源类型</td>
                <td><select name="resourcetype" class="easyui-combobox"
                            data-options="width:140,height:29,editable:false,panelHeight:'auto'">
                    <option value="1">菜单</option>
                    <option value="0">按钮</option>
                </select></td>
            </tr>
            <tr>
                <td>资源路径</td>
                <td><input name="url" type="text" placeholder="请输入资源路径" class="easyui-validatebox span2"
                           data-options="width:140,height:29"></td>
                <td>排序</td>
                <td><input name="seq" value="0" class="easyui-numberspinner" style="width: 140px; height: 29px;"
                           required="required"></td>
            </tr>
            <tr>
                <td>菜单图标</td>
                <td><input name="icon"/></td>
                <td>状态</td>
                <td><select name="status" class="easyui-combobox"
                            data-options="width:140,height:29,editable:false,panelHeight:'auto'">
                    <option value="1">正常</option>
                    <option value="0">停用</option>
                </select></td>
            </tr>
            <tr>
                <td>菜单类型</td>
                <td><select id="menu" name="menu" class="easyui-combobox"
                            data-options="width:140,height:29,editable:false,panelHeight:'auto'">
                    <option value="工作">工作</option>
                    <option value="统计">统计</option>
                    <option value="患者">患者</option>
                </select></td>
                <td>资源id</td>
                <td><input name="id" id="id" class="easyui-textbox" style="width: 140px; height: 29px;"
                           required="required"></td>
            </tr>
            <tr>
                <td>所属系统</td>
                <td>
                    <select id="sysname" name="sysname" class="easyui-combobox"
                            data-options="width:140,height:29,editable:false,panelHeight:'auto',editable:true">
                        <option value="MB">慢病</option>
                        <option value="GW">公卫</option>
                        <option value="HIS">HIS</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>上级资源</td>
                <td colspan="3"><select id="pid" name="pid" style="width: 200px; height: 29px;"></select>
                    <a class="easyui-linkbutton" href="javascript:void(0)"
                       onclick="$('#pid').combotree('clear');">清空</a></td>
            </tr>
        </table>
    </form>
</div>