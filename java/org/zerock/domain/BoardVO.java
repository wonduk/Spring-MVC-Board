/* 게시판VO
 * bno = 글번호, title=제목, content= 내용, writer=작성자, regdate=작성일, updateDate=수정일, replyCnt=댓글갯수, attachList=파일첨부관련DTO
 * */

package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {

  private Long bno;
  private String title;
  private String content;
  private String writer;
  private Date regdate;
  private Date updateDate;
  private int replyCnt;
  
  private List<BoardAttachVO> attachList;
}
