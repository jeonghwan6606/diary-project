<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>    
<%@ page import= "java.sql.PreparedStatement" %>
<%@ page import= "java.sql.ResultSet" %>
<%
	if(request.getParameter("noticeNo")== null
			||request.getParameter("noticePw")== null
			||request.getParameter("noticeNo").equals("")
			||request.getParameter("noticePw").equals("")){
		response.sendRedirect("./noticeList3.jsp");
		return;
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	
	//디버깅
	System.out.println(noticeNo+"<!--deleteNoticeAction parameter noticeNo");
	System.out.println(noticePw+"<!--deleteNoticeAction parameter noticePw");

	//delete from notice where notice_no=? and notice_pw=?
	
	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn  = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sq1 = "delete from notice where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sq1); 
	stmt.setInt(1, noticeNo); // stmt의 첫번째 물음표를 noticeNo로 바꿀거다 (순서는 앞에서 1번)
	stmt.setString(2, noticePw); // stmt의 첫번째 물음표를 noticePw로 바꿀거다 (순서는 앞에서 2번)		
	
	System.out.println(stmt+"<--stmt / deleteNoticeAction sq1"); // stmt를 출력하면 쿼리가 나옴
			
	
	
	int row= stmt.executeUpdate();
	//디버깅 row값
	System.out.println(row+"<--deleteNoticeAction row");
	
	if(row==0) { //비밀번호 틀려서 삭제행이 0
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+noticeNo);	
		// response.sendRedirect("./NoticeOne.jsp?noticeNo="+noticeNo);	
	} else {
		response.sendRedirect("./noticeList3.jsp");
	}
%>