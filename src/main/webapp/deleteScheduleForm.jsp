<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>    
<%
	//request 인코딩 설정
	request.setCharacterEncoding("utf-8");
	// scheduleNo 잘 불러져 오는지부터 확인
	System.out.println(request.getParameter("scheduleNo")+"<--deleteScheduleForm scheduleNo");


	//선택한 요청값 유효성 겁사
	if(request.getParameter("scheduleNo")== null){
	response.sendRedirect("./noticeList3.jsp");
	return;
	}
	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	//변환한 값 디버깅
	System.out.println(scheduleNo+"<--deleteScheduleForm param scheduleNo");
%>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>Insert title here</title>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
			<div><!--메인메뉴 -->
				<a class="navbar-brand" href="./home.jsp">홈으로</a>
				<a class="navbar-brand" href="./noticeList3.jsp">공지 리스트</a>
				<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
				<a class="navbar-brand" href="./insertNoticeForm.jsp">공지작성</a>
			</div>
	</nav>	
	<h1>스케줄 삭제</h1>
		<div>
			<%
				if(request.getParameter("msg")!= null){
			%>
						<span style="color:red;font-style:italic"><%=request.getParameter("msg")%></span>
			<%
				}
			%>
		</div>
	<form action= "./deleteScheduleAction.jsp" method="post">
		<table class="table table-hover">
			<tr>
				<th class="table-info">schedule_no</th>
				<td>
					<input type= "text" name= "scheduleNo" value ="<%=scheduleNo%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th class="table-info">schedule_pw</th>
				<td>
					<input type= "password" name= "schedulePw">
				</td>
			</tr>
		</table>
		<button type="submit" class="btn btn-outline-primary">삭제</button>
	</form>

</body>
</html>