<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/commons/global.jsp" %>
<script type="text/javascript">
    $(function() {

        $('#pid').combotree({
            url : '${path }/resources/tree',
            parentField : 'pid',
            lines : true,
            panelHeight : 'auto',
            value : '${resource.pid}'
        });
        
        $('#resourceEditForm').form({
            url : '${path }/resources/edit',
            onSubmit : function() {
                progressLoad();
                var isValid = $(this).form('validate');
                if (!isValid) {
                    progressClose();
                }
                return isValid;
            },
            success : function(result) {
                progressClose();
                result = $.parseJSON(result);
                if (result.success) {
                    parent.$.modalDialog.openner_treeGrid.treegrid('reload');//之所以能在这里调用到parent.$.modalDialog.openner_treeGrid这个对象，是因为resource.jsp页面预定义好了
                    parent.layout_west_tree.tree('reload');
                    parent.$.modalDialog.handler.dialog('close');
                }
            }
        });

        $("#status").val('${resource.status}');
        $("#resourcetype").val('${resource.resourcetype}');
    });
</script>
<div style="padding: 3px;">
    <form id="resourceEditForm" method="post">
        <table  class="grid">
            <tr>
                <td>资源名称</td>
                <td><input name="id" type="hidden"  value="${resource.id}" >
                <input name="name" type="text" placeholder="请输入资源名称" value="${resource.name}" class="easyui-validatebox span2" data-options="required:true" ></td>
                <td>资源类型</td>
                <td><select id="resourcetype" name="resourcetype" class="easyui-combobox" data-options="width:140,height:29,editable:false,panelHeight:'auto'">
                    <option value="1" <c:if test="${resource.resourcetype==1}">selected="selected"</c:if>>菜单</option>
                    <option value="0" <c:if test="${resource.resourcetype==0}">selected="selected"</c:if>>按钮</option>
                </select></td>
            </tr>
            <tr>
                <td>资源路径</td>
                <td><input name="url" type="text" value="${resource.url}" placeholder="请输入资源路径" class="easyui-validatebox span2" ></td>
                <td>排序</td>
                <td><input name="seq" value="${resource.seq}" class="easyui-numberspinner"
                           style="width: 140px; height: 29px;" required="required"></td>
            </tr>
            <tr>
                <td>菜单图标</td>
                <td ><input  name="icon" value="${resource.icon}"/></td>
                <td>状态</td>
                <td ><select id="status" name="status" class="easyui-combobox" data-options="width:140,height:29,editable:false,panelHeight:'auto'">
                    <option value="1" <c:if test="${resource.status==1}">selected="selected"</c:if>>正常</option>
                    <option value="0" <c:if test="${resource.status==0}">selected="selected"</c:if>>停用</option>
                </select></td>
            </tr>

            <tr>
                <td>菜单类型</td>
                <td><select id="menu" name="menu" class="easyui-combobox"
                            data-options="width:140,height:29,editable:false,panelHeight:'auto'">
                    <option value="工作" <c:if test="${resource.menu=='工作'}">selected="selected"</c:if>>工作</option>
                    <option value="统计" <c:if test="${resource.menu=='统计'}">selected="selected"</c:if>>统计</option>
                    <option value="患者" <c:if test="${resource.menu=='患者'}">selected="selected"</c:if>>患者</option>
                </select></td>
                <td>所属系统</td>
                <td>
                    <select id="sysname" name="sysname" class="easyui-combobox"
                            data-options="width:140,height:29,editable:false,panelHeight:'auto',editable:true">
                        <option value="GW" <c:if test="${resource.sysname=='GW'}">selected="selected"</c:if>>公卫</option>
                        <option value="MB" <c:if test="${resource.sysname=='MB'}">selected="selected"</c:if>>慢病</option>
                        <option value="HIS" <c:if test="${resource.sysname=='HIS'}">selected="selected"</c:if>>HIS
                        </option>
                    </select>
                </td>
            </tr>
            <tr>
                <td>上级资源</td>
                <td colspan="3"><select id="pid" name="pid" style="width: 200px; height: 29px;"></select>
                <a class="easyui-linkbutton" href="javascript:void(0)" onclick="$('#pid').combotree('clear');" >清空</a></td>
            </tr>
        </table>
    </form>
</div>
