/* 댓글 Mapper.java
 * */

package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyMapper {
	
	public List<ReplyVO> getListWithPaging(@Param("cri") Criteria cri, @Param("bno") Long no);
	//등록
	public int insert(ReplyVO vo);
	// 상세보기
	public ReplyVO read(Long rno);
	//삭제
	public int delete(Long rno);
	// 수정
	public int update(ReplyVO reply);
	//전체 글 수
	public int getCountByBno(Long bno);
	//부모글삭제시 댓글삭제
	public int deleteAll(Long bno);
}
