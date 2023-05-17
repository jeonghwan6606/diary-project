<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>
<%@ page import= "java.sql.PreparedStatement" %>
<%@ page import= "java.sql.ResultSet" %>    
<%
	//validation 유효성검사 parameter 매개값 통해서
	request.setCharacterEncoding("utf-8"); //post 형식 인코딩
	
	if(request.getParameter("noticeTitle")==null
			|| request.getParameter("noticeContent")==null
			|| request.getParameter("noticeWriter")==null
			|| request.getParameter("noticePw")==null
			|| request.getParameter("noticeTitle").equals("")
			|| request.getParameter("noticeContent").equals("")
			|| request.getParameter("noticeWriter").equals("")
			|| request.getParameter("noticePw").equals("")){
		response.sendRedirect("./insertNoticeForm.jsp");
		return;
	}
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");

	
	//값들을 Db 테이블 입력
	/*
		insert into notice(notice_title, notice_content, notice_writer,notice_pw,createdate,updatedate)
		values(?,?,?,?,?) -->PreparedStatement
	*/
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
		
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("접속성공"+conn); //접속성공org.mariadb.jdbc.Connection@2f01304e(주소 16진값)

	
	String sql = "insert into notice(notice_title, notice_content, notice_writer,notice_pw,createdate,updatedate) values(?,?,?,?,now(),now())" ;
	PreparedStatement stmt = conn.prepareStatement(sql);
	//? 4개(1~4)
	stmt.setString(1,noticeTitle);
	stmt.setString(2,noticeContent);
	stmt.setString(3,noticeWriter);
	stmt.setString(4,noticePw);
	int row= stmt.executeUpdate(); // 디버깅 1이면 1행입력성공, 0이면 입력된 행이 없다
	
	//conn.setAutoCommit(true);-> default 값이 true임
	// 테이블에 반영 -> conn.commit();
	
	//redirection
	response.sendRedirect("./noticeList3.jsp"); //return으로 끝내자 리다이렉트 이후에도 코드는 계속 실행된다.
	
%>