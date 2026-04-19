package com.myguard.communication.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Firestore collection: /poll_votes/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PollVoteEntity {
    private String id;
    private String pollId;
    private String voterUid;
    private List<String> selectedOptions;
    private Object votedAt;
}
