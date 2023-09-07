package org.zerock.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {
	private ReplyService service;//자동주입
	
	//등록. 폼에 입력한 값(json형태로 넘어옴)을 @RequestBody를 이용해서 vo에 저장한 후 처리
	@PostMapping(value="/new",consumes="application/json",produces="text/plain; charset=UTF-8")
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		int insertCount=service.register(vo);
		// insert가 성공하면 영향을 받은 행의 수 1이 넘어옴
		return insertCount==1 ? new ResponseEntity<>("등록되었습니다.",HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}	
	//목록 with paging
	@GetMapping(value = "/pages/{bno}/{page}",produces = { MediaType.APPLICATION_XML_VALUE,MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno) {
		Criteria cri = new Criteria(page, 10);

		log.info("======= "+service.getListPage(cri, bno));
		return new ResponseEntity<>(service.getListPage(cri, bno), HttpStatus.OK);
	}
	//상세보기
	@GetMapping(value = "/{rno}", 
			produces = { MediaType.APPLICATION_XML_VALUE,MediaType.APPLICATION_JSON_UTF8_VALUE })
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {
		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
	}
	//삭제
	@PreAuthorize("principal.username == #vo.replyer")
	@DeleteMapping(value = "/{rno}", produces = {"text/plain; charset=UTF-8" })
	public ResponseEntity<String> remove(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {
		return service.remove(rno) == 1 ? new ResponseEntity<>("삭제되었습니다.", HttpStatus.OK): new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	//수정
	@PreAuthorize("principal.username == #vo.replyer")
	@RequestMapping(method = { RequestMethod.PUT,
				RequestMethod.PATCH}, value = "/{rno}", consumes = "application/json", produces = {
						"text/plain; charset=UTF-8" })
	public ResponseEntity<String> modify(
			@RequestBody ReplyVO vo,
			@PathVariable("rno") Long rno){
		vo.setRno(rno);
		return service.modify(vo) ==1
				? new ResponseEntity<>("수정되었습니다..", HttpStatus.OK): new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		
	}
	
	
}
