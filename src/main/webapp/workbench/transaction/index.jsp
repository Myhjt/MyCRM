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
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<%--分页插件--%>
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<%--分页插件语言包--%>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
	<script type="text/javascript">

        //分页查询
        function pageList(pageNo,pageSize){
            $("#checkAll").prop("checked",false	);
            let searchCondition = "pageNo="+pageNo+"&pageSize="+pageSize+"&"+$("#searchForm").serialize()
			console.log(searchCondition)
            $.ajax({
                url:"workbench/transaction/pageList.do",
                // data:{"pageNo":pageNo,"pageSize":pageSize,"name":$("#search-fullname").val(),"customerName":$("#search-fullname").val(),
                //     "mphone":$("#search-mphone").val(),"source":$("#search-source").val(),"owner":$("#search-owner").val(),
                //     "phone":$("#search-phone").val(),"state":$("#search-state").val()
                // },
                data:searchCondition,
                type:"get",
                dataType:"json",
                success:function (data){
                    /*
                    *  接收的参数：
                    * data:{"total":,"dataList":[{'id':,'name':,customer:';,'stage':'','type':'',
                    * 		'owner':'','source':'','contacts';''}],
                    * 		[]
                    * }
                    *
                    * 传递的参数：
                    * */
                    let html=""
                    $("#transactionBody").empty()
                    $.each(data.dataList,function(index,value){
                        html+=  '<tr><td><input type="checkbox" name="checkItem"/></td>'+
                                '<td><a style="text-decoration: none; cursor: pointer;" ' +
                                'onclick="window.location.href=\'workbench/transaction/detail.do?id='+value.id+'\';">'+value.name+'</a></td>'+
                                '<td>'+value.customerId+'</td>'+
                                '<td>'+value.stage+'</td>'+
                                '<td>'+value.type+'</td>'+
								'<td>'+value.owner+'</td>'+
                                '<td>'+value.source+'</td>'+
                                '<td>'+value.contactsId+'</td></tr>'
                    })
                    $("#transactionBody").html(html)
                    //分页插件

                    let totalPage = Math.ceil(data.total/pageSize)
                    $("#tranPage").bs_pagination({
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
                            $("#search-name").val($("#hidden-name").val())
                            $("#search-customer").val($("#hidden-customer").val())
                            $("#search-stage").val($("#hidden-stage").val())
                            $("#search-source").val($("#hidden-source").val())
                            $("#search-type").val($("#hidden-type").val())
                            $("#search-contacts").val($("#search-contacts").val())
                            //调用分页查询
                            pageList(data.currentPage,data.rowsPerPage);
                        }
                    })
                }
            })
        }
		$(function(){

			//全选按钮
			$("#checkAll").click(function(){
				$("input[name='checkItem']").prop("checked",this.checked)
			})

			//itemCheckbox
			$("#transactionBody").on("click",$("input[name='checkItem']"),function(obj){
				$("#checkAll").prop("checked",$("input[name='checkItem']:checked").length===$("input[name='checkItem']").length)
			})


			//删除按钮

			//修改按钮

            //加载进来
            pageList(1,2);
		});

	</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
                <%--查询条件隐藏域--%>
                <input type="hidden" id="#hidden-owner">
                <input type="hidden" id="#hidden-name">
                <input type="hidden" id="#hidden-customer">
                <input type="hidden" id="#hidden-stage">
                <input type="hidden" id="#hidden-source">
                <input type="hidden" id="#hidden-type">
                <input type="hidden" id="#hidden-contacts">
                <%--查询条件--%>
				<form class="form-inline" role="form" id="searchForm" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" name="owner" id="search-owner">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" name="name" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" name="customer" id="search-customer">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" name="stage" id="search-stage">
					  	<option></option>
						  <c:forEach items="${stageList}" var="stage">
							  <option value="${stage.value}">${stage.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" name="type" id="search-type">
					  	<option></option>
						  <c:forEach items="${transactionTypeList}" var="type">
							  <option value="${type.value}">${type.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" name="source" id="search-source">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.value}">${source.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" name="contacts" id="search-contacts">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/add.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transactionBody">
					</tbody>
				</table>
			</div>
			
            <%--分页--%>
			<div  style="height: 50px; position: relative;top: 20px;">
				<div id="tranPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>