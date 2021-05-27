<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html;charset=utf-8" %>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>

	<base href="<%=basePath%>">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	
	
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">

	//打开搜索框
	function showSearchActivityModal(){
		$("#searchActivityModal").modal("show")
		$("#activityName").val("")
		$("#activityBody").empty()
	}

	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		//时间控件
		//时间拾取器
		$(".time").datetimepicker({
			minView:"month",
			language:"zh-CN",
			format:"yyyy-mm-dd",
			autoclose:true,
			todayBtn:true,
			pickerPosition:"top-left"
		})

		//按下回车搜索
		$("#searchActivityModal").keydown(function(event){
			if(event.keyCode==13){
				$.ajax({
					url:"workbench/clue/getActivityListByActivityName.do",
					data:{"activityName":$.trim($("#activityName").val())},
					type:"post",
					dataType:"json",
					success:function(data){
						let html= ""
						$.each(data,function(index,value){
							html  +='<tr>'+
									'<td><input type="radio" value="'+value.id+'" name="activity"/></td>'+
									'<td>'+value.name+'</td>'+
									'<td>'+value.startDate+'</td>'+
									'<td>'+value.endDate+'</td>'+
									'<td>'+value.owner+'</td>'+
									'</tr>'
						})
						$("#activityBody").html(html)
					}
				})
				return false;
			}
		})

		//点击确认选择市场活动源
		$("#chooseActivity").click(function(){
			let option = $("input[type='radio'][name='activity']:checked")
			if(option.length===0){
				alert("请选择活动源")
			}
			else{
				console.log()
				$("#activity-id").val(option.val())
				$("#activity").val(option.parent().next().text())
				$("#searchActivityModal").modal("hide")
			}
		})

		//线索转换
		$("#convertBtn").click(function(){
			if($("#isCreateTransaction").prop("checked")){
				$("input[name='createTranFlag']").val("true")
				$("#tranForm").submit();
			}
			else {
				window.location.href="workbench/clue/convert.do?clueId=${param.id}"
			}

		})
	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="activityName" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityBody">

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

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${param.get("surname")}-${param.get("company")}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${param.get("company")}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${param.get("surname")}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
		<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
			<%--交易表单--%>
			<form id="tranForm" method="post" action="workbench/clue/convert.do">
				<input type="hidden" name="createTranFlag" >
				<input type="hidden" name="clueId" value="${param.clueId}">
			  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
				<label for="amountOfMoney">金额</label>
				<input type="text" class="form-control" id="amountOfMoney" name="tranMoney">
			  </div>
			  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
				<label for="tradeName">交易名称</label>
				<input type="text" class="form-control" id="tradeName" value="${param.company}-" name="tranName">
			  </div>
			  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
				<label for="expectedClosingDate">预计成交日期</label>
				<input type="text" class="form-control time" id="expectedClosingDate" readonly name="tranExpectedClosingDate">
			  </div>
			  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
				<label for="stage">阶段</label>
				<select id="stage"  class="form-control" name="tranStage">
					<option></option>
					<c:forEach items="${stageList}" var="stage">
						<option value="${stage.value}">${stage.text}</option>
					</c:forEach>
				</select>
			  </div>
			  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
				<label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" onclick="showSearchActivityModal()" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
				<input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
				<input type="hidden" id="activity-id" name="tranActivityId">
			  </div>
		</form>
		</div>
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<>${param.owner}</>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" id="convertBtn" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>