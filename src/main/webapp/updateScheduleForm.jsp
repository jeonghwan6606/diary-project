<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<%@ page import= "java.util.*" %>
<%@ page import= "vo.*" %>
<% //가져온 scheduleNo 유효성 체크
	if(request.getParameter("scheduleNo")== null){
	response.sendRedirect("./scheduleList.jsp");
	return;
	}
	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	//변환한 값 디버깅
	System.out.println(scheduleNo+"<--updateScheduleForm param scheduleNo");
	
			
	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn  = DriverManager.getConnection("jdbc:mariadb://3.38.38.146/diary","root","java1234");
	
	//쿼리실행문 및 파라미터값 지정
	String sql= "select schedule_no, schedule_date, schedule_time, schedule_memo, schedule_color, createdate, updatedate from schedule where schedule_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	System.out.println(stmt+"<--scheduleListByDate stmt");
	ResultSet rs = stmt.executeQuery();
	
	
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
<body>
	<h1>스케줄 수정</h1>
	<div>
		<%
			if(request.getParameter("msg")!= null){
		%>
					<span style="color:red;font-style:italic"><%=request.getParameter("msg")%></span>
		<%
			}
		%>
	</div>
	<form action="./updateScheduleAction.jsp" method="post">
		<% 
				
			// ResultSet -> ArrayList<Schedule>
			if(rs.next()){
				Schedule s = new Schedule();
				s.scheduleNo = rs.getInt("schedule_no");
				s.scheduleTime = rs.getString("schedule_time");
				s.scheduleDate = rs.getString("schedule_date"); // day만 가져온 scheduleDate
				s.scheduleMemo = rs.getString("schedule_memo"); // 전체메모가 아닌 5글자만
				s.scheduleColor = rs.getString("schedule_color");
	
			//있으면 출력한다 rs.next(); 와 동일
		%>	
		
		<table class="table table-hover">
			<tr>
				<th class="table-info">schedule_no</th>
				<td><input type="text" name="scheduleNo" 
							value="<%=s.scheduleNo%>" 
							readonly="readonly"></td>
			</tr>		
			<tr>
				<th class="table-info">schedule_date</th>
				<td><input type="date" name="scheduleDate" 
							value="<%=s.scheduleDate%>" 
							readonly="readonly"></td>
			</tr>
			<tr>
				<th class="table-info">schedule_time</th>
				<td><input type="time" name="scheduleTime" value="<%=s.scheduleTime%>"></td>
			</tr>
			<tr>
				<th class="table-info">schedule_color</th>
				<td>
					<input type="color" name="scheduleColor" value="<%=s.scheduleColor%>">
				</td>
			</tr>
			<tr>
				<th class="table-info">schedule_memo</th>
				<td><textarea cols="80" rows="3" name="scheduleMemo">"<%=s.scheduleMemo%>"</textarea></td>
			</tr>
			<tr>
				<th class="table-info">schedule_pw</th>
				<td><input type="password" name="schedulePw"></td>
			</tr>
		<%
			}
		%>		
		</table>
		<button type="submit" class="btn btn-outline-primary">저장하기</button>
	</form>
	
</body>
</html>