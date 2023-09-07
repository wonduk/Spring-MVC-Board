<!-- 상세보기 페이지 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<%@include file="../includes/header.jsp"%> 


<style>
.uploadResult {
  width:100%;
  background-color: lightgray;
}
.uploadResult ul{
  display:flex;
  flex-flow: row;
  justify-content: center;
  align-items: center;
}
.uploadResult ul li {
  list-style: none;
  padding: 10px;
  align-content: center;
  text-align: center;
}
.uploadResult ul li img{
  width: 100px;
}
.uploadResult ul li span {
  color:white;
}
.bigPictureWrapper {
position: fixed;
display: none;
justify-content: center;
align-items: center;
top:0 !important;
left:0 !important;
width:100%;
height:100%;
z-index: 1000 !important;
background:rgba(0,0,0,0.7);
}
.bigPicture {
  position: relative;
  display:flex;
  justify-content: center;
  align-items: center;
}

.bigPicture img {
  width:600px;
}
.ta-r {
 float: right;
}

</style>
            <div class="row">
                <div class="col-lg-12">
                    <h1>${board.title}</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                        </div>
			    		<!-- 상세보기 -->
                        <div class="panel-body">
	                          <div class="form-group">
					          	<label>글 번호</label> 
					          	<input class="form-control" name='bno' value='<c:out value="${board.bno}"/>' readonly="readonly">
						      </div>
					          <div class="form-group">
					            <label>작성자</label> 
					            <input class="form-control" name='writer' value='<c:out value="${board.writer}"/>' readonly="readonly">
					          </div>
					          <div class="form-group">
					            <label>내용</label>
					            <textarea class="form-control" rows="3" name='content' readonly="readonly"><c:out value="${board.content}" /></textarea>
					          </div>
					          <!-- 첨부파일  -->
								<div class='bigPictureWrapper'>
								  <div class='bigPicture'>
								  </div>
								</div>
					            <!-- /.첨부파일 -->
					            <div class="row">
								  <div class="col-lg-12">
								    <div class="panel panel-default">
								      <div class="panel-heading">파일</div>
								      <div class="panel-body">
								        <div class='uploadResult'> 
								          <ul>
								          </ul>
								        </div>
								      </div>
								    </div>
								  </div>
								</div>
								<!-- /.상세보기 -->
								
							
							  <!-- 수정,목록버튼 -->	
					          <div class="ta-r">
					          <sec:authentication property="principal" var="pinfo"/>						
					          <sec:authorize access="isAuthenticated()">						
						        <c:if test="${pinfo.username eq board.writer}">						        
						        <button data-oper='modify' class="btn btn-default">수정</button>						        
						        </c:if>
						      </sec:authorize>
							  <button data-oper='list' class="btn btn-info">목록으로</button>
					          </div>
							  <!-- /.수정,목록버튼 -->	
					        
					        
					        <!--  controller에서 받아온 값 hidden태그로 저장 -->
					          <form id="operForm" action="/board/modify" method="get">
					          	<input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
					          	<input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
  								<input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
					          	<input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
  								<input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>  
  								 <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					          </form>	 	
					        <!--  /.controller에서 받아온 값 hidden태그로 저장 -->
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            
            
            <!-- 댓글-->
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">
            				<i class="fa fa-commnets fa-fw"></i> 댓글
            				<sec:authorize access="isAuthenticated()">
					        	<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>댓글작성</button>
					        </sec:authorize>     
            			</div>
            			<div class="panel-body">
            				<!-- 댓글목록-->
            				<ul class="chat"></ul>
            			<div class="panel-footer" >            				
            			</div>
            			</div>
            		</div>            	
            	</div>            	
            </div>            
            <!-- /댓글 -->
            
            
            <!--댓글 모달창-->
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog"
				aria-labelledby="myModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal"
								aria-hidden="true">&times;</button>
							<h4 class="modal-title" id="myModalLabel">댓글작성</h4>
						</div>
						<div class="modal-body">
							<div class="form-group">
								<label>내용을 입력하세요</label>
								<input class="form-control" name="reply" value="">
							</div>
							<div class="form-group">
								<label>작성자</label>
								<input class="form-control" name="replyer" value="" readonly>
							</div>
							<div class="form-group">
								<label>작성일</label>
								<input class="form-control" name="replyDate" value="">
							</div>						
						</div>
						<div class="modal-footer">
							<button id='modalModBtn' type="button" class="btn btn-warning">수정하기</button>
					        <button id='modalRemoveBtn' type="button" class="btn btn-danger">삭제</button>
					        <button id='modalRegisterBtn' type="button" class="btn btn-primary">댓글작성</button>
					        
					        <button id='modalCloseBtn' type="button" class="btn btn-default">닫기</button>										
						</div>
					</div>
					<!-- /.modal-content -->
				</div>
				<!-- /.modal-dialog -->
			</div>
            <!-- /.댓글 모달창 -->
            
            
            
            <!-- JQuery -->
            <script type="text/javascript" src="/resources/js/reply.js"></script>
            
            <script>
            $(document).ready(function(){
            	var bnoValue = '<c:out value="${board.bno}"/>';//부모글번호
            	var replyUL = $(".chat");//댓글목록
            	
            	//댓글목록
            	showList(1);
            	
            	function showList(page){            	      
	           	      replyService.getList({bno:'<c:out value="${board.bno}"/>',page: page|| 1 }, function(replyCnt, list) {
	           	        
	           	    	console.log("################ : "+list.length)  
	           	    	  
	           	    	  
	           	        var str="";
	           	       if(list == null || list.length == 0){
	           	        
	           	        replyUL.html("");
	           	        
	           	        return;
	           	      }
	           	       for (var i = 0, len = list.length || 0; i < len; i++) {
	           	           str +="<li style='cursor:pointer' class='left clearfix' data-rno='"+list[i].rno+"'>";
	           	           str +="  <div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>"; 
	           	           str +="    <small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
	           	           str +="    <p>"+list[i].reply+"</p></div></li>";
	           	         }


	           	    replyUL.html(str);
	           	    
	           	    //댓글페이지번호
	           	    showReplyPage(replyCnt);
	           	    

           	      });//end function
           	      
           	   }//end showList 
           	
            	//댓글페이지번호출력
            	var pageNum=1;//기본페이지번호 1
            	var replyPageFooter = $(".panel-footer"); //댓글페이지번호 출력되는 부분
            	
            	function showReplyPage(replyCnt){
            		var endNum=Math.ceil(pageNum/10.0)*10; // 현재 구간 마지막페이지번호
            		var startNum=endNum-9;// 현재 구간 첫페이지번호
            		var prev=startNum!=1;//이전 구간 존재 여부
            		var next=false; //다음 구간 존재 여부
            		//계산으로 구한 마지막페이지번호*10 보다 실제 전체댓글갯수가 작으면
            		if(endNum*10>=replyCnt){
            			endNum=Math.ceil(replyCnt/10.0);//현재 구간 마지막페이지번호를 실제 페이지번호로 교체            			
            		}
            		//계산으로 구한 마지막페이지번호*10 보다 실제 전체댓글갯수가 크면
            		if(endNum*10<replyCnt){
            			next=true; //다음구간 존재 여부 true
            		}
            		var str = "<ul class='pagination pull-right'>";
            	      
            	    if(prev){
            	      str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
            	    }
            	    
            	    for(var i = startNum ; i <= endNum; i++){            	      
            	      var active = pageNum == i? "active":"";            	      
            	      str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
            	    }
            	    
            	    if(next){
            	      str+= "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
            	    }
            	    
            	    str += "</ul></div>";        	    
            	    	    
            	    replyPageFooter.html(str);
            	}
            	
            	//첨부파일목록
            	(function(){            		  
            	    var bno = '<c:out value="${board.bno}"/>';            	   
            	    $.getJSON("/board/getAttachList", {bno: bno}, function(arr){            	     
            	       var str = "";            	       
            	       $(arr).each(function(i, attach){            	       
            	         //image type
            	         if(attach.fileType){
            	           var fileCallPath =  encodeURIComponent( attach.uploadPath+ "/s_"+attach.uuid +"_"+attach.fileName);            	           
            	           str += "<li style='cursor:pointer' data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
            	           str += "<span> "+ attach.fileName+"</span><br/>";
            	           str += "<img src='/display?fileName="+fileCallPath+"'>";
            	           str += "</div>";
            	           str +"</li>";
            	         }else{            	             
            	           str += "<li style='cursor:pointer' data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
            	           str += "<span> "+ attach.fileName+"</span><br/>";
            	           str += "<img src='/resources/img/attach.png'></a>";
            	           str += "</div>";
            	           str +"</li>";
            	         }
            	       });
            	       
            	       $(".uploadResult ul").html(str);            	       
            	     });        	    
            	  })();
            	
            	 $(".uploadResult").on("click","li", function(){            		    
           		    var liObj = $(this);            		    
           		    var path = encodeURIComponent(liObj.data("path")+"/" + liObj.data("uuid")+"_" + liObj.data("filename"));
           		    
           		    if(liObj.data("type")){
           		      showImage(path.replace(new RegExp(/\\/g),"/"));
           		    }else {
           		      self.location ="/download?fileName="+path
           		    }
           		  });
           		  
           		  function showImage(fileCallPath){  
           		    $(".bigPictureWrapper").css("display","flex").show();
           		    
           		    $(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"' >")
           		    .animate({width:'100%', height: '100%'}, 1000);           		    
           		  }

           		  $(".bigPictureWrapper").on("click", function(){
           		    $(".bigPicture").animate({width:'0%', height: '0%'}, function(){
           		      $('.bigPictureWrapper').hide();
           		    });           		   
           		  });
           		  
           		//현재문서에서 ajax방식으로 전송될 때마다 헤더에 cscf토큰을 담아서 전송  
             		var csrfHeaderName ="${_csrf.headerName}"; 
      				var csrfTokenValue="${_csrf.token}";
             		$(document).ajaxSend(function(e, xhr, options) { 
  			        xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
  			    	}); 
             		//로그인한 사용자의 id를 replyer변수에 저장
             		var replyer = null;           	    
             	    <sec:authorize access="isAuthenticated()">           	    
             	    	replyer = '<sec:authentication property="principal.username"/>';  
             		</sec:authorize>
			            	
            	 
            	/* Event 처리 ***********************************************************************/
            	var operForm=$("#operForm");
            	
            	//수정버튼
            	$("button[data-oper='modify']").on("click", function(e){            		    
	      		  operForm.attr("action","/board/modify").submit();	      		    
	      		});	      		  
	      		//목록버튼   
	      		$("button[data-oper='list']").on("click", function(e){	      		    
	      		  operForm.find("#bno").remove();
	      		  operForm.attr("action","/board/list")
	      		  operForm.submit();	      		    
	      		});  
	      		
	      	    var modal = $(".modal");
	      	    var modalInputReply = modal.find("input[name='reply']");
	      	    var modalInputReplyer = modal.find("input[name='replyer']");
	      	    var modalInputReplyDate = modal.find("input[name='replyDate']");
	      	    
	      	    var modalModBtn = $("#modalModBtn");
	      	    var modalRemoveBtn = $("#modalRemoveBtn");
	      	    var modalRegisterBtn = $("#modalRegisterBtn");
	      	    //모달창close버튼
	      	    $("#modalCloseBtn").on("click",function(){
	      	    	modal.modal("hide");
	      	    });	      	    
	      	    //댓글등록버튼
	      	    $("#addReplyBtn").on("click",function(){
	      	    	//입력항목초기화
	      	    	modal.find("input").val("");
	      	    	//댓글작성자
	      	    	modalInputReplyer.val(replyer);	      	    	
	      	    	//날짜안보이게
	      	    	modalInputReplyDate.closest("div").hide();
	      	    	//close버튼제외하고 모든 버튼 안보이게
	      	    	modal.find("button[id!='modalCloseBtn']").hide();
	      	    	//등록버튼보이게
	      	    	modalRegisterBtn.show();
	      	    	//모달창보이게
	      	    	modal.modal("show");
	      	    });
	      		//모달창 등록버튼
	      		modalRegisterBtn.on("click",function(){
	      			//전송할 데이터
	      			var reply={
	      					reply: modalInputReply.val(),
	      		            replyer:modalInputReplyer.val(),
	      		            bno:bnoValue
	      			}
	      			//replyService.add(전송데이터,callback함수(success함수),error함수) 호출
	      			//error함수는 전달하지 않고 있음
	      			replyService.add(reply, function(result){
	      		        alert(result);
	      		        modal.find("input").val("");
	      		        modal.modal("hide");
	      		        showList(1);//댓글목록갱신
	      		        //showList(-1);	      		        
	      		    });	      			
	      		});	
		      	//댓글 조회 클릭 이벤트 처리. 위임(delegate). 자식 <li>가 아직 생성되지 않았으므로 부모인 <ul class='chat'>에 이벤트 위임. 
		      	$(".chat").on("click", "li", function(e){
	      	      
	      	      	var rno = $(this).data("rno"); //댓글번호
	      	      
	      	     	replyService.get(rno, function(reply){
	      	      
		      	        modalInputReply.val(reply.reply);
		      	        modalInputReplyer.val(reply.replyer);
		      	        modalInputReplyDate.val(replyService.displayTime( reply.replyDate)).attr("readonly","readonly");
		      	        modal.data("rno", reply.rno); // data-rno="10"형식으로 저장
		      	        
		      	        modal.find("button[id !='modalCloseBtn']").hide(); // close버튼만 보이게
		      	        modalModBtn.show(); // 수정버튼 보이게
		      	        modalRemoveBtn.show();// 삭제버튼 보이게
		      	        
		      	        $(".modal").modal("show");	      	            
	      	      });
	      	    });
		      	//모달창삭제버튼
		        modalRemoveBtn.on("click", function (e){		      	  
	        	  var rno = modal.data("rno");
	        	  
	           	  if(!replyer){
	           		  alert("로그인후 삭제가 가능합니다.");
	           		  modal.modal("hide");
	           		  return;
	           	  }
	           	  
	           	  var originalReplyer = modalInputReplyer.val();   
	           	  
	           	  if(replyer  != originalReplyer){	           		  
	           		  alert("자신이 작성한 댓글만 삭제가 가능합니다.");
	           		  modal.modal("hide");
	           		  return;
	           	  }
	        	  
	        	  replyService.remove(rno,originalReplyer, function(result){	        	        
	        	      alert(result);
	        	      modal.modal("hide");
	        	      showList(pageNum); //목록갱신	        	      
	        	  });	        	  
	        	});
		      	//모달창수정버튼
		      	modalModBtn.on("click",function(){
		      	  var originalReplyer = modalInputReplyer.val();		      		
		      	  var reply = {
		      			      rno:modal.data("rno"), 
		      			      reply: modalInputReply.val(),
		      			      replyer: originalReplyer};
		      	  
		      		if(!replyer){
		      			 alert("로그인후 수정이 가능합니다.");
		      			 modal.modal("hide");
		      			 return;
		      		}		      		
		      		if(replyer  != originalReplyer){		      		 
		      			 alert("자신이 작성한 댓글만 수정이 가능합니다.");
		      			 modal.modal("hide");
		      			 return;		      		 
		      		}
		      		
		      		replyService.update(reply,function(result){
		      			alert(result);
		      			modal.modal("hide");
		      			showList(pageNum);//댓글목록갱신
		      		});
		      	});
		      	//댓글페이지번호클릭. Delegate
		      	  replyPageFooter.on("click","li a", function(e){
			       e.preventDefault();//다른페이지로 이동을 방지			       
			       var targetPageNum = $(this).attr("href");			       
			       pageNum = targetPageNum;//페이지번호
			       
			       showList(pageNum);
			     }); 
		      	
		      	
		        /*  / Event 처리 ***********************************************************************/
		      	
            });
            </script>
             <!-- /.JQuery -->
            
<%@include file="../includes/footer.jsp"%>