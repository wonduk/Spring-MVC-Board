/*	파일관련 VO 
 * uuid=유저아이디, uploadPath=파일경로, fileName=파일명, fileType=img파일인지 아닌지 확인, bno=게시글번호
 * */

package org.zerock.domain;

import lombok.Data;

@Data
public class BoardAttachVO {
	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean fileType; //type이 boolean인 경우 getFileType()이 아니라 isFileType으로 생성됨
	private Long bno;
}
