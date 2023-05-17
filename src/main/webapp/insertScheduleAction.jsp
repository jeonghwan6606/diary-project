<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>
<%@ page import= "java.sql.PreparedStatement" %>
<%@ page import= "java.sql.ResultSet" %>    
<%
	request.setCharacterEncoding("utf-8"); //post 형식 인코딩	
	
	//validation 유효성검사 parameter 매개값 통해서
	
	if(request.getParameter("scheduleDate")==null
			|| request.getParameter("scheduleTime")==null
			|| request.getParameter("scheduleColor")==null
			|| request.getParameter("scheduleMemo")==null
			|| request.getParameter("scheduleDate").equals("")
			|| request.getParameter("scheduleTime").equals("")
			|| request.getParameter("scheduleMemo").equals("")
			|| request.getParameter("schedulColor").equals("")){
		response.sendRedirect("./scheduleListByDate.jsp");
		return;
	}
	

	// 사용할 데이터 스트링 변환
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
	//변환된 데이터 정상출력 디버깅
	System.out.println(scheduleDate+ "<--insertScheduleAction param scheduleDate");
	System.out.println(scheduleTime+ "<--insertScheduleAction param scheduleTime");
	System.out.println(scheduleColor+ "<--insertScheduleAction param scheduleColor");
	System.out.println(scheduleMemo+ "<--insertScheduleAction param scheduleMemo");
	System.out.println(schedulePw+ "<--insertScheduleAction param schedulePw");
	
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	System.out.println("접속성공"+conn); //접속성공org.mariadb.jdbc.Connection@2f01304e(주소 16진값)

	//쿼리문 변환
	String sql = "insert into schedule(schedule_date,schedule_time,schedule_memo,schedule_color,createdate,updatedate) values(?,?,?,?,now(),now())" ;
	PreparedStatement stmt = conn.prepareStatement(sql);
	// insert 할 value 변수값 지정
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	
	System.out.println(stmt+"<--insertScheduleListAction stmt");

	//conn.setAutoCommit(true);-> default 값이 true임
	// 테이블에 반영 -> conn.commit();   
	
	String y = scheduleDate.substring(0,4); //0부터 4번 앞까지 자른다
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1; 
	String d = scheduleDate.substring(8);
	
	System.out.println(y+ "<--insertScheduleAction param y");
	System.out.println(m+ "<--insertScheduleAction param m");
	System.out.println(d+ "<--insertScheduleAction param d");
	
	int row= stmt.executeUpdate(); // 디버깅 1이면 1행입력성공, 0이면 입력된 행이 없다 (excuteUpdate반환값)	
	System.out.println(row+"<--insertScheduleListAction stmt");
	
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	
%>
