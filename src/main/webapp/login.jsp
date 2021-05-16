<%@page contentType="text/html;charset=utf-8"%>
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
</head>
<script>
	//普通的function要写在$(function{})外，因为浏览器渲染多的话，会慢

	//登录验证
	function login(){



		let loginAct = $.trim($("#loginAct").val());
		let loginPwd = $.trim($("#loginPwd").val());
		//验证密码和账号是否为空
		if( loginAct==="" || loginPwd===""){
			$("#msg").text("用户名或密码不能为空")
		}
		//不为空
		else {
			$.ajax({
				url:"settings/user/login.do",
				type:"post",
				dataType:"json",
				data:{loginPwd:loginPwd,loginAct:loginAct},
				success:function(data){
					if(data.code===0){
						window.location.href="workbench/index.jsp"
					}
					else{
						$("#msg").html(data.msg);
					}
				},
				error:function(xhr,errorMsg,errorObj){
					alert(errorObj)
				}
			})
		}
	}

	$(function (){

		//如果当前窗口不是顶层窗口，将当前窗口设置为顶层窗口
		if(window.top!=window){
			window.top.location = window.location
		}

		//页面进来之后，自动清空输入框，因为有些浏览器会保留
		$("#loginAct").val("");
		$("#loginPwd").val("");
		//页面加载完毕后，自动获取焦点
		$("#loginAct").focus();

		//监听键盘事件，回车执行登录
		window.onkeypress = function(data){
			if(data.code === "Enter"){
				//执行验证登录
				login();
			}
		}

		$("#loginBtn").click(function (){

			//执行验证登录
			login();
		})
	})
</script>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">CRM &nbsp;<span style="font-size: 12px;">&copy;2017&nbsp;动力节点</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" type="text" placeholder="用户名" id="loginAct">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" type="password" placeholder="密码" id="loginPwd">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
							<span id="msg" style="color: red"></span>
					</div>

					<%--
						注意：按钮写在表单中，默认的行为就是提交表单
						一定要将按钮的类型设置为表单type="bubtton"
						按钮所触发的行为由自己自定义
					--%>
					<button id="loginBtn" type="button" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>