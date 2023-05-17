<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>
<%
	//select 쿼리를 mariadb에 전송 후 결과셋을 받아서 출력하는 페이지
	//select notice_no, notice_title from notice order by notice_no desc
	
	//1) mariadb 프로그램을 사용가능하도록 장치드라이버를 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	//2) mariadb에 로그인 후 접속정보 반환받아야 한다
	Connection conn = null; // 접속정보 타입
	conn = DriverManager.getConnection("","","");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeList.jsp</title>
</head>
<body>
	
</body>
</html>