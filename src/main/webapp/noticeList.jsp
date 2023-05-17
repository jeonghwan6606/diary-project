<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
//요청 분석
	//현재 페이지
	int currentPage = 1;
	if(request.getParameter("currentPage")!=null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+"<-currentpage");
	//페이지당 출력할 행의 수
	int rowPerPage=10;
		
	//시작 행 번호	
	
	// 1page 일때만 startrow가 0
	/*
			currentPage		startRow(rowPerPage가 10개일 때)
			1				0	<-- (currentPage-1)*rowPerPage
			2				10
			3				20
	*/
	
	int startRow = (currentPage-1)*rowPerPage; 
	
	
	//DB연결 설정
	
	
		// select notice_no, notice_title, createdate from notice
		// order by createdate desc
		// limit  0,5
		
		Class.forName("org.mariadb.jdbc.Driver");
		java.sql.Connection conn  = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
		PreparedStatement stmt = conn.prepareStatement("select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit ?,?");
		
		stmt.setInt(1,startRow);
		stmt.setInt(2,10);
		System.out.println(stmt+"<--stmt");
		//출력할 공지 데이터
		ResultSet rs= stmt.executeQuery();
		//ResultSet 타입을 일반적인 자료구조 타입(자바 배열 or 기본 API안에 있는 타입 List, Set, Map)
		//ResultSet -> ArrayList<Notice>
		ArrayList<Notice> noticeList =new ArrayList<Notice>();
		while(rs.next()){
			Notice n = new Notice();
			n.noticeNo = rs.getInt("noticeNo");
			n.noticeTitle = rs.getString("noticeTitle");
			n.createdate = rs.getString("createdate");
			noticeList.add(n);
		}
		
		//마지막 페이지
		// select count(*) from notice
		PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
		ResultSet rs2 = stmt2.executeQuery();
		int totalRow = 0; //"select count(*) from notice";
		if(rs2.next()) {
				totalRow = rs2.getInt("count(*)");
		}
			int lastPage = totalRow / rowPerPage;
			if(totalRow % rowPerPage !=0){
				lastPage = lastPage +1;
		}
		
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>noticeList.jsp</title>
</head>
<body>
	<h1>공지사항</h1>
	<a href="./insertNoticeForm.jsp">공지작성</a>
	<div><!--메인메뉴 -->
		<a href="./home.jsp">홈으로</a>
		<a href="./noticeList3.jsp">공지 리스트</a>
		<a href="./scheduleList.jsp">일정 리스트</a>
	</div>
	
	<!-- 날짜순 최근 공지 5개 -->

	<table>
		<tr>
			<th>notice_title</th>
			<th>createdate</th>
		</tr>
		<%
			for(Notice n: noticeList) {
		%>
			<tr>
				<td>
					<a href="./noticeOne.jsp?noticeNo=<%=rs.getInt("notice_no")%>">
						<%=rs.getString("notice_title")%>
					</a>
				</td>
				<td><%=rs.getString("createdate").substring(0,10)%></td>
			</tr>			
		<%	
			}	
		
			// rs.next 또 쓸 수 없다.(앞에서 이미 끝까지 갔기때문에)->rs.beforeFirst()
		%>
	</table>
	<%
		if(currentPage>1){
	%>
		<a href="./noticeList3.jsp?currentPage=<%=currentPage-1%>">이전</a>
	<%
		}
	%>
		<%=currentPage%>
	<% 	
		if(currentPage <lastPage) {
	%>
			<a href="./noticeList3.jsp?currentPage=<%=currentPage+1%>">다음</a>
	<%
		}
	%>
	</table>
</body>
</html>