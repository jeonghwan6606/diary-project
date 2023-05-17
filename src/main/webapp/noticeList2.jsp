<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>
<%@ page import= "java.sql.PreparedStatement" %>
<%@ page import= "java.sql.ResultSet" %>
<%
	//select 쿼리를 mariadb에 전송 후 결과셋을 받아서 출력하는 페이지
	//select notice_no, notice_title from notice order by notice_no desc
	
	//1) mariadb 프로그램을 사용가능하도록 장치드라이버를 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	//2) mariadb에 로그인 후 접속정보 반환받아야 한다
	Connection conn = null; // 접속정보 타입
	conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("접속성공"+conn); //접속성공org.mariadb.jdbc.Connection@2f01304e(주소 16진값)

	//3) 쿼리생성 (1. 쿼리의 문자열 입력 /con이 statement stmt를 쿼리형태로 실행해준다(?))
	String sql = "select notice_no, notice_title from notice order by notice_no desc" ;
	PreparedStatement stmt = conn.prepareStatement(sql);
	ResultSet rs = stmt.executeQuery(); 
	// Resultset 도 배열이랑 비슷 , 나중에 Resultset은 일반적인 데이터 타입이 아니기 떄문에 출력은 가능해도 android나 다른곳으로 보낼 때 ArrayList로 바꿔서 넘겨준다
	// Resultset 은 번호가 없어서 쿼스(?)를 통해 반복(for문이랑 비슷)
	System.out.println("쿼리실행성공"+rs);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeList.jsp</title>
</head>
<body>
	<h1>공지사항 리스트</h1>
	<a href="./insertNoticeForm.jsp"></a>
	<table border="1">
		<tr>
			<th>notice_no</th>
			<th>notice_title</th>
		</tr>
		<%
			while(rs.next()) {
		%>
			<tr>
				<td><%=rs.getInt("notice_no")%></td>
				<td><%=rs.getString("notice_title")%></td>
			</tr>
		<%
			}
		%>
	</table>
</body>
</html>