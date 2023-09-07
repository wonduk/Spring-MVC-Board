/*권한 설정, security-context.xml에 권한부여 되어 있음*/

package org.zerock.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/sample/*")
public class SecurityController {

	@GetMapping("/all")
	public void doAll() {}
	
	@GetMapping("/member")
	public void doMember() {}
	
	
	@PreAuthorize("hasRole('ROLE_ADMIN')")
	@GetMapping("/admin")
	public void admin() {}
}
