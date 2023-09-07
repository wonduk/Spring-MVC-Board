/* 댓글페이징처리를 위한 VO
 * */

package org.zerock.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

@Data
@AllArgsConstructor
@Getter
public class ReplyPageDTO {
	private int replyCnt;
	private List<ReplyVO> list;

}
