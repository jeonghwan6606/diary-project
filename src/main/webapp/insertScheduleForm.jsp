<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
		</div>
	</nav>
	<h1>스케줄 상세</h1>
	<form action="./insertScheduleAction.jsp" method="post">
		<table class="table table-hover">
			<tr>
				<th>schedule_date</th>
				<td><input type="date" name="scheduleDate"></td>
			</tr>
			<tr>
				<th>schedule_time</th>
				<td><input type="time" name="scheduleTime"></td>
			</tr>
			<tr>
				<th>schedule_color</th>
				<td>
					<input type="color" name="scheduleColor" value="#00000">
				</td>
			</tr>
			<tr>
				<th>schedule_memo</th>
				<td><textarea cols="80" rows="3" name="scheduleMemo"></textarea></td>
			</tr>
		</table>
		<button type="submit">저장</button>
	</form>
	

</body>
</html>