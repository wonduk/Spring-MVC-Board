/* 게시판 목록 컨트롤러.*/


package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/board/*")
@Log4j
@AllArgsConstructor
public class BoardController {
	private BoardService service; //생성자 의존성 주입. 자동주입. @AllArgsConstructor와 함께 사용함.
	
	
	//목록 with paging
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {		
		 model.addAttribute("list", service.getList(cri));
		 //전체 글의 갯수
		 int total = service.getTotal(cri);
		 //페이지번호 생성.jsp로 전달
		 model.addAttribute("pageMaker", new PageDTO(cri, total));		 
	}
	//등록화면
	// servlet-context.xml에 <security:global-method-security pre-post-annotations="enabled" secured-annotations="enabled" />설정해야
	// @PreAuthorize사용가능
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register() {}
	//등록처리
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVO board, RedirectAttributes rttr) {
		
		log.info("==========첨부파일목록====================");
		
		//List<BoardAttachVO> list=board.getAttachList();
		if(board.getAttachList()!=null) {
			board.getAttachList().forEach(attach->log.info(attach));
		//	for(int i=0;i<list.size();i++) {
		//		log.info(list.get(i));				
		//	}
		}
		
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());//insert된 글번호 전달

		return "redirect:/board/list"; // sendRedirect()역할
	}
	//상세보기.수정화면
	@PreAuthorize("isAuthenticated()")
	@GetMapping({"/get","/modify"})
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		model.addAttribute("board", service.get(bno));
	}
	//수정처리
	@PreAuthorize("principal.username == #board.writer")
	@PostMapping("/modify")
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri,RedirectAttributes rttr) {	
		 if (service.modify(board)) {
			 rttr.addFlashAttribute("result", "modify");
		 }
		 rttr.addAttribute("pageNum", cri.getPageNum());
		 rttr.addAttribute("amount", cri.getAmount());
		 rttr.addAttribute("type", cri.getType());
		 rttr.addAttribute("keyword", cri.getKeyword());
		
		 
		 return "redirect:/board/list";//목록으로 이동
	}
	
	//삭제처리
	@PostMapping("/remove")
	@PreAuthorize("principal.username == #writer")
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr,String writer) {
		
		List<BoardAttachVO> attachList=service.getAttachList(bno);
		
		if (service.remove(bno)) {
			//업로드폴더에 있는 첨부파일 삭제
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result", "remove");
		}
//		rttr.addAttribute("pageNum", cri.getPageNum());
//		rttr.addAttribute("amount", cri.getAmount());
//		rttr.addAttribute("type", cri.getType());
//		rttr.addAttribute("keyword", cri.getKeyword());
//		
//		return "redirect:/board/list";
		
//		return "redirect:/board/list?pageNum="+cri.getPageNum()+"&amount="+cri.getAmount()+"&type="+cri.getType()+"&keyword="+cri.getKeyword();
		
		return "redirect:/board/list"+cri.getListLink(); 
	}
	//첨부파일삭제
	private void deleteFiles(List<BoardAttachVO> attachList) {
		//첨부파일목록이 없으면 중지
	    if(attachList == null || attachList.size() == 0) {
	      return;
	    }	   
	    attachList.forEach(attach -> {
	      try {        
	        Path file  = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\" + attach.getUuid()+"_"+ attach.getFileName());	        
	        Files.deleteIfExists(file);	 
	        //이미지이면 썸네일 삭제
	        if(Files.probeContentType(file).startsWith("image")) {	        
	          Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_" + attach.getUuid()+"_"+ attach.getFileName());
	          Files.delete(thumbNail);
	        }
	
	      }catch(Exception e) {
	        log.error("delete file error" + e.getMessage());
	      }
	    });
	  }
	//첨부파일목록
	@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);

	}

	
}
