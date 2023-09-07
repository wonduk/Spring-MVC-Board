<!-- 글쓰기 화면 -->

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>

<%@include file="../includes/header.jsp"%> 
<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}
	
	.uploadResult ul li img {
		width: 100px;
	}
	
	bigPictureWrapper {
	  position: absolute;
	  display: none;
	  justify-content: center;
	  align-items: center;
	  top:0%;
	  width:100%;
	  height:100%;
	  background-color: black; 
	  z-index: 100;
	  opacity: 0.5;
	}
	
	.bigPicture {
	  position: relative;
	  display:flex;
	  justify-content: center;
	  align-items: center;
	 }
</style>    
    
    
    
    		<!-- 글쓰기화면 -->
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Register
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <form role="form" action="/board/register" method="post">
					          <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					          <div class="form-group">
					            <label>Title</label> <input class="form-control" name='title'>
					          </div>
					
					          <div class="form-group">
					            <label>Content</label>
					            <textarea class="form-control" rows="3" name='content'></textarea>
					          </div>
					
					          <div class="form-group">
					            <label>Writer</label> <input class="form-control" name='writer' value='<sec:authentication property="principal.username"/>' readonly="readonly">
					          </div>
					          <!-- 첨부파일 -->
				            <div class="row">
							  <div class="col-lg-12">
							    <div class="panel panel-default">
							
							      <div class="panel-heading">File Attach</div>
							      <!-- /.panel-heading -->
							      <div class="panel-body">
							        <div class="form-group uploadDiv">
							            <input type="file" name='uploadFile' multiple>
							        </div>
							        
							        <div class='uploadResult'> 
							          <ul>
							          
							          </ul>
							        </div>	
							      </div>
							      <!--  end panel-body -->			
							    </div>
							    <!--  end panel-body -->
							  </div>
							  <!-- end panel -->
							</div>
							<!-- /.첨부파일-->
							
								<!-- 저장,리셋버튼 -->
						        <div class="ta-r">
						         <button type="submit" class="btn btn-success">Submit Button</button>
						         <button type="reset" class="btn btn-default">Reset Button</button>
						        </div>
								<!-- /.저장,리셋버튼 -->
					        </form>
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.글쓰기화면 -->
            
           
<!-- JQuery -->           
<script>

$(document).ready(function(){
	//파일크기.파일확장자 체크
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");//정규식.
	var maxSize = 5242880; //5MB

	function checkExtension(fileName, fileSize) {

		if (fileSize >= maxSize) {
			alert("파일 사이즈 초과");
			return false;
		}

		//정규식에 맞으면 true
		if (regex.test(fileName)) {
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}	
	
	  var csrfHeaderName ="${_csrf.headerName}"; 
	  var csrfTokenValue="${_csrf.token}";
	  
	  
	  
	
	$("input[type='file']").on("change", function(e){

		 var formData = new FormData();// form태그 역할에 해당하는 javascript 객체		
		 var inputFile = $("input[name='uploadFile']");		
		 var files = inputFile[0].files; // 파일목록
		
		 //add filedate to formdata
		 for(var i = 0; i < files.length; i++){	
			//파일명.파일크기 체크 
			if(!checkExtension(files[i].name,files[i].size)){
				return false;
			}
			 
		 	formData.append("uploadFile", files[i]); 		
		 }
		
		 $.ajax({
			 url: '/uploadAjaxAction',
			 processData: false,
			 contentType: false,
			 data: formData,
			 type: 'POST',
			 beforeSend: function(xhr) {
		          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		      },
			 datayType: 'json',
			 success: function(result){
				 console.log("#################result###########"+result);
				 
				 showUploadResult(result);
			 }
		 }); //$.ajax		
	}); 

	//첨부파일 미리보기
	function showUploadResult(uploadResultArr){
		//첨부파일이 없으면 중지
		if(!uploadResultArr || uploadResultArr.length == 0){ 
			return; 
		}
		var uploadUL = $(".uploadResult ul");	    
	    var str ="";
	    $(uploadResultArr).each(function(i, obj){
	    	if(obj.image){
				var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
				str += "<li data-path='"+obj.uploadPath+"'";
				str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
				str +" ><div>";
				str += "<span> "+ obj.fileName+"</span>";
				str += "<button type='button' data-file=\'"+fileCallPath+"\' "
				str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName="+fileCallPath+"'>";
				str += "</div>";
				str +"</li>";
			}else{
				var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);			      
			    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
			      
				str += "<li "
				str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
				str += "<span> "+ obj.fileName+"</span>";
				str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' " 
				str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/resources/img/attach.png'></a>";
				str += "</div>";
				str +"</li>";
			}	    	
	    });
	    uploadUL.append(str);
	}
	 $(".uploadResult").on("click", "button", function(e){
		    
		    console.log("delete file");
		      
		    var targetFile = $(this).data("file");
		    var type = $(this).data("type");
		    
		    var targetLi = $(this).closest("li");
		    
		    $.ajax({
		      url: '/deleteFile',
		      data: {fileName: targetFile, type:type},
		      dataType:'text',
		      type: 'POST',
		      beforeSend: function(xhr) {
		          xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		      },
		        success: function(result){
		           alert(result);
		           
		           targetLi.remove();
		         }
		    }); //$.ajax
		   });
	 
	 
	 var formObj = $("form[role='form']");
	  
	  $("button[type='submit']").on("click", function(e){
	    
	    e.preventDefault();
	    
	    console.log("submit clicked");
	    
	    var str = "";
	    
	    $(".uploadResult ul li").each(function(i, obj){
	      
	      var jobj = $(obj);
	      
	      console.dir(jobj);
	      console.log("-------------------------");
	      console.log(jobj.data("filename"));
	      
	      
	      str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
	      str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
	      
	    });
	    
	    console.log(str);
	    
	    formObj.append(str).submit();
	    
	  });
	
});



</script>
<!-- /.JQuery -->           

            
<%@include file="../includes/footer.jsp"%>