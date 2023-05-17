<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import= "java.sql.*" %>
<%@ page import= "java.util.*" %>
<%@ page import= "vo.*" %>   
<%
	//request 인코딩 설정
	request.setCharacterEncoding("utf-8");

	//updateScheduleForm에서 넘어온 값 디버깅
	System.out.println(request.getParameter("scheduleDate")+"<--updateScheduleAction.jsp scheduleDate" );
	System.out.println(request.getParameter("scheduleTime")+"<--updateScheduleAction.jsp scheduleTime");
	System.out.println(request.getParameter("scheduleColor")+"<--updateScheduleAction.jsp scheduleColor");
	System.out.println(request.getParameter("scheduleMemo")+"<--updateScheduleAction.jsp scheduleMemo");
	System.out.println(request.getParameter("schedulePw")+"<--updateScheduleAction.jsp schedulePw");
	
	String msg = null;
	
	// 유효성 체크하기
	if(request.getParameter("scheduleNo") == null){
			response.sendRedirect("./scheduleList.jsp");
			return;
		}
		
	//or 연산일 경우 앞에 조건이 해당되면 다음은 실행하지 x
	if(request.getParameter("scheduleDate") == null 
			||request.getParameter("scheduleDate").equals("")){			
				msg = "scheduleDate is required";
	}else if(request.getParameter("scheduleTime") == null 
			||request.getParameter("scheduleTime").equals("")){			
				msg = "scheduleTime is required";
	}else if(request.getParameter("schedulePw") == null 
			||request.getParameter("schedulePw").equals("")){			
				msg = "schedulePw is required";	
	}else if(request.getParameter("scheduleColor") == null 
			||request.getParameter("scheduleColor").equals("")){			
				msg = "scheduleColor is required";	
	}else if(request.getParameter("scheduleMemo") == null 
			||request.getParameter("scheduleMemo").equals("")){			
				msg = "scheduleMemo is required";	
	} 
	if(msg !=null){
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="
								+request.getParameter("scheduleNo")
								+"&msg="
								+msg);
		return;
	}
	
	// 유효성 확인 후 사용할 데이터 스트링 변환
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
		
	//디버깅
	System.out.println(request.getParameter("scheduleDate")+"<--updateScheduleAction String scheduleDate" );
	System.out.println(request.getParameter("scheduleTime")+"<--updateScheduleAction String scheduleTime");
	System.out.println(request.getParameter("scheduleColor")+"<--updateScheduleAction String scheduleColor");
	System.out.println(request.getParameter("scheduleMemo")+"<--updateScheduleAction String scheduleMemo");
	System.out.println(request.getParameter("schedulePw")+"<--updateScheduleAction String schedulePw");
	
	//드라이버 로딩 및 접속
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공");
	
	java.sql.Connection conn  = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");	
	System.out.println("접속성공"+conn); //접속성공org.mariadb.jdbc.Connection@2f01304e(주소 16진값)\
	
	//쿼리문 및 parameter값 설정
	String sql = "UPDATE schedule SET schedule_time= ?, schedule_memo = ?, schedule_color = ? where schedule_no = ? and schedule_pw =?";
	PreparedStatement stmt = conn.prepareStatement(sql); 
	
	// ?parameter 값 설정(SEt)
	stmt.setString(1, scheduleTime); // stmt의 첫번째 물음표를 scheduleTime (순서는 앞에서 1번)
	stmt.setString(2, scheduleMemo); // stmt의 두번째 물음표를 scheduleColor(순서는 앞에서 2번)
	stmt.setString(3, scheduleColor); // stmt의 두번째 물음표를 scheduleColor(순서는 앞에서 2번)
	
	// ? parameter 값 설정(where)   
	stmt.setInt(4, scheduleNo); 
	stmt.setString(5, schedulePw); 		
	
	
	//conn.setAutoCommit(true);-> default 값이 true임
	// 테이블에 반영 -> conn.commit();   
	 
	   
	//결과에 따라 페이지(view)를 분기한다 / 업데이트 안되는 경우 (거의 비밀번호가 틀린경우 row를 통해 이동경로 설정)   

	int row = stmt.executeUpdate();
	//디버깅 row값 (excuteUpdate 는 영향받은 행의 값을 반환)
	System.out.println(row+"<--updateScheduleAction row");
	
	if(row==0){
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="
				+request.getParameter("scheduleNo")
				+"&msg=incorrect schedulePw");
	}else if(row==1){
		response.sendRedirect("./scheduleList.jsp?scheduleNo="+scheduleNo);
	}
	else if(row>1){
		System.out.println("error row값 : "+row);
	}
	
%>
