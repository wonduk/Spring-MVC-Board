/* 게시글목록 게시글표시갯수VO
 *  */

package org.zerock.domain;

import static org.springframework.test.web.client.match.MockRestRequestMatchers.queryParam;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Setter
@Getter
public class Criteria {
	private int pageNum;
	  private int amount;
	  private String type;
	  private String keyword;


	  public Criteria() {
	    this(1, 10);
	  }

	  public Criteria(int pageNum, int amount) {
	    this.pageNum = pageNum;
	    this.amount = amount;
	  }
	  
	  public void Criterfia(int amount) {
	        this.amount = amount;
	    }

	  public String[] getTypeArr() {
		    return type == null? new String[] {}: type.split("");
		  }
	  
	  
	  //url query string
	  public String getListLink() {
		//formPath가 ?pageNum=1의 ?앞의 주소를 만들어 줌 ""은 문자열이 없다는 뜻 .queryParam으로 그 뒤에 주소창을 붙여줌
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("PageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
		return builder.toUriString();
	  }

	
}
