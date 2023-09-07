package org.zerock.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.mapper.BoardMapper;
import org.zerock.mapper.ReplyMapper;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class ReplySeriveImpl implements ReplyService {
	private ReplyMapper mapper;
	private BoardMapper boardMapper;
	
	@Transactional
	@Override
	public int register(ReplyVO vo) {
		//댓글 개수 update
		boardMapper.updateReplyCnt(vo.getBno(), 1);			
		return mapper.insert(vo);
	}

	@Override
	public int modify(ReplyVO vo) {
		return mapper.update(vo);
	}
	@Transactional
	@Override
	public int remove(Long rno) {
		ReplyVO vo = mapper.read(rno);
		boardMapper.updateReplyCnt(vo.getBno(), -1);
		return mapper.delete(rno);
	}

	@Override
	public ReplyVO get(Long rno) {
		return mapper.read(rno);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		return mapper.getListWithPaging(cri, bno);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
			return new ReplyPageDTO(mapper.getCountByBno(bno), mapper.getListWithPaging(cri, bno));			
		
	}
	
}
