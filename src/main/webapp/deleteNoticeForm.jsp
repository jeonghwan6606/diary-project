<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 요청값 유효성 검사 request parameter values..
	if(request.getParameter("noticeNo")== null){
		response.sendRedirect("./noticeList3.jsp");
		return;
	}
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo+"<--deleteNoticeForm param noticeNo");
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
	<h1>공지 삭제</h1>
	<form action="./deleteNoticeAction.jsp" method="post">
		<table class="table table-hover">
			<tr>
				<td class="table-info">notice_no</td>
				<td>
					<!--
					<input type="hidden" name="noticeNo" value="<%=noticeNo%>">
					-->
					<input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="table-info">notice_pw</td>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
		</table>
		<button type="submit" class="btn btn-success">삭제</button>
	</form>
</body>
</html>