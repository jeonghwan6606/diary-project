<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>    
<%@ page import= "java.sql.PreparedStatement" %> 
<%
	//1. request 인코딩 설정
	request.setCharacterEncoding("utf-8");
	
	//2. 기존의 4개의 값을 확인(디버깅)
	System.out.println(request.getParameter("noticeNo")+"<--updateNoticeAction.jsp");
	System.out.println(request.getParameter("noticeTitle")+"<--updateNoticeAction.jsp");
	
	//3. 2번 유효성검사-> 잘못 된 결과일 경우 -> 분기 ->리다이렉션 -> 코드진행 종료
	//-> 리다이렉션 (updateNoticeFrom.jsp?noticeNo=&msg=)
		
	//유효성 체크하기
	String msg = null;
	
	// 유효성 체크하기
	if(request.getParameter("noticeNo") == null){
			response.sendRedirect("./noticeList3.jsp");
			return;
		}
		
	//or 연산일 경우 앞에 조건이 해당되면 다음은 실행하지 x
	if(request.getParameter("noticeTitle") == null 
			||request.getParameter("noticeTitle").equals("")){			
				msg = "noticeTitle is required";
	}else if(request.getParameter("noticeContent") == null 
			||request.getParameter("noticeContent").equals("")){			
				msg = "noticeContent is required";
	}else if(request.getParameter("noticePw") == null 
			||request.getParameter("noticePw").equals("")){			
				msg = "noticePw is required";	
	} 
	if(msg !=null){
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
								+request.getParameter("noticeNo")
								+"&msg="
								+msg);
		return;
	}
	
	//변환 변수에 넣자 정상이니까 ㅎ
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	
	//디버깅
	System.out.println(noticeNo+"<!--updateNoticeAction parameter noticeNo");
	System.out.println(noticePw+"<!--updateNoticeAction parameter noticePw");
	System.out.println(noticeTitle+"<!--updateNoticeAction parameter noticeTitle");
	System.out.println(noticeContent+"<!--updateNoticeAction parameter noticeContent");

	
	// 5. mariadb RDBMS에 update문을 전송한다
	// "UPDATE notice SET notice_title = ?, notice_content = ? where notice_no=? and notice_pw=?";   

	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	java.sql.Connection conn  = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");	
	System.out.println("접속성공"+conn); //접속성공org.mariadb.jdbc.Connection@2f01304e(주소 16진값)\
	
	String sq1 = "UPDATE notice SET notice_title = ?, notice_content = ?, updatedate=now() where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sq1); 
	
	System.out.println(stmt+"<--stmt / updateNoticeAction sq1"); // stmt를 출력하면 쿼리가 나옴
	
	// ? parameter 값 설정(set)
	stmt.setString(1, noticeTitle); // stmt의 첫번째 물음표를 noticeTitle로 바꿀거다 (순서는 앞에서 1번)
	stmt.setString(2, noticeContent); // stmt의 두번째 물음표를 noticeContent로 바꿀거다 (순서는 앞에서 2번)      
	// ? parameter 값 설정(where)   
	
	stmt.setInt(3, noticeNo); // stmt의 세번째 물음표를 noticeTitle로 바꿀거다 (순서는 앞에서 3번)
	stmt.setString(4, noticePw); // stmt의 네번째 물음표를 noticeContent로 바꿀거다 (순서는 앞에서 4번)		
			
	//conn.setAutoCommit(true);-> default 값이 true임
	// 테이블에 반영 -> conn.commit();   
	
	
	
	/*int row= stmt.executeUpdate();
	   
	//디버깅 row값 (excuteUpdate 는 영향받은 행의 값을 반환)
	System.out.println(row+"<--updateNoticeAction row");
	   
	//5번 결과에 따라 페이지(view)를 분기한다 / 업데이트 안되는 경우 (거의 비밀번호가 틀린경우 row를 통해 이동경로 설정)   
	if(row==0) { //비밀번호 틀려서 삭제행이 0
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+noticeNo);	
	} else {
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
	}
	*/
	int row = stmt.executeUpdate();
	if(row==0){
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
				+request.getParameter("noticeNo")
				+"&msg=incorrect noticePw");
	}else if(row==1){
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);
	}
	else if(row>1){
		System.out.println("error row값 : "+row);
	}
%>
