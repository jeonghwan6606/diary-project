<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>    
<%@ page import= "java.sql.PreparedStatement" %>
<%@ page import= "java.sql.ResultSet" %>

<%
	String msg= null;
	
	//유효성검사
   if(request.getParameter("scheduleNo") == null){
      response.sendRedirect("./scheduleListByDate.jsp");
      return;
   }
   
   //or 연산일 경우 앞에 조건이 해당되면 다음은 실행하지 x
   if(request.getParameter("schedulePw")== null
         ||request.getParameter("schedulePw").equals("")){
            msg = "schedulePw is required";
   } // 비밀번호가 null이거나 공백일경우에 msg 설정 및 이동경로
   if(msg !=null){ 
      response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo="
                        +request.getParameter("scheduleNo")
                        +"&msg="
                        +msg);
      return;
   }

	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");

	//가져와서 변환한 값 디버깅
	System.out.println(scheduleNo+"<!--deleteNoticeAction parameter scheduleNo");
	System.out.println(schedulePw+"<!--deleteNoticeAction parameter schedulePw");

	//실행할 쿼리문 delete from schedule where schedule_no=? and schedule_pw=?

	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn  = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sq1 = "delete from schedule where schedule_no=? and schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sq1); 
	stmt.setInt(1, scheduleNo); // stmt의 첫번째 물음표를 scheduleNo  (순서는 앞에서 1번)
	stmt.setString(2, schedulePw); // stmt의 두번째 물음표를 schedulePw (순서는 앞에서 2번)
	
	System.out.println(stmt+"<--deleteScheduleAction stmt");
	
	int row = stmt.executeUpdate(); // select 외 다른 쿼리실행할 떄 쓰임, 영향받은 행 수 반환
	System.out.println(row+"<--deleteScheduleAction row");
	
	if(row==0){
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo="+scheduleNo+"&msg=incorrect password");
	}else if(row==1){
		response.sendRedirect("./scheduleListByDate.jsp?scheduleNo="+scheduleNo);
	}else if(row>1){
		System.out.println("error row값 : "+row);
	}
%>    