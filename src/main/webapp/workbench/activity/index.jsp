<%@page contentType="text/html;charset=utf-8" %>
<%
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<%--时间拾取插件--%>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<%--本地化语言包--%>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<%--分页插件--%>
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<%--分页插件语言包--%>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
	<script type="text/javascript">

		/*
		* 对于关系型数据库，做前端分页需要的参数就是pageNo，pageSize
		* 有哪些情况需要调用pageList方法：
		* 	1)刚进入到液面时
		* 	2）数据添加、修改、删除时
		* 	3）点击分页按钮时
		* 	4）点击查询按钮时
		* */
		function pageList(pageNo, pageSize){
			$("#check-all").prop("checked",false);
			$.ajax({
				url:"workbench/activity/pageList.do",
				type:"get",
				data:{
					pageNo:pageNo,pageSize:pageSize,name:$("#search-name").val().trim(),owner:$("#search-owner").val().trim(),
					startDate:$("#search-startDate").val().trim(),endDate:$("#search-endDate").val().trim()
				},
				dataType: "json",
				success:function(data){
					/*
					* data:{"total":"xxx","dataList":[{'name':"","owner":"","startDate":"","endDate":""},{}]}
					* */
					$("#activity-list").empty()//清空列表
					let html = "";
					$.each(data.dataList,function(index,value){
						html += "<tr class='active'> " +
								"<td><input type='checkbox' name='check-item' value='"+value.id+"'/></td>" +
								"<td>" +
								"<a style='text-decoration: none; cursor: pointer;' href='workbench/activity/detail.do?id="+value.id+"\'>"+
								value.name +
								"</a>" +
								"</td> " +
								"<td>"+value.owner+"</td> <td>"+value.startDate+"</td> <td>"+value.endDate+"</td> " +
								"</tr>"
					})
					$("#activity-list").html(html);

					let totalPages = Math.ceil(data.total/pageSize)
					//数据处理完毕后，结合分页插件对前端展示相关的信息
					$("#activityPage").bs_pagination({
						currentPage:pageNo,//页码
						rowsPerPage:pageSize,//每页显示的记录数
						maxRowsPerPage: 20,//每页最多显示的记录数
						totalPages:totalPages,//总页数
						totalRows:data.total,//总记录数
						visiblePageLinks:3,//显示几个卡片
						showGoToPage:true,
						showRowsPerPage:true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,
						//该回调函数，点击分页组件的时候触发
						onChangePage:function (event,data){
							//重置查询条件
							$("#search-owner").val($("#hidden-owner").val())
							$("#search-startDate").val($("#hidden-startDate").val())
							$("#search-name").val($("#hidden-name").val())
							$("#search-endDate").val($("#hidden-endDate").val())
							//调用分页查询
							pageList(data.currentPage,data.rowsPerPage);
						}
					})
				}
			})
		}
		$(function(){
			//创建按钮，打开创建模态窗口
			$("#addBtn").click(function (){
				/*
				 *	打开需要打开的模态窗口jquery对象，调用modal，为方法传参数，
				 * 				show：打开模态窗口，hide：关闭模态窗口
				 *
				 */
				$.ajax({
					url:"workbench/activity/getUserList.do",
					dataType:"json",
					type:"get",
					success:function (data){
						$.each(data,function(index,value){
							let obj = "<option value="+value.id+">"+value.name+"</option>"
							$("#create-marketActivityOwner").append(obj);
						})
						$("#create-marketActivityOwner").val("${user.id}")
					},
					error:function(){

					}
				})
				$("#createActivityModal").modal("show");
				//时间拾取器
				$(".time").datetimepicker({
					minView:"month",
					language:"zh-CN",
					format:"yyyy-mm-dd",
					autoclose:true,
					todayBtn:true,
					pickerPosition:"bottom-left"
				})
			})

			//保存按钮
			$("#saveBtn").click(function (){
				//判段市场信息是否合法
				if(false){

				}
				else{
					//合法发送请求
					$.ajax({
						url:"workbench/activity/save.do",
						type:"post",
						data:$("#saveActivityForm").serialize(),
						success:function (data){
							//添加成功
							if(data.code===0){
								//刷新市场活动列表
								//关闭添加操作的模态窗口
								$("#createActivityModal").modal("hide");
								//跳转到第一页
								pageList(1,
										$("#activityPage").bs_pagination('getOption','rowsPerPage')
								)
								//重置表单
								// $("#saveActivityForm")[0].reset();
							}
							else{
								alert("添加失败");
							}
						},
						error:function(){

						}
					})
				}

			})

			//查询按钮
			$("#search-button").click(function(){
				//暂存查询条件
				$("#hidden-name").val($("#search-name").val().trim())
				$("#hidden-owner").val($("#search-owner").val().trim())
				$("#hidden-startDate").val($("#search-startDate").val().trim())
				$("#hidden-endDate").val($("#search-endDate").val().trim())

				pageList(1,2);
			})

			//删除按钮
			$("#delete-btn").click(function(){
				//找到所有勾选的对象
				let $item_checked = $("input[name='check-item']:checked");
				if($item_checked.length===0){
					alert("请选择需要删除的记录")
				}
				else{
					let param = ""
					console.log($item_checked.length)
					for(let i=0;i<$item_checked.length;i++) {
						param += "ids=" + ($item_checked[i].value)
						if (i < $item_checked.length - 1) {
							param += "&"
						}
					}
					let flag = confirm("你确定要删除吗");
					if(flag){
						$.ajax({
							url:"workbench/activity/delete.do",
							data:param,
							type:"post",
							success:function(data){
								//删除成功
								if(data.code===0){
									//刷新
									pageList(1,
											$("#activityPage").bs_pagination('getOption','rowsPerPage')
									)
								}
								else{
									alert(data.msg)
								}
							},
							error:function(){

							}
						})
					}
				}
			})

			//修改按钮
			$("#modifyBtn").click(function(){
				let $item_checked = $("input[name='check-item']:checked");
				if($item_checked.length==0){
					alert("请选择要修改的活动")
				}
				else if($item_checked.length>1){
					alert("只能修改一条记录")
				}
				else{
					$("#editActivityModal").modal("show");
					let id = $item_checked.val();
					$.ajax({
						url:"workbench/activity/getUserListAndActivity.do",
						data:{"id":id},
						dataType:"json",
						type:"get",
						success:function(data){
							/*
							* data：
							* 	用户列表,活动
							* 	{"users":[{'id':,'name'},{}],"activity":{"name":"","startDate":"","endDate":"","cost":"",description:"","owner"}}
							* */
							//用户列表
							let html = ""
							$.each(data.users,function(index,user){
								html += "<option value="+user.id+">"+user.name+"</option>"
							})
							$("#edit-marketActivityOwner").html(html)
							$("#edit-marketActivityOwner").val(data.activity.owner)
							//活动信息
							//活动id
							$("#edit-id").val(data.activity.id);
							//活动名称
							$("#edit-marketActivityName").val(data.activity.name);
							//活动开始日期
							$("#edit-startDate").val(data.activity.startDate);
							//活动结束日期
							$("#edit-endDate").val(data.activity.startDate);
							//成本
							$("#edit-cost").val(data.activity.cost);
							//描述信息
							$("#edit-describe").val(data.activity.description);
						}
					})
				}
			})

			//更新按钮
			$("#updateBtn").click(function (){
				//判断所有者以及名称是否为空
				let name = $.trim($("#edit-marketActivityName").val());
				if(name===""){
					alert("活动名称不能为空");
				}
				else {
					let owner = $.trim($("#edit-marketActivityOwner").val())
					let id = $.trim($("#edit-id").val())
					let startDate = $.trim($("#edit-startDate").val())
					let endDate = $.trim($("#edit-endDate").val())
					let cost = $.trim($("#edit-cost").val())
					let description = $.trim($("#edit-describe").val())
					$.ajax({
						url: "workbench/activity/modify.do",
						data: {"id": id, name:name,"owner": owner,"startDate":startDate,"endDate":endDate,
							"cost":cost,"description":description},
						dataType: "json",
						type: "post",
						success: function (data) {
							if (data.code === 0) {
								alert("更新成功");
								$("#editActivityModal").modal("hide");
								pageList($("#activityPage").bs_pagination('getOption','currentPage'),
										 $("#activityPage").bs_pagination('getOption','rowsPerPage')
								)
							} else {
								alert(data.msg);
							}
						}
					})
				}
			})



			let check_nums = 0;
			//全选、反选功能
			$("#check-all").click(function(){
				$("input[name='check-item']").prop("checked",this.checked);
				let total = $("input[name='check-item']").length;
				if(this.checked)
					check_nums = total;
				else
					check_nums = 0;
			})
			/*
				$("input[name=check-item]").click(function(){
			 	})
				这种方法行不通，动态生成的元素不能这么做，需要以on的形式来进行操作
			 	语法：
			 		$(需要绑定元素的有效的外层元素).on(绑定事件的方式，需要绑定的元素的jquery对象，回调函数)
			 */
			$("#activity-list").on("click",$("input[name=check-item]"),function(obj){
				$("#check-all").prop("checked",$("input[name='check-item']").length===$("input[name='check-item']:checked").length)
			})
			pageList(1,2)
		});

	</script>
</head>
<body>

	<%--隐藏域暂存查询条件--%>
	<input	type="hidden" id="hidden-name"/>
	<input	type="hidden" id="hidden-owner"/>
	<input	type="hidden" id="hidden-startDate"/>
	<input	type="hidden" id="hidden-endDate"/>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form id="saveActivityForm" class="form-horizontal" role="form">
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<%--所属用户--%>
								<select class="form-control" name="owner" id="create-marketActivityOwner">
								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" name="name" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="startDate" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" name="endDate" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">
                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" name="cost" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" name="description" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<%--
						data-dismiss="modal" 表示关闭模态窗口
					--%>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<%--名称--%>
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>
						<%--日期--%>
						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startDate" value="2020-10-10">
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endDate" value="2020-10-20">
							</div>
						</div>
						<%--成本--%>
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						<%--描述--%>
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						<%--id--%>
						<input id="edit-id" type="hidden" value=""/>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
			<%--查询条件--%>
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>
				  <button type="button" class="btn btn-default" id="search-button">查询</button>
				  
				</form>
			</div>
			<%--创建、修改、删除--%>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<%--
						点击创建按钮，观察data-toggle 和data-target 属性值
						data-toggle:
							表示点击按钮，触发一个模态窗口
						data-target:
							打开的模态窗口对象，这里通过id查找

						这里通过属性和属性值的方式来打开模态窗口
						但是这样有问题：
							在点击创建按钮的时候，需要触发其他功能的时候

						所以以后打开模态窗口时，不要写死在元素当中
					--%>
				  <button type="button" class="btn btn-primary" id="addBtn">
					  <span class="glyphicon glyphicon-plus"></span> 创建
				  </button>

				  <button type="button" class="btn btn-default" id="modifyBtn">
					  <span class="glyphicon glyphicon-pencil"></span> 修改
				  </button>

				  <button type="button" class="btn btn-danger" id="delete-btn">
					  <span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<%--活动列表--%>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="check-all"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activity-list">
						<%--<tr class="active">--%>
						<%--	<td><input type="checkbox" /></td>--%>
						<%--	<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
                        <%--    <td>zhangsan</td>--%>
						<%--	<td>2020-10-10</td>--%>
						<%--	<td>2020-10-20</td>--%>
						<%--</tr>--%>
                        <%--<tr class="active">--%>
                        <%--    <td><input type="checkbox" /></td>--%>
                        <%--    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.html';">发传单</a></td>--%>
                        <%--    <td>zhangsan</td>--%>
                        <%--    <td>2020-10-10</td>--%>
                        <%--    <td>2020-10-20</td>--%>
                        <%--</tr>--%>
					</tbody>
				</table>
			</div>
			<%--分页--%>
			<div style="height: 50px; position: relative;top: 30px;">
				<%--分页组件--%>
				<div id="activityPage"></div>
			</div>
		</div>
	</div>
</body>
</html>