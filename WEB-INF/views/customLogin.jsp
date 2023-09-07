<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<%@include file="includes/header.jsp"%> 
<%-- <%@include file="board/list.jsp"%> --%>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
.modal-title{ text-align: center;  margin-top:20px; }
.modal-body{margin: 0px 10px 0px 10px;}
.loginbox{ margin: 10px 0px 10px 0px;}
.modal-body .loginText{
  margin: 10px 10px 10px 10px;
  width: 100%;
  height: 40px;
  font-size: 15px;
  border: 0;
  border-radius: 5px;
  outline: none;
  margin: 10px 0px 10px 0px;
 /*  padding-left: 10px; */
  background-color: rgb(233, 233, 233);}
  
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


<title>Insert title here</title>
</head>
<body>
<!-- Button trigger modal -->

  <div class="container">
        <div class="message">
            <h1>로그인 후 이용하실 수 있습니다.</h1>
			<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModalCenter">
			  로그인하기
			</button>
        </div>
    </div>



<!-- Modal -->
<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h1 class="modal-title" id="exampleModalLongTitle">로그인</h1>
      </div>
      <div class="modal-body">
        <form method='post' action="/login">
		  <div class="loginbox">
		    아이디<input type='text' name='username' value='admin' class='loginText'>
		  </div>
		  <div class="loginbox">
		    비밀번호<input type='password' name='password' value='admin' class='loginText'>
		  </div>
		  <div>
		    <input type='checkbox' name='remember-me'> Remember Me
		  </div>
		  <div>
		  <p>아이디와 비밀번호를 입력해주세요</p>
		  <p>아직 회원이 아니신 분들은 <a href="#" class="tooltip-test" title="Tooltip">회원가입</a> 후 서비스를 이용하실 수 있습니다.</p>
		  </div>
      <div class="modal-footer">
		  <div>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
        	<div><input type='checkbox' name='remember-me'>자동로그인</div>
		    <input type='submit' class="btn btn-primary" value="로그인">
		  </div>
		  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
       <!--  <button type="button" class="btn btn-primary">Save changes</button> -->
      </div>
  
  		</form>
      </div>
    </div>
  </div>
</div>
	
</body>

<!-- <script type="text/javascript">
	 자동으로 모달 창 열기 
	$(document).ready(function() {
		 $("#myModal").modal("show");
	});
</script> -->



</html>
<%@include file="includes/footer.jsp"%> 