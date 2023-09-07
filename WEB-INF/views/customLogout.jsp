<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@include file="includes/header.jsp"%> 
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <style>
        /* 컨테이너의 스타일링 */
        .container {
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 100px;
            /* height: 100vh; /* 화면 전체 높이를 차지하도록 설정 */ */
        }

        /* 메시지의 스타일링 */
        .message {
            text-align: center;
            padding: 20px;
           /*  border: 1px solid #ccc; */
           /*  background-color: #f0f0f0; */
        }
        .container btn{
        	font-size: 100px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="message">
            <h1>로그아웃 하시겠습니까? </h1>
            <form action="/customLogout" method="post">
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
	<button class="btn btn-primary">로그아웃 </button>
	</form>
        </div>
    </div>
</body>
</html>
	
  
	
</body>
</html>

<%@include file="includes/footer.jsp"%> 