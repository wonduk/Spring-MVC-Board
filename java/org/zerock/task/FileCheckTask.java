package org.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
@AllArgsConstructor
public class FileCheckTask {

	private BoardAttachMapper attachMapper;
	
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-mm-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String str = sdf.format(cal.getTime());
		
		return str.replace("-", File.separator);
	}
	
	@Scheduled(cron = "0 0 17 * * *")
	public void checkFiles() throws Exception{
		log.warn(new Date());
		//파일 리스트에 디비에 넣음
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		//디렉토리에 디비파일리스트를 체크해서 준비
		List<Path> fileListPaths = fileList.stream()
				.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_"+ vo.getFileName()))
				.collect(Collectors.toList());
		
		// image file has thumnail file 롬복이 get이 아닌 isFile로 만들음-boolean타입이기 때문.
		fileList.stream().filter(vo -> vo.isFileType() == true)
		.map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_"+ vo.getFileName()))
		.forEach(p -> fileListPaths.add(p));
		
		log.warn("===========================================");
		//warn은 warining log의 레벨을 뜻함 .info() =>infomation레벨/ error fatal debug등이 있음 
		fileListPaths.forEach(p -> log.warn(p));

		//어제 디렉토리를 files에 넣음
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		log.warn("===========================================");
		
		for (File file : removeFiles) {
			file.delete();
		}
	}
	
	

}
