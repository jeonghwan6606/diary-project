<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>
<%@ page import= "java.sql.PreparedStatement" %>
<%@ page import= "java.sql.ResultSet" %>   
<%@ page import= "java.util.* "%>
<%@ page import= "vo.*" %> 
<%
	// y, m, d 값이 null or "" -> redirection scheduleList.jsp
	if(request.getParameter("y")== null
			||request.getParameter("m")== null
			||request.getParameter("d")== null
			||request.getParameter("y").equals("")
			||request.getParameter("m").equals("")
			||request.getParameter("d").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	int y = Integer.parseInt(request.getParameter("y"));
	// 자바API에서 12월 11, 마리아DB에서 12월 12
	int m = Integer.parseInt(request.getParameter("m")) + 1;
	int d = Integer.parseInt(request.getParameter("d"));
	
	System.out.println(y + " <-- scheduleListByDate param y");
	System.out.println(m + " <-- scheduleListByDate param m");
	System.out.println(d + " <-- scheduleListByDate param d");
	
	String strM = m+"";
	if(m<10) {
		strM = "0"+strM;
	}
	String strD = d+"";
	if(d<10) {
		strD = "0"+strD;
	}
	
	// 일별 스케줄 리스트
	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn  = DriverManager.getConnection("jdbc:mariadb://3.38.38.146/diary","root","java1234");
	
	String sql= "select *from schedule where schedule_date = ? order by schedule_time asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, y+"-"+strM+"-"+strD);
	System.out.println(stmt+"<--scheduleListByDate stmt");
	
	ResultSet rs = stmt.executeQuery();
	
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("schedule_no");
		s.scheduleTime = rs.getString("schedule_time");
		s.scheduleDate = rs.getString("schedule_date"); // day만 가져온 scheduleDate
		s.scheduleMemo = rs.getString("schedule_memo"); // 전체메모가 아닌 5글자만
		s.scheduleColor = rs.getString("schedule_color");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
 <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<title>scheduleListByDate</title>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
		<div><!--메인메뉴 -->
			<a class="navbar-brand" href="./home.jsp">홈으로</a>
			<a class="navbar-brand" href="./noticeList3.jsp">공지 리스트</a>
			<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
		</div>
	</nav>
	<h1>스케줄 입력</h1>
	<form action="./insertScheduleAction.jsp" method="post">
		<table class="table table-hover">
			<tr>
				<th class="table-info">schedule_date</th>
				<td><input type="date" name="scheduleDate" 
							value="<%=y%>-<%=strM%>-<%=strD%>" 
							readonly="readonly"></td>
			</tr>
			<tr>
				<th class="table-info">schedule_time</th>
				<td><input type="time" name="scheduleTime"></td>
			</tr>
			<tr>
				<th class="table-info">schedule_color</th>
				<td>
					<input type="color" name="scheduleColor">
				</td>
			</tr>
			<tr>
				<th class="table-info">schedule_memo</th>
				<td><textarea cols="80" rows="3" name="scheduleMemo"></textarea></td>
			</tr>
		</table>
		<button type="submit" class="btn btn-outline-primary">스케줄 입력</button>
	</form>
	<br>
	<h1><%=y%>년 <%=m%>월 <%=d%>일 스케줄 목록</h1>
	<table class="table table-hover">
		<tr class="table-warning">
			<th>schedule_time</th>
			<th>schedule_memo</th>
			<th>createdate</th>
			<th>updatedate</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
		for(Schedule s : scheduleList){
		%>
				<tr>
					<td><%=s.scheduleTime%></td>
					<td><%=s.scheduleMemo%></td>
					<td><%=s.createdate%></td>
					<td><%=s.updatedate%></td>
					<td><a class="btn btn-success" role="button" href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">수정</a></td>
					<td><a class="btn btn-success" role="button" href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">삭제</a></td>
				</tr>		
		<%
			}
		%>
	</table>
</body>
</html>
