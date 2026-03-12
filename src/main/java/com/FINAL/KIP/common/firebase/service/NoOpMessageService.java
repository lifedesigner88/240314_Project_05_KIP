package com.FINAL.KIP.common.firebase.service;

import com.FINAL.KIP.common.firebase.dto.FCMMessageDto;
import java.util.List;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

@Service
@ConditionalOnProperty(name = "app.features.push-enabled", havingValue = "false", matchIfMissing = true)
public class NoOpMessageService implements MessageService {

    @Override
    public void sendNewRequestMessage(List<FCMMessageDto> fcmMessageDtos) {
    }

    @Override
    public void sendRefuseRequestMessage(FCMMessageDto fcmMessageDto) {
    }

    @Override
    public void sendAgreeRequestMessage(FCMMessageDto fcmMessageDto) {
    }
}
