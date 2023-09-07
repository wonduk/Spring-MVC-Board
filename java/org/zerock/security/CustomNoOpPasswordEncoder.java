package org.zerock.security;

import org.springframework.security.crypto.password.PasswordEncoder;

public class CustomNoOpPasswordEncoder implements PasswordEncoder{

	//비밀번호 encoding
	@Override
	public String encode(CharSequence rawPassword) {
		// 암호화 알고리즘사용해서 인코딩하는 코드 작성
		
		return rawPassword.toString();
	}

	//비밀번호 일치 여부 판단
	@Override
	public boolean matches(CharSequence rawPassword, String encodedPassword) {
		// 사용자가 입력한 비밀번호(rawPassword)와 테이블에 저장된 비밀번호(encodedPassword)가 같은지 비교
		return rawPassword.toString().equals(encodedPassword);
	}

}
