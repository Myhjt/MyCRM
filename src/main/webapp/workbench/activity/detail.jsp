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
	<script type="text/javascript">
	
		//默认情况下取消和保存按钮是隐藏的
		var cancelAndSaveBtnDefault = true;

		//加载备注
		function loadRemark(){
			$.ajax({
				url:"workbench/activityRemark/getRemarkList.do",
				type:"get",
				data:{"activityId":'${requestScope.activity.id}'},
				dataType:"json",
				success:function(data){
					/*
					* 返回备注列表 remarkList
					* {
					* 	"activityName":'',
					* 	"remarkList":[
					* 		{'id':'','noteContent':'','createTime':'','createBy':'','editTime':'','editBy':'','activityId':'','editFlag'}
					* 	]
					* }
					* */
					$.each($(".remarkDiv"),function(index,node){
						$(node).remove();
					})
					let html = ''
					$.each(data,function(index,value){
						let createBy = value.editFlag==="0"?value.createBy:value.editBy
						let createTime = value.editFlag==="0"?value.createTime:value.editTime
						html +='<div class="remarkDiv" id="'+value.id+'"style="height: 60px;">'+
								'<img title='+value.createBy+' src="image/user-thumbnail.png" style="width: 30px; height:30px;">'+
								'<div style="position: relative; top: -40px; left: 40px;" >'+
								'<h5>'+value.noteContent+'</h5>'+
								'<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> '+createTime+' 由'+createBy+'</small>'+
								'<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'+
								'<a class="myHref" href="javascript:void(0);" onclick=editRemark(\''+value.id+'\')><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>'+
								'&nbsp;&nbsp;&nbsp;&nbsp;'+
								'<a class="myHref" href="javascript:void(0);" onclick=removeRemark(\''+value.id+'\')><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>'+
								'</div>'+
								'</div>'+
								'</div>'
					})
					$("#remarkDiv").before(html)
				}
			})
		}

		//删除备注
		function removeRemark(remarkId){
			$.ajax({
				url:"workbench/activityRemark/delete.do",
				data:{"remarkId":remarkId},
				dataType:"json",
				type:"post",
				success:function(data){
					if(data.code===0){
						//删除成功,删除对应的div
						loadRemark();
					}
					else{
						alert(data.msg);
					}
				}
			})
		}

		//修改备注按钮，显示模态窗口
		function editRemark(remarkId){
			$("#editRemarkModal").modal("show");
			$("#remarkId").val(remarkId)
			console.log($("#"+remarkId+" h5").text())
			$("#noteContent").val($("#"+remarkId+" h5").text())  //设置模态窗口内的备注内容
		}
		$(function(){
			$("#remark").focus(function(){
				if(cancelAndSaveBtnDefault){
					//设置remarkDiv的高度为130px
					$("#remarkDiv").css("height","130px");
					//显示
					$("#cancelAndSaveBtn").show("2000");
					cancelAndSaveBtnDefault = false;
				}
			});
			
			$("#cancelBtn").click(function(){
				//显示
				$("#cancelAndSaveBtn").hide();
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","90px");
				cancelAndSaveBtnDefault = true;
			});
			
			$(".remarkDiv").mouseover(function(){
				$(this).children("div").children("div").show();
			});
			
			$(".remarkDiv").mouseout(function(){
				$(this).children("div").children("div").hide();
			});
			
			$(".myHref").mouseover(function(){
				$(this).children("span").css("color","red");
			});
			
			$(".myHref").mouseout(function(){
				$(this).children("span").css("color","#E6E6E6");
			});

			//添加备注按钮
			$("#saveBtn").click(function(){
				let noteContent = $.trim($("#remark").val())
				/*需要传递的数据
					noteContent
					activityId
				* */
				if(noteContent!==""){
					$.ajax({
						url:"workbench/activityRemark/save.do",
						type:"post",
						data:{"noteContent":noteContent,"activityId":'${activity.id}'},
						dataType: "json",
						success:function(data){
							//添加备注成功
							if(data.code===0){
								loadRemark();
							}
							else{
								alert(data.msg);
							}
						}
					})
				}
			})

			//更新备注按钮
			$("#updateRemarkBtn").click(function(){
				let noteContent = $.trim($("#noteContent").val())
				if(noteContent===""){
					alert("备注内容不能为空");
				}
				else{
					$.ajax({
						url:"workbench/activityRemark/modify.do",
						data:{"id":$("#remarkId").val(),"noteContent":noteContent},
						dataType:"json",
						type:"post",
						success:function(data){
							if(data.code==0){
								loadRemark();
								$("#editRemarkModal").modal("hide")
							}
							else{
								alert(data.msg);
							}
						}
					})
				}
			})

			//加载备注
			loadRemark()
			$("#remarkBody").on("mouseover",".remarkDiv",function(){
				$(this).children("div").children("div").show()
			})
			$("#remarkBody").on("mouseleave",".remarkDiv",function(){
				$(this).children("div").children("div").hide()
			})
		});
		
	</script>
</head>
<body>
	
	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
        <div class="modal-dialog" role="document" style="width: 40%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改备注</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">内容</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="noteContent"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
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
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-marketActivityOwner">
                                    <option>zhangsan</option>
                                    <option>lisi</option>
                                    <option>wangwu</option>
                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" value="5,000">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>市场活动-发传单 <small>2020-10-10 ~ 2020-10-20</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
			<!-- 备注1 -->
			<%--<div class="remarkDiv" style="height: 60px;">--%>
			<%--	<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
			<%--	<div style="position: relative; top: -40px; left: 40px;" >--%>
			<%--		<h5>哎呦！</h5>--%>
			<%--		<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
			<%--		<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
			<%--			<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
			<%--			&nbsp;&nbsp;&nbsp;&nbsp;--%>
			<%--			<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
			<%--		</div>--%>
			<%--	</div>--%>
			<%--</div>--%>
			<!-- 备注2 -->
			<%--<div class="remarkDiv" style="height: 60px;">--%>
			<%--	<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
			<%--	<div style="position: relative; top: -40px; left: 40px;" >--%>
			<%--		<h5>哎呦！</h5>--%>
			<%--		<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
			<%--		<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
			<%--			<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
			<%--			&nbsp;&nbsp;&nbsp;&nbsp;--%>
			<%--			<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
			<%--		</div>--%>
			<%--	</div>--%>
			<%--</div>--%>
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>