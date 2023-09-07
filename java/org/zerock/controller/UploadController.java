package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {

	@GetMapping("/uploadForm")
	public void uploadForm() {}

	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		for (MultipartFile multipartFile : uploadFile) {		
			log.info("-------------------------------------");
			log.info("Upload File Name: " +multipartFile.getOriginalFilename());
			log.info("Upload File Size: " +multipartFile.getSize());	
			
			String uploadFolder = "C:\\upload";
			
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());

			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
			} // end catch
		}
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {}
	
	//현재날짜를 구해서 2023/08/18 형식으로 리턴
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}	
	//파일이 이미지파일인지 체크
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			log.info("contentType========================== "+contentType);
			return contentType.startsWith("image");
		} catch (IOException e) {			
			e.printStackTrace();
		}
		return false;
	}
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value="/uploadAjaxAction",produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody // Ajax 방식. json 리턴 위해서 사용
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {	
	
		//파일목록
		List<AttachFileDTO> list=new ArrayList();	
		
		 String uploadFolder = "C:\\upload";
		 
		 //2023/08/18형식의 폴더생성
		 String uploadFolderPath = getFolder();		 
		 File uploadPath=new File(uploadFolder, uploadFolderPath);
		 if(uploadPath.exists()==false) {
			 uploadPath.mkdirs();//폴더를 여러개 생성해줌
		 }
		 
		 for (MultipartFile multipartFile : uploadFile) {	
			
			 //DTO생성
			 AttachFileDTO attachDTO=new AttachFileDTO();
			 
			 String uploadFileName = multipartFile.getOriginalFilename();
			 log.info("** uploadFileName *********** "+uploadFileName);
			 
			 //log.info("only file name: " + uploadFileName);
			 // IE는 파일경로도 포함해서 파일명이 리턴됨. 마지막 '\'를 찾아서 뒷부분을 substring을 잘라내면 파일명만 구할수 있음.
			// uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			 //log.info("only file name: " + uploadFileName);
			 
			 attachDTO.setFileName(uploadFileName);// 원본파일 이름
			 
			 UUID uuid = UUID.randomUUID();				
			 uploadFileName = uuid.toString() + "_" + uploadFileName;			 		 
			 File saveFile = new File(uploadPath, uploadFileName);
			
			 try {			
				 multipartFile.transferTo(saveFile);
				 
				 attachDTO.setUuid(uuid.toString()); //uuid
				 attachDTO.setUploadPath(uploadFolderPath); //uploadPath
				 
				 //이미지파일인 경우 썸네일생성
				 if (checkImageType(saveFile)) {	
					 attachDTO.setImage(true); // image여부 true로 설정.
					 
					 FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));					
					 Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					
					 thumbnail.close();
				 }
				 
//				 list.add(attachDTO);// 목록에 추가
			 } catch (Exception e) {
				 log.error(e.getMessage());
			 } // end catch	
			 
			list.add(attachDTO);// 목록에 추가
			 log.info("################### "+attachDTO);
		 } // end for
		 return new ResponseEntity<>(list, HttpStatus.OK);
	 }
	
	// image를 찾아서 front end로 전달
	// 실제 image 경로를 사용하면 crawling tool로 image를 전부 긁어갈 수도 있음. 방지효과가 있음.
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		File file=new File("c:\\upload\\"+fileName);
		log.info("file : "+file);
		ResponseEntity<byte[]> result=null;
		try {
			HttpHeaders header=new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName) {
		Resource resource = new FileSystemResource("c:\\upload\\" + fileName);
		if (resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		String resourceName = resource.getFilename();
		// remove UUID. 원본파일명 구하기
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);

		HttpHeaders headers = new HttpHeaders();
		try {
			// 기존 IE, Edge 는 한글인코딩이 다르므로 user-agent를 구해서 if문으로 제어. 현재 IE는 edge로 넘어가도록 update됨.
			// Edge는 현재 chromium으로 새로 구현되어 chrome브라우저 처럼 동작함. naver whale 브라우저도 chrominum기반임
			String downloadName = null;
			
//			if ( userAgent.contains("Trident")) {				
//				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
//			}else if(userAgent.contains("Edge")) {				
//				downloadName =  URLEncoder.encode(resourceOriginalName,"UTF-8");
//			}else {				
//				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
//			}

		    downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");			
			// uuid를 제거한 원본파일명으로 다운로드
			headers.add("Content-Disposition", "attachment; filename=" + downloadName);

		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		File file;
		try {
			file=new File("c:\\upload\\"+URLDecoder.decode(fileName,"UTF-8"));
			file.delete(); //썸네일파일삭제. 일반파일삭제
			//이미지이면 원본이미지파일삭제
			if(type.equals("image")) {
				String largeFileName=file.getAbsolutePath().replace("s_", "");
				file=new File(largeFileName);
				file.delete();
			}
		}catch(Exception e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
}
