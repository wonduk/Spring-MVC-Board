<!-- 게시판 목록 페이지 -->


<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>


<%@include file="../includes/header.jsp"%>

<<style>
select{width:178px; height:26px; !important}
#searchForm button {height: 27x; text-align:center; line-height:normal;}
#regBtn{width:80px; height: 28px; font-size:15px; font-family: "Open Sans", sans-serif;}
.tc{text-align: center};
</style>
<!-- 제목 -->
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">회원제 게시판</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /제목 -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">
			 	<sec:authorize access="isAuthenticated()">
				</sec:authorize> 
				<!-- 게시판목록 개수 버튼, 글작성 버튼 -->
				 	<button id='regBtn' type="button" class="btn btn-info btn-xs pull-right">글쓰기</button>
				   <form id="amountfrom" action="amount" method="post">
				  <label for="amount"> </label>
				  <select id="amount" name="amount">
			        <option value="0">목록 개수선택</option>
			        <option value="10">10개</option>
			        <option value="15">15개</option>
			        <option value="20">20개</option>
			    </select>  
			    </form>
				<!-- <a href="/board/register" class="btn btn-info btn-xs pull-right">글쓰기</a> -->
			</div>
				<!-- /.게시판목록 개수 버튼, 글작성버튼 -->

			<!-- /.panel-heading -->
			
			
			<!-- 게시글 출력화면 -->
			<div class="panel-body">
				<table class="table table-striped table-bordered table-hover tc">
					<thead>
						<tr>
							<th class="tc">번호</th>
							<th class="tc" width=40%>제목</th>
							<th class="tc">작성자</th>
							<th class="tc">작성일</th>
							<th class="tc">수정일</th>
						</tr>
					</thead>

					<c:forEach items="${list}" var="board">
						<tr>
							<td><c:out value="${board.bno}" /></td>
							
							<td><a class='move' href='<c:out value="${board.bno}"/>'>
									<c:out value="${board.title}" />  <b>[<span class="replyCntDisplay"><c:out value="${board.replyCnt}" /></span>]</b>
							</a></td>

							<td><c:out value="${board.writer}" /></td>
							<td><fmt:formatDate pattern="yyyy-MM-dd"
									value="${board.regdate}" /></td>
							<td><fmt:formatDate pattern="yyyy-MM-dd"
									value="${board.updateDate}" /></td>
						</tr>
					</c:forEach>
				</table>
				<!-- /.게시글 출력화면 -->
				
				
				<!-- 검색창 -->
				<div class='row'>
					<div class="col-lg-12">

						<form id='searchForm' action="/board/list" method='get'>
							<select name='type'class=''>
								<option value=""<c:out value="${pageMaker.cri.type == null?'selected':''}"/>>--</option>
								<option value="T"<c:out value="${pageMaker.cri.type eq 'T'?'selected':''}"/>>제목</option>
								<option value="C"<c:out value="${pageMaker.cri.type eq 'C'?'selected':''}"/>>내용</option>
								<option value="W"<c:out value="${pageMaker.cri.type eq 'W'?'selected':''}"/>>작성자</option>
								<option value="TC"<c:out value="${pageMaker.cri.type eq 'TC'?'selected':''}"/>>제목or 내용</option>
								<option value="TW"<c:out value="${pageMaker.cri.type eq 'TW'?'selected':''}"/>>제목or 작성자</option>
								<option value="TWC"<c:out value="${pageMaker.cri.type eq 'TWC'?'selected':''}"/>>제목or 내용 or 작성자</option>
							</select> 
							<input type='text' name='keyword' value='<c:out value="${pageMaker.cri.keyword}"/>' /> 
							<input type='hidden' name='pageNum' value='<c:out value="${pageMaker.cri.pageNum}"/>' /> 
							<input type='hidden' name='amount' value='<c:out value="${pageMaker.cri.amount}"/>' />
							<button class='btn btn-info'>검색</button>
						</form>
					</div>
				</div>
				<!-- /.검색창 -->


				<!-- 페이지 이동 버튼 -->
				<div class='pull-right'>
					<ul class="pagination">
						<!--  페이징 처리한 값을 가져옴-->
						<c:if test="${pageMaker.prev}">
							<li class="paginate_button previous"><a
								href="${pageMaker.startPage -1}">Previous</a></li>
						</c:if>

						<c:forEach var="num" begin="${pageMaker.startPage > 0 ? pageMaker.startPage : 1}" end="${pageMaker.endPage > 0 ? pageMaker.endPage : 1}">
						    <li class="paginate_button ${pageMaker.cri.pageNum == num ? "active":""}">
						        <a href="${num}">${num}</a>
						    </li>
						</c:forEach>

						<c:if test="${pageMaker.next}">
							<li class="paginate_button next"><a
								href="${pageMaker.endPage +1 }">Next</a></li>
						</c:if>
					</ul>
				</div>
			</div>
				<!-- 페이지 이동 버튼 -->
				
				
			<!-- JQuery의 액션폼으로 받은 값 저장 -->
			<form id='actionForm' action="/board/list" method='get'>
				<input type='hidden' name='bno'>
				<input type='hidden' name='pageNum' value='${pageMaker.cri.pageNum}'>
				<input type='hidden' name='amount' value='${pageMaker.cri.amount}'>
				<input type='hidden' name='type' value='<c:out value="${ pageMaker.cri.type }"/>'>
				<input type='hidden' name='keyword' value='<c:out value="${ pageMaker.cri.keyword }"/>'>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>  
			</form>
			<!-- /.JQuery의 액션폼으로 받은 값 저장 -->


			<!-- 모달창  -->
			<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
				aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal"
								aria-hidden="true">&times;</button>
							<h4 class="modal-title" id="myModalLabel">Modal title</h4>
						</div>
						<div class="modal-body">처리가 완료되었습니다.</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-info"
								data-dismiss="modal">확인</button>
						</div>
					</div>
				</div>
			</div>
			<!-- /.모달창 -->
			
			<!-- 로그인 Modal -->
			<div class="modal fade" id="exampleModalCenter" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
			  <div class="modal-dialog modal-dialog-centered" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title" id="exampleModalLongTitle">Modal title</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			      </div>
			      <div class="modal-body">
			        <form method='post' action="/login">
					  <div>
					    <input type='text' name='username' value='admin'>
					  </div>
					  <div>
					    <input type='password' name='password' value='admin'>
					  </div>
			      <div class="modal-footer">
					  <div>
			        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
					    <input type='submit' class="btn btn-primary">
					  </div>
					  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			       <!--  <button type="button" class="btn btn-primary">Save changes</button> -->
			      </div>
			  
			  		</form>
			      </div>
			    </div>
			  </div>
			</div>
			


		</div>
		<!--  end panel-body -->
	</div>
	<!-- end panel -->
</div>
</div>
<!-- /.row -->






<script type="text/javascript">
	$(document).ready(
					function() {
						//등록된 글 번호 저장
						var result = '<c:out value="${result}"/>';

						checkModal(result);
						//글 등록시 모달창을 한번만 출력하기 위해 설정
						history.replaceState({}, null, null);

						function checkModal(result) {
							//글번호가 없거나 history.state값이 있으면 중지
							if (result === '' || history.state) {
								return;
							}
							//글번호가 있으면 모달창에 메세지 변경
							if (parseInt(result) > 0) {
								$(".modal-body").html(
										"게시글 " + parseInt(result)+ " 번이 등록되었습니다.");
							}else if (result =="modify"){
								$(".modal-body").html("수정이 완료되었습니다.");
							}else if (result =="remove"){
								$(".modal-body").html("삭제가 완료되었습니다.");
							}

							$("#myModal").modal("show");//모달창 오픈
						}
						//regBtn이벤트처리
						$("#regBtn").on("click", function() {
							//location="/board/register";
							//location.href="/board/register";//href가 있는거랑 없는거랑 똑같은 역할을 함
							self.location = "/board/register";

						});
						$(document).ready(function() {
						    // 페이지 개수 선택 폼이 변경될 때마다 실행
						    $("#amount").change(function() {
						        var selectedValue = $(this).val(); // 선택한 옵션 값
						        var pageNum = $("input[name='pageNum']").val(); // 현재 페이지 번호 가져오기

						        // 페이지 번호와 선택한 페이지 개수를 액션 폼에 설정
						        $("#actionForm input[name='pageNum']").val(pageNum);
						        $("#actionForm input[name='amount']").val(selectedValue);
						     // 페이지 로딩 시 초기 라벨 값 설정
						        var initialAmount = $("#amount").val();
						        $("#amountLabel").text(initialAmount + "개");

						        // 액션 폼을 서버로 제출
						        $("#actionForm").submit();
						    });
						});
						

						var actionForm = $("#actionForm");
						$(".paginate_button a").on("click",function(e) {
							e.preventDefault();
							console.log('click');
							actionForm.find("input[name='pageNum']").val($(this).attr("href"));
							actionForm.attr("action","/board/list");
							actionForm.submit();
						});

						$(".move").on("click",function(e) {
							//다음페이지 넘어가는 걸 막음
							e.preventDefault();
							actionForm.find("input[name='bno']").val($(this).attr("href"));
							actionForm.attr("action","/board/get");
							actionForm.submit();//전송

						});

						var searchForm = $("#searchForm");

						$("#searchForm button").on("click",function(e) {
							if (!searchForm.find("option:selected").val()) {
								alert("검색종류를 선택하세요");
								return false;
							}
							if (!searchForm.find(
									"input[name='keyword']").val()) {
								alert("키워드를 입력하세요");
								return false;
							}
							searchForm.find("input[name='pageNum']")
									.val("1");
							e.preventDefault();
							searchForm.submit();
						});
						//댓글 개수가 0개면 출력 안하게 설정
						 $(".replyCntDisplay").each(function() {
					            var replyCntValue = $(this).text().trim();

					            // replyCntValue가 0이거나 빈 문자열이면 해당 부분을 숨기도록 처리
					            if (replyCntValue === "0" || replyCntValue === "") {
					                $(this).parent().hide();
					            }
					        });
					    });
</script>






<%@include file="../includes/footer.jsp"%>
