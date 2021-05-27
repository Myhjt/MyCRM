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
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<%--时间拾取插件--%>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<%--本地化语言包--%>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<%--分页插件--%>
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<%--分页插件语言包--%>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
</head>
<script type="text/javascript">

	function pageList(pageNo,pageSize){
		$("#checkAll").prop("checked",false	);
		$.ajax({
			url:"workbench/clue/pageList.do",
			data:{"pageNo":pageNo,"pageSize":pageSize,"fullname":$("#search-fullname").val(),"company":$("#search-fullname").val(),
				  "mphone":$("#search-mphone").val(),"source":$("#search-source").val(),"owner":$("#search-owner").val(),
				  "phone":$("#search-phone").val(),"state":$("#search-state").val()
			},
			type:"get",
			dataType:"json",
			success:function (data){
				/*
				*  接收的参数：
				* data:{"total":,"dataList":[{'id':,'fullname':,appellation:';,'company':'','mphone':'',
				* 		'phone':'','source':'','owner';'','state':''}],
				* 		[]
				* }
				*
				* 传递的参数：
				* */
				let html=""
				$("#clueBody").empty()
				$.each(data.dataList,function(index,value){
					html += '<tr class="active" >'+
							'<td><input type="checkbox" name="checkItem"/></td>'+
							'<td><a style="text-decoration: none; cursor: pointer;" ' +
							'onclick="window.location.href=\'workbench/clue/detail.do?id='+value.id+'\';">'+value.fullname+value.appellation+'</a></td>'+
							'<td>'+value.company+'</td>'+
							'<td>'+value.mphone+'</td>'+
							'<td>'+value.phone+'</td>' +
							'<td>'+value.source+'</td>'+
							'<td>'+value.owner+'</td>'+
							'<td>'+value.state+'</td>'+
							'</tr>'
				})
				$("#clueBody").html(html)
				//分页插件
				let totalPage = Math.ceil(data.total/pageSize)
				$("#cluePage").bs_pagination({
					currentPage:pageNo,//页码
					rowsPerPage:pageSize,//每页显示的记录数
					maxRowsPerPage: 20,//每页最多显示的记录数
					totalPages:totalPage,//总页数
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
						$("#search-fullname").val($("#hidden-fullname").val())
						$("#search-company").val($("#hidden-company").val())
						$("#search-mphone").val($("#hidden-mhone").val())
						$("#search-source").val($("#hidden-source").val())
						$("#search-phone").val($("#hidden-phone").val())
						$("#search-state").val($("#hidden-state").val())
						//调用分页查询
						pageList(data.currentPage,data.rowsPerPage);
					}
				})
			}
		})
	}
	$(function(){
		//添加按钮点击，弹出模态对话框
		$("#createBtn").click(function(){
			$("#createClueModal").modal("show");
			$.ajax({
				url:"workbench/clue/getUserList.do",
				dataType:"json",
				type:"get",
				success:function(data){
					$.each(data,function(index,value){
						$("#create-clueOwner").append("<option value='"+value.id+"'>"+value.name+"</option>")
					})
					$("#create-clueOwner").val('${user.id}')
				}
			})
		})

		//保存按钮，提交数据
		$("#saveBtn").click(function(){
			let owner = $("#create-clueOwner").val();//线索所有者id
			let company = $.trim($("#create-company").val());//线索的公司
			let fullname = $.trim($("#create-surname").val());//线索的姓名
			if(owner===""){
				alert("所有者不能为空")
			}
			else if(company===""){
				alert("公司不能为空")
			}
			else if(fullname===""){
				alert("姓名不能为空")
			}
			else{
				let appellation=$.trim($("#create-call").val())
				let job=$.trim($("#create-job").val())
				let email=$.trim($("#create-email").val())
				let phone=$.trim($("#create-phone").val())
				let website=$.trim($("#create-website").val())
				let mphone=$.trim($("#create-mphone").val())
				let state=$.trim($("#create-state").val())
				let source=$.trim($("#create-source").val())
				let createBy='${user.id}' //由谁创建的记录
				let description=$.trim($("#create-describe").val())
				let contactSummary=$.trim($("#create-contactSummary").val())
				let nextContactTime=$.trim($("#create-nextContactTime").val())
				let address=$.trim($("#create-address").val())

				//发送请求
				$.ajax({
					url:"workbench/clue/save.do",
					data:{appellation:appellation, owner:owner, company:company, job:job, email:email,
						phone:phone, website:website, mphone:mphone, state:state, source:source, address:address,
						description:description, contactSummary:contactSummary, nextContactTime:nextContactTime,
						createBy:createBy,fullname:fullname
					},
					dataType:"json",
					type:"post",
					success:function(data){
						if(data.code!=0){
							alert(data.msg)
						}
						else{
							$("#createClueModal").modal("hide");
							//刷新
							pageList(1,2)
						}
					}
				})
			}
		})

		//查询按钮
		$("#searchBtn").click(function(){
			//暂存查询条件
			$("#hidden-owner").val($("#search-owner").val())
			$("#hidden-fullname").val($("#search-fullname").val())
			$("#hidden-company").val($("#search-company").val())
			$("#hidden-mphone").val($("#search-mphone").val())
			$("#hidden-phone").val($("#search-phone").val())
			$("#hidden-source").val($("#search-source").val())
			$("#hidden-state").val($("#search-state").val())
			pageList(1,2)
		})

		//全选按钮
		$("#checkAll").click(function(){
			$("input[name='checkItem']").prop("checked",this.checked)
		})

		//itemCheckbox
		$("#clueBody").on("click",$("input[name='checkItem']"),function(obj){
			$("#checkAll").prop("checked",$("input[name='checkItem']:checked").length===$("input[name='checkItem']").length)
		})

		//时间拾取器
		$(".time").datetimepicker({
			minView:"month",
			language:"zh-CN",
			format:"yyyy-mm-dd",
			autoclose:true,
			todayBtn:true,
			pickerPosition:"top-left"
		})
		$("#hidden-source").val($("#search-source").val())
		$("#hidden-state").val($("#search-state").val())
		pageList(1,2)
	});
</script>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
									<c:forEach items="${appellationList}" var="appellation">
										<option value="${appellation.value}">${appellation.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">

									<c:forEach items="${clueStateList}" var="clueState">
										<option value="${clueState.value}">${clueState.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.value}">${source.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
								  <option selected>先生</option>
								  <option>夫人</option>
								  <option>女士</option>
								  <option>博士</option>
								  <option>教授</option>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
								  <option>试图联系</option>
								  <option>将来联系</option>
								  <option selected>已联系</option>
								  <option>虚假线索</option>
								  <option>丢失线索</option>
								  <option>未联系</option>
								  <option>需要条件</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
								  <option selected>广告</option>
								  <option>推销电话</option>
								  <option>员工介绍</option>
								  <option>外部介绍</option>
								  <option>在线商场</option>
								  <option>合作伙伴</option>
								  <option>公开媒介</option>
								  <option>销售邮件</option>
								  <option>合作伙伴研讨会</option>
								  <option>内部研讨会</option>
								  <option>交易会</option>
								  <option>web下载</option>
								  <option>web调研</option>
								  <option>聊天</option>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>

	<%--查询条件--%>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;"	>
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<%--隐藏域--%>
			<input type="hidden" id="hidden-fullname">
			<input type="hidden" id="hidden-company" >
			<input type="hidden" id="hidden-mhone"  >
			<input type="hidden" id="hidden-source">
			<input type="hidden" id="hidden-owner">
			<input type="hidden" id="hidden-phone">
			<input type="hidden" id="hidden-state">
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" id="search-fullname" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control"  id="search-company"  type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control"  id="search-mphone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="search-source" >
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.value}">${source.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control"  id="search-owner" type="text">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control"  id="search-phone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="search-state" >
						  <option></option>
						  <c:forEach items="${clueStateList}" var="clueState">
							  <option value="${clueState.value}">${clueState.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<%--按钮--%>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>

			<%--线索列表--%>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">
					</tbody>
				</table>
			</div>

			<%--分页--%>
			<div style="height: 50px; position: relative;top: 60px;">
				<%--分页组件--%>
				<div id="cluePage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>