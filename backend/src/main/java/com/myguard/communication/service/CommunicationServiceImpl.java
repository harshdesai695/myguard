package com.myguard.communication.service;

import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.exception.ValidationException;
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
import com.myguard.communication.repository.CommunicationRepository;
import com.myguard.communication.view.DocumentEntity;
import com.myguard.communication.view.GroupEntity;
import com.myguard.communication.view.MessageEntity;
import com.myguard.communication.view.NoticeEntity;
import com.myguard.communication.view.PollEntity;
import com.myguard.communication.view.PollVoteEntity;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class CommunicationServiceImpl implements CommunicationService {

    private final CommunicationRepository communicationRepository;

    private String getCurrentUid() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }

    // --- Notices ---

    @Override
    public NoticeResponse createNotice(CreateNoticeRequest request) {
        String uid = getCurrentUid();
        log.info("[COMMUNICATION] Creating notice: {}", request.getTitle());

        NoticeEntity entity = NoticeEntity.builder()
                .title(request.getTitle())
                .body(request.getBody())
                .type(request.getType())
                .attachments(request.getAttachments())
                .postedBy(uid)
                .postedAt(Instant.now().toString())
                .expiryDate(request.getExpiryDate() != null ? request.getExpiryDate().toString() : null)
                .societyId(request.getSocietyId())
                .createdAt(Instant.now().toString())
                .updatedAt(Instant.now().toString())
                .build();

        NoticeEntity saved = communicationRepository.saveNotice(entity);
        log.info("[COMMUNICATION] Notice created with ID: {}", saved.getId());
        return mapToNoticeResponse(saved);
    }

    @Override
    public PaginatedResponse<NoticeResponse> listNotices(int page, int size, String societyId) {
        List<NoticeEntity> notices = communicationRepository.findNotices(societyId, page, size);
        long total = communicationRepository.countNotices(societyId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<NoticeResponse> content = notices.stream()
                .map(this::mapToNoticeResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<NoticeResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public NoticeResponse getNoticeById(String id) {
        NoticeEntity entity = communicationRepository.findNoticeById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Notice not found"));
        return mapToNoticeResponse(entity);
    }

    @Override
    public NoticeResponse updateNotice(String id, UpdateNoticeRequest request) {
        NoticeEntity entity = communicationRepository.findNoticeById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Notice not found"));

        if (request.getTitle() != null) entity.setTitle(request.getTitle());
        if (request.getBody() != null) entity.setBody(request.getBody());
        if (request.getType() != null) entity.setType(request.getType());
        if (request.getAttachments() != null) entity.setAttachments(request.getAttachments());
        if (request.getExpiryDate() != null) entity.setExpiryDate(request.getExpiryDate().toString());
        entity.setUpdatedAt(Instant.now().toString());

        NoticeEntity updated = communicationRepository.updateNotice(entity);
        log.info("[COMMUNICATION] Notice updated: {}", id);
        return mapToNoticeResponse(updated);
    }

    @Override
    public void deleteNotice(String id) {
        communicationRepository.findNoticeById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Notice not found"));
        communicationRepository.deleteNotice(id);
        log.info("[COMMUNICATION] Notice deleted: {}", id);
    }

    // --- Polls ---

    @Override
    public PollResponse createPoll(CreatePollRequest request) {
        String uid = getCurrentUid();
        log.info("[COMMUNICATION] Creating poll: {}", request.getQuestion());

        PollEntity entity = PollEntity.builder()
                .question(request.getQuestion())
                .options(request.getOptions())
                .startDate(request.getStartDate() != null ? request.getStartDate().toString() : null)
                .endDate(request.getEndDate() != null ? request.getEndDate().toString() : null)
                .isSecret(request.isSecret())
                .allowMultipleVotes(request.isAllowMultipleVotes())
                .createdBy(uid)
                .societyId(request.getSocietyId())
                .createdAt(Instant.now().toString())
                .build();

        PollEntity saved = communicationRepository.savePoll(entity);
        log.info("[COMMUNICATION] Poll created with ID: {}", saved.getId());
        return mapToPollResponse(saved, new HashMap<>(), 0);
    }

    @Override
    public PaginatedResponse<PollResponse> listPolls(int page, int size, String societyId) {
        List<PollEntity> polls = communicationRepository.findPolls(societyId, page, size);
        long total = communicationRepository.countPolls(societyId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<PollResponse> content = polls.stream()
                .map(poll -> {
                    List<PollVoteEntity> votes = communicationRepository.findVotesByPollId(poll.getId());
                    Map<String, Long> results = calculatePollResults(poll.getOptions(), votes);
                    return mapToPollResponse(poll, results, votes.size());
                })
                .collect(Collectors.toList());

        return PaginatedResponse.<PollResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public PollResponse getPollById(String id) {
        PollEntity entity = communicationRepository.findPollById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Poll not found"));

        List<PollVoteEntity> votes = communicationRepository.findVotesByPollId(id);
        Map<String, Long> results = calculatePollResults(entity.getOptions(), votes);
        return mapToPollResponse(entity, results, votes.size());
    }

    @Override
    public void castVote(String pollId, CastVoteRequest request) {
        String uid = getCurrentUid();
        PollEntity poll = communicationRepository.findPollById(pollId)
                .orElseThrow(() -> new ResourceNotFoundException("Poll not found"));

        if (parseInstant(poll.getEndDate()) != null && Instant.now().isAfter(parseInstant(poll.getEndDate()))) {
            throw new ValidationException("Poll has ended");
        }

        if (!poll.isAllowMultipleVotes() && request.getSelectedOptions().size() > 1) {
            throw new ValidationException("Multiple votes not allowed for this poll");
        }

        // For non-secret polls, check if user already voted
        if (!poll.isSecret()) {
            communicationRepository.findVoteByPollIdAndVoterUid(pollId, uid)
                    .ifPresent(v -> {
                        throw new ValidationException("You have already voted on this poll");
                    });
        }

        PollVoteEntity vote = PollVoteEntity.builder()
                .pollId(pollId)
                .voterUid(poll.isSecret() ? null : uid)
                .selectedOptions(request.getSelectedOptions())
                .votedAt(Instant.now().toString())
                .build();

        communicationRepository.savePollVote(vote);
        log.info("[COMMUNICATION] Vote cast on poll: {}", pollId);
    }

    // --- Groups ---

    @Override
    public GroupResponse createGroup(CreateGroupRequest request) {
        String uid = getCurrentUid();
        log.info("[COMMUNICATION] Creating group: {}", request.getName());

        GroupEntity entity = GroupEntity.builder()
                .name(request.getName())
                .description(request.getDescription())
                .type(request.getType())
                .memberUids(request.getMemberUids())
                .createdBy(uid)
                .societyId(request.getSocietyId())
                .createdAt(Instant.now().toString())
                .build();

        GroupEntity saved = communicationRepository.saveGroup(entity);
        log.info("[COMMUNICATION] Group created with ID: {}", saved.getId());
        return mapToGroupResponse(saved);
    }

    @Override
    public PaginatedResponse<GroupResponse> listGroups(int page, int size, String societyId) {
        List<GroupEntity> groups = communicationRepository.findGroups(societyId, page, size);
        long total = communicationRepository.countGroups(societyId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<GroupResponse> content = groups.stream()
                .map(this::mapToGroupResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<GroupResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    // --- Messages ---

    @Override
    public MessageResponse sendMessage(String groupId, SendMessageRequest request) {
        String uid = getCurrentUid();
        communicationRepository.findGroupById(groupId)
                .orElseThrow(() -> new ResourceNotFoundException("Group not found"));

        MessageEntity entity = MessageEntity.builder()
                .groupId(groupId)
                .senderUid(uid)
                .content(request.getContent())
                .attachmentUrl(request.getAttachmentUrl())
                .sentAt(Instant.now().toString())
                .createdAt(Instant.now().toString())
                .build();

        MessageEntity saved = communicationRepository.saveMessage(entity);
        log.info("[COMMUNICATION] Message sent in group: {}", groupId);
        return mapToMessageResponse(saved);
    }

    @Override
    public PaginatedResponse<MessageResponse> listMessages(String groupId, int page, int size) {
        communicationRepository.findGroupById(groupId)
                .orElseThrow(() -> new ResourceNotFoundException("Group not found"));

        List<MessageEntity> messages = communicationRepository.findMessagesByGroupId(groupId, page, size);
        long total = communicationRepository.countMessagesByGroupId(groupId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<MessageResponse> content = messages.stream()
                .map(this::mapToMessageResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<MessageResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    // --- Documents ---

    @Override
    public DocumentResponse uploadDocument(UploadDocumentRequest request) {
        String uid = getCurrentUid();
        log.info("[COMMUNICATION] Uploading document: {}", request.getTitle());

        DocumentEntity entity = DocumentEntity.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .category(request.getCategory())
                .fileUrl(request.getFileUrl())
                .fileName(request.getFileName())
                .fileType(request.getFileType())
                .uploadedBy(uid)
                .societyId(request.getSocietyId())
                .createdAt(Instant.now().toString())
                .build();

        DocumentEntity saved = communicationRepository.saveDocument(entity);
        log.info("[COMMUNICATION] Document uploaded with ID: {}", saved.getId());
        return mapToDocumentResponse(saved);
    }

    @Override
    public PaginatedResponse<DocumentResponse> listDocuments(int page, int size, String societyId) {
        List<DocumentEntity> documents = communicationRepository.findDocuments(societyId, page, size);
        long total = communicationRepository.countDocuments(societyId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<DocumentResponse> content = documents.stream()
                .map(this::mapToDocumentResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<DocumentResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public DocumentResponse getDocumentById(String id) {
        DocumentEntity entity = communicationRepository.findDocumentById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Document not found"));
        return mapToDocumentResponse(entity);
    }

    // --- Helpers ---

    private Map<String, Long> calculatePollResults(List<String> options, List<PollVoteEntity> votes) {
        Map<String, Long> results = new HashMap<>();
        for (String option : options) {
            results.put(option, 0L);
        }
        for (PollVoteEntity vote : votes) {
            if (vote.getSelectedOptions() != null) {
                for (String selected : vote.getSelectedOptions()) {
                    results.merge(selected, 1L, Long::sum);
                }
            }
        }
        return results;
    }

    // --- Mappers ---

    private NoticeResponse mapToNoticeResponse(NoticeEntity entity) {
        return NoticeResponse.builder()
                .id(entity.getId())
                .title(entity.getTitle())
                .body(entity.getBody())
                .type(entity.getType())
                .attachments(entity.getAttachments())
                .postedBy(entity.getPostedBy())
                .postedAt(parseInstant(entity.getPostedAt()))
                .expiryDate(parseInstant(entity.getExpiryDate()))
                .societyId(entity.getSocietyId())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .build();
    }

    private PollResponse mapToPollResponse(PollEntity entity, Map<String, Long> results, long totalVotes) {
        return PollResponse.builder()
                .id(entity.getId())
                .question(entity.getQuestion())
                .options(entity.getOptions())
                .startDate(parseInstant(entity.getStartDate()))
                .endDate(parseInstant(entity.getEndDate()))
                .isSecret(entity.isSecret())
                .allowMultipleVotes(entity.isAllowMultipleVotes())
                .createdBy(entity.getCreatedBy())
                .societyId(entity.getSocietyId())
                .results(results)
                .totalVotes(totalVotes)
                .createdAt(parseInstant(entity.getCreatedAt()))
                .build();
    }

    private GroupResponse mapToGroupResponse(GroupEntity entity) {
        return GroupResponse.builder()
                .id(entity.getId())
                .name(entity.getName())
                .description(entity.getDescription())
                .type(entity.getType())
                .memberUids(entity.getMemberUids())
                .createdBy(entity.getCreatedBy())
                .societyId(entity.getSocietyId())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .build();
    }

    private MessageResponse mapToMessageResponse(MessageEntity entity) {
        return MessageResponse.builder()
                .id(entity.getId())
                .groupId(entity.getGroupId())
                .senderUid(entity.getSenderUid())
                .content(entity.getContent())
                .attachmentUrl(entity.getAttachmentUrl())
                .sentAt(parseInstant(entity.getSentAt()))
                .createdAt(parseInstant(entity.getCreatedAt()))
                .build();
    }

    private DocumentResponse mapToDocumentResponse(DocumentEntity entity) {
        return DocumentResponse.builder()
                .id(entity.getId())
                .title(entity.getTitle())
                .description(entity.getDescription())
                .category(entity.getCategory())
                .fileUrl(entity.getFileUrl())
                .fileName(entity.getFileName())
                .fileType(entity.getFileType())
                .uploadedBy(entity.getUploadedBy())
                .societyId(entity.getSocietyId())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .build();
    }

    private Instant parseInstant(Object v) {
        if (v == null) return null;
        if (v instanceof com.google.cloud.Timestamp t) return t.toDate().toInstant();
        try { return Instant.parse(v.toString()); } catch (Exception e) { return null; }
    }
}
