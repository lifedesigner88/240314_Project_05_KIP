package com.FINAL.KIP.common.firebase.service;

import com.FINAL.KIP.user.dto.req.LoginReqDto;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

@Service
@ConditionalOnProperty(name = "app.features.push-enabled", havingValue = "false", matchIfMissing = true)
public class NoOpPushTokenService implements PushTokenService {

    @Override
    public void saveToken(LoginReqDto loginReqDto) {
    }

    @Override
    public void deleteToken(String employeeId) {
    }
}
