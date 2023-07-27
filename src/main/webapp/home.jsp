<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>    
<%@ page import= "java.sql.PreparedStatement" %>
<%@ page import= "java.sql.ResultSet" %>
<%@ page import= "java.util.*" %>
<%@ page import= "vo.*" %>

<%
		//select notice_no, notice_title, createdate from notice
		// order by createdate desc
		// limit ?,? 0,5
		
			
		Class.forName("org.mariadb.jdbc.Driver");
		java.sql.Connection conn  = DriverManager.getConnection("jdbc:mariadb://3.38.38.146/diary","root","java1234");
		
		// 최근 공지 5개	
		PreparedStatement stmt = conn.prepareStatement("select notice_no, notice_title, createdate from notice order by createdate desc limit 0,5"); 
		System.out.println(stmt+"<--stmt");
		
		ResultSet rs1= stmt.executeQuery();
		
		//ResultSet -> ArrayList<Notice>
		ArrayList<Notice> noticeList =new ArrayList<Notice>();
		while(rs1.next()){
		Notice n = new Notice();
		n.noticeNo = rs1.getInt("notice_no");
		n.noticeTitle = rs1.getString("notice_title");
		n.createdate = rs1.getString("createdate");
		noticeList.add(n);
		}
		
		// 오늘 일정
		//
		String sql2= "SELECT schedule_no, schedule_date, schedule_time, substring(schedule_memo, 1,10) memo,schedule_color FROM schedule WHERE schedule_date = CURDATE() ORDER BY schedule_time ASC";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		System.out.println(stmt2+"<--stmt2");
		
		ResultSet rs2= stmt2.executeQuery();
		
		//ResultSet -> ArrayList<Notice>
		ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
		while(rs2.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs2.getInt("schedule_no");
		s.scheduleTime = rs2.getString("schedule_time");
		s.scheduleDate = rs2.getString("schedule_date"); // day만 가져온 scheduleDate
		s.scheduleMemo = rs2.getString("memo"); // 전체메모가 아닌 5글자만
		s.scheduleColor = rs2.getString("schedule_color");
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

	<h1>공지사항</h1>
	<table class="table table-hover">
		<tr class="table-info">
			<th scope="row">notice_title</th>
			<th scope="row">createdate</th>
		</tr>
		<%
			for(Notice n: noticeList) {
		%>
			 <tr class="table-active">
				<td>
					<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
						<%=n.noticeTitle%>
					</a>
				</td>
				<td><%=n.createdate.substring(0,10)%></td>
			</tr>			
		<%	
			}		
		%>
	</table>
	<h1>오늘일정</h1>
	<table class="table table-hover">
		
		 <tr class="table-warning">
			<th scope="row">schedule_date</th>
			<th scope="row">schedule_time</th>
			<th scope="row">schedule_memo</th>
		</tr>
		<%
			for(Schedule s: scheduleList){
		%>
			 <tr class="table-default">
				<td>
					<%=s.scheduleDate%>
				</td>
				<td>
					<%=s.scheduleTime%>
				</td>
				<td>
					<%=s.scheduleMemo%>
				</td>
			</tr>
		<%
			}
		%>				
	</table>
</body>
</html>