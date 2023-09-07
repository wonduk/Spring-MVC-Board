/* 페이징처리 DTO
 * */

package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	private int startPage;//시작페이지
	private int endPage;// 끝페이지
	private boolean prev, next;// 이전구간, 다음구간 존재여부
	
	private int total; //전체 글의 갯수
	private Criteria cri;
	
	public PageDTO(Criteria cri, int total) {
		
		this.cri = cri;
		this.total = total;
		
		
		this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;

	    this.startPage = this.endPage - cri.getAmount()+1;
	    
		//실제 마지막 페이지 값 /전체글/amount 계산 결과 나머지가 있으면 +1 해야해서 ceil()사용
	    int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));
	    //실제 마지막페이지가 계산으로 구한 마지막페이지보다 작으면 마지막페이지를 교체
	    if (realEnd <= this.endPage) {
	        this.endPage = realEnd;
	      }
	    
		//시작페이지가 1보다 커야 이전페이지가 존재
	    this.prev = this.startPage > 1;
		//끌페이지가 실제 마지막 페이지보다 작아야지 다음 구간이 존재
	    this.next = this.endPage < realEnd;
		
		
	}
	

}
