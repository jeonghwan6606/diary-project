<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	int targetYear = 0;
	int targetMonth = 0;
	
	//년 or 행이 요청값에 넘어오지 않으면 오늘 날짜의 년/월 값으로
	if(request.getParameter("targetYear")==null 
			|| request.getParameter("targetMonth")==null){
		Calendar c = Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);		
	}else {
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	System.out.println(targetYear+ "<-schedulelist param targetYear");
	System.out.println(targetMonth+ "<-schedulelist param targetMonth");
	
	// 오늘 날짜
	
	Calendar today = Calendar.getInstance();
	int todatyDate = today.get(Calendar.DATE);
	
	// targetMonth 1일의 요일은?
	Calendar firstDay = Calendar.getInstance(); // 2023 4 24일이 firstday
	firstDay.set(Calendar.YEAR, targetYear);
	firstDay.set(Calendar.MONTH, targetMonth);
	firstDay.set(Calendar.DATE, 1);	// 2023	4 1을 firstday로 바꿔줌
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); // 2023 4 1 이 몇번째 요일인지, 일1 /월2/ 화3...
	
	// 년 23 월 12 입력 Calendar API 년 24 월 1로 변경
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	
	//1일앞에 공백칸의 수 
	
	int startBlank = firstYoil - 1;
	
	// targetMonth 마지막일 
	int lastDate= firstDay.getActualMaximum(Calendar.DATE); //Actual 실제 존재하는 마지막 날짜를 구한다.
	System.out.println(lastDate+ "lastDate");
	
	
	//lastDate날짜 뒤 공백칸의 수
	int endBlank = 0;
	if((lastDate+startBlank)%7 !=0){
		endBlank = 7-(startBlank + lastDate)%7;
	}
	
	//전체 TD의 개수
	int totalTD = startBlank + lastDate + endBlank;
	System.out.println(totalTD+ "tatalTD");
	
	//db data를 가져오는 알고리즘
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn  = DriverManager.getConnection("jdbc:mariadb://3.38.38.146/diary","root","java1234");
	/*
		select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo,1,5)scheduleMemo, schedule_color scheduleColor
		from schedule
		where year(schedule_date) = ? and month(schedule_date) = ?
		order by month(schedule_date) asc;		
	*/
	
	PreparedStatement stmt = conn.prepareStatement("select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo,1,5)scheduleMemo,  schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by month(schedule_date) asc");
	
	
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth+1);
	System.out.println(stmt+ "<--stmt");
	
	ResultSet rs = stmt.executeQuery();
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()){
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // day만 가져온 scheduleDate
		s.scheduleMemo = rs.getString("scheduleMemo"); // 전체메모가 아닌 5글자만
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
	
	// 지난달 마지막 일 구하기
	int preMonthDate = 0;
	Calendar PreMonth = Calendar.getInstance();
	PreMonth.set(Calendar.YEAR, targetYear);
	PreMonth.set(Calendar.MONTH, targetMonth-1);
	preMonthDate = PreMonth.getActualMaximum(Calendar.DATE);
	
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	table,th,td{border: 1px solid gray;}
	table{border-collapse: collapse; width:90%}
</style>
<title>Insert title here</title>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
		<div><!--메인메뉴 -->
			<a class="navbar-brand" href="./home.jsp">홈으로</a>
			<a class="navbar-brand" href="./noticeList3.jsp">공지 리스트</a>
			<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
		</div>
	</nav>

	<h1>
	<a class="btn btn-success" role="button" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">이전달</a>
		<%=targetYear%>년 <%=targetMonth+1%>월<!-- 보여줄때만 month +1 로 보여주자 -->
	<a  class="btn btn-success" role="button" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달</a>
	</h1>
	
	<table class="table" >
		<thead class="table-success">
			<tr>
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>		
			</tr>
		</thead>
		<tr>
			<%
				for(int i=0; i<totalTD; i+=1){
					int num = i - startBlank+1;
					if(i!= 0 && i%7==0){
						
			%>
						</tr><tr>
			<%
					}
		
					String tdStyle = "";
					if(num>0 && num<=lastDate){
						//오늘 날짜이면
						if(today.get(Calendar.YEAR)== targetYear
								&&today.get(Calendar.MONTH) == targetMonth
								&&today.get(Calendar.DATE)== num){
								tdStyle = "background-color:orange;";
						}
			%>
						<td style="<%=tdStyle %>">
							<div><!-- 날짜 숫자 -->
								<a href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>"><%=num%></a>
							</div>
							<div><!-- 일정 메모(5글자만) -->
								<%
									for(Schedule s : scheduleList){
										if(num == Integer.parseInt(s.scheduleDate)){
								%>
										<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo %></div>
								<% 		
										}
									}
								%>
							</div>
						</td>
			<%				
					} else if(num<=0){
			%>
					<td style="color:#A6A6A6"><%=preMonthDate+num%></td>
			<%
					}else{
			%>
					<td style="color:#A6A6A6"><%=num-lastDate%></td>
			<% 				
					}
				}
			%>
		</tr>
	</table>	
</body>
</html>