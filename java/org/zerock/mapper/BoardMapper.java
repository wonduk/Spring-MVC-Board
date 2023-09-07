/* 게시글 Mapper.java
 * */

package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardMapper {
	//목록
	public List<BoardVO> getList();
	//등록 sequence구하기
	public Integer insertSelectKey(BoardVO board);
	//목록
	public List<BoardVO> getListWithPaging(Criteria cri);
	//등록
	public void insert(BoardVO board);
	//상세보기
	public BoardVO read(Long bno);
	//삭제
	public int delete(Long bno);
	//수정
	public int update(BoardVO board);
	//전체 글 개수
	public int getTotalCount(Criteria cri);

	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
	
	public List<BoardAttachVO> findByBno(Long bno);
	
	
	
}
