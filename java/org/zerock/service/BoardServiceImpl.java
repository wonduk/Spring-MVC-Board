package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
//import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardMapper;
import org.zerock.mapper.ReplyMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {

	private BoardMapper mapper;
	private ReplyMapper replymapper;
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public void register(BoardVO board) {

		log.info("register......" + board);

		mapper.insertSelectKey(board);
		if(board.getAttachList() == null || board.getAttachList().size() <=0) {
			return;
		}
		board.getAttachList().forEach(attach->{
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {

		log.info("get......" + bno);

		return mapper.read(bno);

	}
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		attachMapper.deleteAll(board.getBno());
		boolean modifyResult = mapper.update(board) == 1;		
		if (modifyResult && ( board.getAttachList()!=null && board.getAttachList().size() > 0)) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	
	
	@Transactional
	@Override
	public boolean remove(Long bno) {
		//다른방법: 참조키 설정시 on delete casecade를 추가하면 부모글 삭제시 댓글도 같이 삭제됨
		//댓글먼저 삭제 코딩 쓰기
		attachMapper.deleteAll(bno);
		replymapper.deleteAll(bno);
		
		return mapper.delete(bno) == 1;
	}

	//페이징처리 있는 메서드
	@Override
	public List<BoardVO> getList(Criteria cri) {
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		
		return attachMapper.findByBno(bno);
	}

}
