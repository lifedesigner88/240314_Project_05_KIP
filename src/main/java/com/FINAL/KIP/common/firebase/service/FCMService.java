package com.FINAL.KIP.common.firebase.service;

import com.FINAL.KIP.common.firebase.FCMTokenDao;
import com.FINAL.KIP.common.firebase.dto.FCMMessageDto;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import java.util.List;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

@Service
@ConditionalOnProperty(name = "app.features.push-enabled", havingValue = "true")
public class FCMService implements MessageService {

	private final FCMTokenDao fcmTokenDao;

	public FCMService(FCMTokenDao fcmTokenDao) {
		this.fcmTokenDao = fcmTokenDao;
	}

	@Override
	public void sendNewRequestMessage(List<FCMMessageDto> fcmMessageDtos) {
		for (FCMMessageDto fcmMessageDto : fcmMessageDtos) {
			if (!hasKey(fcmMessageDto.getEmployeeId())) {
				return;
			}

			String token = getToken(fcmMessageDto.getEmployeeId());
			Message message = Message.builder()
				.putData("title", "새로운 문서 접근 권한 요청")
				.putData("content", fcmMessageDto.getMessage())
				.setToken(token)
				.build();

			send(message);
		}
	}

	@Override
	public void sendRefuseRequestMessage(FCMMessageDto fcmMessageDto) {
		if (!hasKey(fcmMessageDto.getEmployeeId())) {
			return;
		}

		String token = getToken(fcmMessageDto.getEmployeeId());
		Message message = Message.builder()
			.putData("title", "문서 접근 요청 거절")
			.putData("content", fcmMessageDto.getMessage())
			.setToken(token)
			.build();

		send(message);
	}

	@Override
	public void sendAgreeRequestMessage(FCMMessageDto fcmMessageDto) {
		if (!hasKey(fcmMessageDto.getEmployeeId())) {
			return;
		}

		String token = getToken(fcmMessageDto.getEmployeeId());
		Message message = Message.builder()
			.putData("title", "문서 접근 권한 요청 승인")
			.putData("content", fcmMessageDto.getMessage())
			.setToken(token)
			.build();

		send(message);
	}

	public void send(Message message) {
		FirebaseMessaging.getInstance().sendAsync(message);
	}

	private boolean hasKey(String employeeId) {
		return fcmTokenDao.hasKey(employeeId);
	}

	private String getToken(String employeeId) {
		return fcmTokenDao.getToken(employeeId);
	}
}
