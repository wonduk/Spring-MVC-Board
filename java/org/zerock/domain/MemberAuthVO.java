/* 
 * */

package org.zerock.domain;

import java.util.Date;

import lombok.Data;

@Data
public class MemberAuthVO {
	private String userid;
	private String userpw;
	private String userName;
	private boolean enabled;
	private Date regDate;
	private Date updateDate;
	private String auth;
}
