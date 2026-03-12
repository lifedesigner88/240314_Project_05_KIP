package com.FINAL.KIP.common.firebase.service;

import com.FINAL.KIP.user.dto.req.LoginReqDto;

public interface PushTokenService {

    void saveToken(LoginReqDto loginReqDto);

    void deleteToken(String employeeId);
}
