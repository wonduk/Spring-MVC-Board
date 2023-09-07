/* 첨부파일 DTO
 * fileName=파일이름, uploadPath= 파일경로, uuid=유저아이디, image=이미지파일여부
 * */

package org.zerock.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
	private String fileName;
	private String uploadPath;
	private String uuid;
	private boolean image; //img파일여부
}
