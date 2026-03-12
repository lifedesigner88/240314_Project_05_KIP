package com.FINAL.KIP.common.firebase.service;

import com.FINAL.KIP.common.firebase.FCMTokenDao;
import com.FINAL.KIP.user.dto.req.LoginReqDto;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

@Service
@ConditionalOnProperty(name = "app.features.push-enabled", havingValue = "true")
public class RedisPushTokenService implements PushTokenService {

    private final FCMTokenDao fcmTokenDao;

    public RedisPushTokenService(FCMTokenDao fcmTokenDao) {
        this.fcmTokenDao = fcmTokenDao;
    }

    @Override
    public void saveToken(LoginReqDto loginReqDto) {
        fcmTokenDao.saveToken(loginReqDto);
    }

    @Override
    public void deleteToken(String employeeId) {
        fcmTokenDao.deleteToken(employeeId);
    }
}
