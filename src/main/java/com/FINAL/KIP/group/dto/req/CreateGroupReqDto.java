package com.FINAL.KIP.group.dto.req;

import com.FINAL.KIP.group.domain.Group;
import com.FINAL.KIP.group.domain.GroupType;
import lombok.Getter;
import lombok.Setter;

@Setter
public class CreateGroupReqDto {

    private String groupName;
    private String groupType;

    @Getter
    private Long superGroupId;

    public Group makeAuthorityReqDtoToGroup(){
        return Group.builder()
                .groupName(this.groupName)
                .groupType(GroupType.valueOf(this.groupType))
                .build();
    }

}
