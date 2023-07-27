<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>    
<%@ page import= "java.sql.PreparedStatement" %>
<%@ page import= "java.sql.ResultSet" %>

<%//유효성 체크
	if(request.getParameter("noticeNo")==null){
		response.sendRedirect("./noticeList3.jsp");
		return; // 1) 코드진행 종료 2) 반환값을 남길때
	}	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));

	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn  = DriverManager.getConnection("jdbc:mariadb://3.38.38.146/diary","root","java1234");
	
	String sq1 = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sq1); 
	stmt.setInt(1, noticeNo); // stmt의 첫번째 물음표를 noticeNo로 바꿀거다 (순서는 앞에서 1번)
	
	System.out.println(stmt+"<--stmt");
	ResultSet rs= stmt.executeQuery();	
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
	<h1>공지 수정</h1>
	<div>
		<%
			if(request.getParameter("msg")!= null){
		%>
					<span style="color:red;font-style:italic"><%=request.getParameter("msg")%></span>
		<%
			}
		%>
	</div>
	<form action="./updateNoticeAction.jsp" method="post">
	<%
		if(rs.next()){ //있으면 출력한다 rs.next(); 와 동일
	%>
		<table class="table table-hover">
			<tr>
				<th class="table-info">
					notice_no <!-- where 에서 필요할 수 있어 필요 -->
				</th>
				<th>
					<input type="number" name="noticeNo" value="<%=rs.getInt("notice_no")%>" readonly="readonly">
				</th>
			</tr>
			<tr>
				<th class="table-info">
					notice_pw <!-- 직접입력해야 하는 사항 -->
				</th>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
			<tr>
				<th class="table-info">
					notice_title
				</th>
				<td>
					<input type="text" name="noticeTitle" value="<%=rs.getString("notice_title")%>" >
				</td>
			</tr>
			<tr>
				<th class="table-info">
					notice_content
				</th>
				<td>
					<textarea cols="80"  rows="3" name="noticeContent"><%=rs.getString("notice_Content")%></textarea>
				</td>
			</tr>
			<tr>
				<th class="table-info">
					notice_writer
				</th>
				<td>
					<%=rs.getString("notice_writer")%>
				</td>
			</tr>
			<tr>
				<th class="table-info">
					createdate
				</th>
				<td>
					<%=rs.getString("createdate")%>
				</td>
			</tr>
			<tr>
				<th class="table-info">
					updatedate
				</th>
				<td>
					<%=rs.getString("updatedate")%>
				</td>
			</tr>
		</table>
		<div>
			<button type = "submit" class="btn btn-outline-primary">수정하기</button>
		</div>
	<%
		}
	%>		
	</form>
</body>
</html>