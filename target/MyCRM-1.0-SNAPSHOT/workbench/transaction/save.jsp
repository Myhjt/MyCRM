<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html;charset=utf-8" %>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
	Map<String, String> pMap = (Map<String, String>) application.getAttribute("pMap");
	Set<String> keySet = pMap.keySet();
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/zTree_v3-master/css/zTreeStyle/zTreeStyle.css">

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
</head>

	<script>
		let json={
		<%
			for(String key:keySet){

		%>
			"<%=key%>":"<%=pMap.get(key)%>",
		<%
			}
		%>
		}
	</script>
	<%--

	关于阶段和可能性，
		一个阶段对应一个可能性
		stage 			possibility
		key				value
		01资质分析		10
		...
		07成交			100

		Stage2Possibility.properties表示的是阶段和可能性之间的关系
	--%>
	<script type="text/javascript">

		//市场活动源
		function showSearchActivityModal(){
			$("#findMarketActivity").modal("show");
			$("#activityList").empty()

		}

		//联系人名称
		function showSearchContactsModal(){
			$("#findContacts").modal("show");
			$("#contactsList").empty()
		}
		$(function(){
			$("#create-transactionStage").change(function (){
				let key = this.value;
				$("#create-possibility").val(json[key])
			})
			//自动补全
			$("#create-customerName").typeahead({
				source:function (query,process){
					$.post(
							"workbench/transaction/getCustomerNames.do",
							{"name":query},
							function (data){
								process(data)
							},
							"json"
					)
				},
				delay:1000
			})


			//市场活动源查询窗口按下回车
			$("#findMarketActivity").keydown(function(event){
				if(event.keyCode===13){
					let activityName = $.trim($("#search-activityName").val())
					if(activityName!==''){
						$.ajax({
							url:"workbench/transaction/getActivityListByActivityName.do",
							data:{activityName:activityName},
							dataType:"json",
							type:"get",
							success:function(data){
								let html =""
								$.each(data,function(index,value){
									html+='<tr><td><input type="radio" value="'+value.id+'" name="activity"/></td>'+
										  '<td >'+value.name+'</td>'+
										  '<td>'+value.startDate+'</td>'+
										  '<td>'+value.endDate+'</td>'+
										  '<td>'+value.owner+'</td></tr>'
								})
								$("#activityList").html(html)
							}
						})
					}
					return false
				}
			})

			//选择市场活动
			$("#chooseActivity").click(function(){
				let activityId = $.trim($("input[name='activity']:checked").val())
				console.log(activityId)
				let activityName =  $.trim($("input[name='activity']:checked").parent().next().text())
				if(activityId===''){
					alert("请选择市场活动源")
				}
				else{
					$("#activityId").val(activityId)
					$("#create-activitySrc").val(activityName)
					$("#findMarketActivity").modal("hide")
				}
			})

			//联系人查询窗口按下回车
			$("#findContacts").keydown(function(event){
				if(event.keyCode===13){
					let contactsName = $.trim($("#search-contactsName").val())
					if(contactsName!==''){
						$.ajax({
							url:"workbench/transaction/getContactsListByContactsName.do",
							data:{"contactsName":contactsName},
							dataType:"json",
							type:"get",
							success:function(data){
								let html =""
								$.each(data,function(index,value){
									html+='<tr><td><input type="radio" value="'+value.id+'" name="contacts"/></td>'+
											'<td >'+value.fullname+'</td>'+
											'<td>'+value.email+'</td>'+
											'<td>'+value.mphone+'</td>'+
											'</tr>'
								})
								$("#contactsList").html(html)
							}
						})
					}
					return false
				}
			})

			//选择市场活动
			$("#chooseContacts").click(function(){
				let contactsId = $.trim($("input[name='contacts']:checked").val())
				let contactsName =  $.trim($("input[name='contacts']:checked").parent().next().text())
				if(contactsId===''){
					alert("请选择市场活动源")
				}
				else{
					$("#contactsId").val(contactsId)
					$("#create-contactsName").val(contactsName)
					$("#findContacts").modal("hide")
				}
			})

			//提交保存
			$("#save").click(function (){
				$.ajax({
					url:"workbench/transaction/save.do",
					data:$("#transactionForm").serialize(),
					dataType:"json",
					type:"post",
					success:function (data){
						if(data.code===-1){
							alert(data.msg)
						}
						else{
							window.location.href = "workbench/transaction/index.jsp"
						}
					}
				})

			})
			//时间拾取器
			$(".time").datetimepicker({
				minView:"month",
				language:"zh-CN",
				format:"yyyy-mm-dd",
				autoclose:true,
				todayBtn:true,
				pickerPosition:"center-left"
			})
		})
	</script>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询" id="search-activityName">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activityList">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="chooseActivity">确认</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询" id="search-contactsName">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsList">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="chooseContacts">确认</button>
				</div>
			</div>
		</div>
	</div>
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="save">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" action="" role="form" id="transactionForm" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<%--所有者--%>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner" name="transactionOwner">
					<c:forEach items="${userList}" var="user">
						<option value="${user.id}" selected="${user.id eq sessionScope.user.id}">${user.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<%--金额--%>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="transactionMoney" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<%--名称--%>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="transactionName" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label " readonly="">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" name="transactionExpectedDate" id="create-expectedClosingDate" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customerName" class="col-sm-2 control-label" >客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="customerName" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" name="transactionStage" id="create-transactionStage">
			  	<option></option>
			  	<c:forEach items="${stageList}" var="stage" >
					<option value="${stage.value}">${stage.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="transactionType" id="create-transactionType">
				  <option></option>
				  <c:forEach items="${transactionTypeList}" var="tranType">
					  <option value="${tranType.value}">${tranType.text}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" name="transactionSource" id="create-clueSource">
				  <option></option>
					<c:forEach items="${sourceList}" var="source" >
						<option value="${source.value}">${source.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);showSearchActivityModal()"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-activitySrc" readonly>
				<input type="hidden" name="transactionActivityId" id="activityId" value="">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0); showSearchContactsModal()"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control"  id="create-contactsName" readonly>
				<input type="hidden"  name="transactionContactsId" id="contactsId">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3"  name="transactionDescription" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" name="transactionContactsSummary" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time"  name="nextContactTime" id="create-nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>