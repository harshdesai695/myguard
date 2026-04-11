package com.myguard.communication.service;

import com.myguard.common.response.PaginatedResponse;
import com.myguard.communication.dto.request.CastVoteRequest;
import com.myguard.communication.dto.request.CreateGroupRequest;
import com.myguard.communication.dto.request.CreateNoticeRequest;
import com.myguard.communication.dto.request.CreatePollRequest;
import com.myguard.communication.dto.request.SendMessageRequest;
import com.myguard.communication.dto.request.UpdateNoticeRequest;
import com.myguard.communication.dto.request.UploadDocumentRequest;
import com.myguard.communication.dto.response.DocumentResponse;
import com.myguard.communication.dto.response.GroupResponse;
import com.myguard.communication.dto.response.MessageResponse;
import com.myguard.communication.dto.response.NoticeResponse;
import com.myguard.communication.dto.response.PollResponse;

public interface CommunicationService {

    // Notices
    NoticeResponse createNotice(CreateNoticeRequest request);
    PaginatedResponse<NoticeResponse> listNotices(int page, int size, String societyId);
    NoticeResponse getNoticeById(String id);
    NoticeResponse updateNotice(String id, UpdateNoticeRequest request);
    void deleteNotice(String id);

    // Polls
    PollResponse createPoll(CreatePollRequest request);
    PaginatedResponse<PollResponse> listPolls(int page, int size, String societyId);
    PollResponse getPollById(String id);
    void castVote(String pollId, CastVoteRequest request);

    // Groups
    GroupResponse createGroup(CreateGroupRequest request);
    PaginatedResponse<GroupResponse> listGroups(int page, int size, String societyId);

    // Messages
    MessageResponse sendMessage(String groupId, SendMessageRequest request);
    PaginatedResponse<MessageResponse> listMessages(String groupId, int page, int size);

    // Documents
    DocumentResponse uploadDocument(UploadDocumentRequest request);
    PaginatedResponse<DocumentResponse> listDocuments(int page, int size, String societyId);
    DocumentResponse getDocumentById(String id);
}
