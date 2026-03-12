package com.FINAL.KIP.user.dto.req;


import com.FINAL.KIP.user.domain.Role;
import com.FINAL.KIP.user.domain.User;
import lombok.Getter;
import lombok.Setter;

import java.util.concurrent.ThreadLocalRandom;


@Setter
@Getter
public class CreateUserReqDto {
    private String name;
    private String email;
    private String phoneNumber;
    private String password;
    private String profileImageUrl;
    private String employedDay;
    private String employeeId;

    public User makeUserReqDtoToUser(String encodedPassword, String employeeId) {
        return User.builder()
                .name(this.name)
                .email(this.email)
                .phoneNumber(this.phoneNumber)
                .password(encodedPassword)
//                .profileImageUrl(this.profileImageUrl) 임시로 랜덤이미지
                .profileImageUrl("https://picsum.photos/3"+ ThreadLocalRandom.current().nextInt(10, 99))
                .employedDay(this.employedDay)
                .employeeId(employeeId)
                .role(Role.USER)
                .build();
    }
}
