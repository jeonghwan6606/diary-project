<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>    
<%@ page import= "java.sql.PreparedStatement" %>
<%@ page import= "java.sql.ResultSet" %>
<%@ page import= "vo.*" %>
<%
	/*if(request.getParameter("noticeNO")==null){
		response.sendRedirect("./home.jsp");
	} else {
		int noticeNO = Integer.parseInt(request.getParameter("noticeNO"));
	}*/
	// noticeNO가 Null값이면 Integer 하면 오류 발생
	// 오류 발생시 A(Null발생 값)대신 B를 보여주는 방법 or B를 요청하라고 하는 것 (재요청)
	
	// 블록이 하나 줄수 있는 방법 : return 문 사용(읽기편함)
	if(request.getParameter("noticeNo")==null){
		response.sendRedirect("./home.jsp");
		return; // 1) 코드진행 종료 2) 반환값을 남길때
	}	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn  = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sq1 = "select notice_no, notice_title, notice_content, notice_writer, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sq1); 
	stmt.setInt(1, noticeNo); // stmt의 첫번째 물음표를 noticeNO로 바꿀거다 (순서는 앞에서 1번)
	
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
	<h1>공지 상세</h1>

	<%
	
		Notice notice = null; //-> 모델데이터 MVC 모델레이어, 뷰어레이어, 컨텐트레이어 
	
		if(rs.next()){ 
			notice = new Notice();
			notice.noticeNo = rs.getInt("notice_no");
			notice.noticeTitle = rs.getString("notice_title");
			notice.noticeContent = rs.getString("notice_content");
			notice.noticeWriter = rs.getString("notice_writer");
			notice.createdate = rs.getString("createdate");
			notice.updatedate = rs.getString("updatedate");
			//있으면 출력한다
	%>
			<table class="table table-hover">
				<tr>
					<td class="table-info">notice_no</td>
					<td><%=notice.noticeNo%></td>
				</tr>
				<tr>
					<td  class="table-info">notice_title</td>
					<td><%=notice.noticeTitle%></td>
				</tr>	
				<tr>
					<td  class="table-info">notice_content</td>
					<td><%=notice.noticeContent%></td>
				</tr>	
				<tr>
					<td class="table-info">notice_writer</td>
					<td><%=notice.noticeWriter%></td>
				</tr>	
				<tr>
					<td class="table-info">createdate</td>
					<td><%=notice.createdate%></td>
				</tr>	
				<tr>
					<td class="table-info">updatedate</td>
					<td><%=notice.updatedate%></td>
				</tr>		
			</table>
	<%
		}
	%>
	<div>
		<a class="btn btn-success" role="button" href="./updateNoticeForm.jsp?noticeNo=<%=notice.noticeNo%>">수정</a>
		<a class="btn btn-success" role="button" href="./deleteNoticeForm.jsp?noticeNo=<%=notice.noticeNo%>">삭제</a>
	</div>
</body>
</html>