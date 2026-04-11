package com.myguard.communication.repository;

import com.myguard.communication.view.DocumentEntity;
import com.myguard.communication.view.GroupEntity;
import com.myguard.communication.view.MessageEntity;
import com.myguard.communication.view.NoticeEntity;
import com.myguard.communication.view.PollEntity;
import com.myguard.communication.view.PollVoteEntity;

import java.util.List;
import java.util.Optional;

public interface CommunicationRepository {

    // Notices
    NoticeEntity saveNotice(NoticeEntity notice);
    Optional<NoticeEntity> findNoticeById(String id);
    NoticeEntity updateNotice(NoticeEntity notice);
    void deleteNotice(String id);
    List<NoticeEntity> findNotices(String societyId, int page, int size);
    long countNotices(String societyId);

    // Polls
    PollEntity savePoll(PollEntity poll);
    Optional<PollEntity> findPollById(String id);
    List<PollEntity> findPolls(String societyId, int page, int size);
    long countPolls(String societyId);

    // Poll Votes
    PollVoteEntity savePollVote(PollVoteEntity vote);
    List<PollVoteEntity> findVotesByPollId(String pollId);
    Optional<PollVoteEntity> findVoteByPollIdAndVoterUid(String pollId, String voterUid);

    // Groups
    GroupEntity saveGroup(GroupEntity group);
    Optional<GroupEntity> findGroupById(String id);
    List<GroupEntity> findGroups(String societyId, int page, int size);
    long countGroups(String societyId);

    // Messages
    MessageEntity saveMessage(MessageEntity message);
    List<MessageEntity> findMessagesByGroupId(String groupId, int page, int size);
    long countMessagesByGroupId(String groupId);

    // Documents
    DocumentEntity saveDocument(DocumentEntity document);
    Optional<DocumentEntity> findDocumentById(String id);
    List<DocumentEntity> findDocuments(String societyId, int page, int size);
    long countDocuments(String societyId);
}
