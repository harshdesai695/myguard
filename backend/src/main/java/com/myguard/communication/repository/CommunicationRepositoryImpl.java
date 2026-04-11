package com.myguard.communication.repository;

import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.communication.constants.CommunicationConstants;
import com.myguard.communication.view.DocumentEntity;
import com.myguard.communication.view.GroupEntity;
import com.myguard.communication.view.MessageEntity;
import com.myguard.communication.view.NoticeEntity;
import com.myguard.communication.view.PollEntity;
import com.myguard.communication.view.PollVoteEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

@Slf4j
@Repository
@RequiredArgsConstructor
public class CommunicationRepositoryImpl implements CommunicationRepository {

    private final Firestore firestore;

    private CollectionReference getNoticesCollection() {
        return firestore.collection(CommunicationConstants.COLLECTION_NOTICES);
    }

    private CollectionReference getPollsCollection() {
        return firestore.collection(CommunicationConstants.COLLECTION_POLLS);
    }

    private CollectionReference getPollVotesCollection() {
        return firestore.collection(CommunicationConstants.COLLECTION_POLL_VOTES);
    }

    private CollectionReference getGroupsCollection() {
        return firestore.collection(CommunicationConstants.COLLECTION_GROUPS);
    }

    private CollectionReference getMessagesCollection() {
        return firestore.collection(CommunicationConstants.COLLECTION_MESSAGES);
    }

    private CollectionReference getDocumentsCollection() {
        return firestore.collection(CommunicationConstants.COLLECTION_DOCUMENTS);
    }

    // --- Notices ---

    @Override
    public NoticeEntity saveNotice(NoticeEntity notice) {
        try {
            DocumentReference docRef;
            if (notice.getId() != null) {
                docRef = getNoticesCollection().document(notice.getId());
            } else {
                docRef = getNoticesCollection().document();
                notice.setId(docRef.getId());
            }
            docRef.set(notice).get();
            log.debug("[COMMUNICATION] Notice saved with ID: {}", notice.getId());
            return notice;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save notice", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save notice", e);
        }
    }

    @Override
    public Optional<NoticeEntity> findNoticeById(String id) {
        try {
            DocumentSnapshot doc = getNoticesCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(NoticeEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find notice", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find notice", e);
        }
    }

    @Override
    public NoticeEntity updateNotice(NoticeEntity notice) {
        try {
            getNoticesCollection().document(notice.getId()).set(notice).get();
            log.debug("[COMMUNICATION] Notice updated with ID: {}", notice.getId());
            return notice;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update notice", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update notice", e);
        }
    }

    @Override
    public void deleteNotice(String id) {
        try {
            getNoticesCollection().document(id).delete().get();
            log.debug("[COMMUNICATION] Notice deleted with ID: {}", id);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to delete notice", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to delete notice", e);
        }
    }

    @Override
    public List<NoticeEntity> findNotices(String societyId, int page, int size) {
        try {
            Query query = getNoticesCollection()
                    .orderBy(CommunicationConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);
            if (societyId != null) {
                query = query.whereEqualTo(CommunicationConstants.FIELD_SOCIETY_ID, societyId);
            }
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(NoticeEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list notices", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list notices", e);
        }
    }

    @Override
    public long countNotices(String societyId) {
        try {
            Query query = getNoticesCollection();
            if (societyId != null) {
                query = query.whereEqualTo(CommunicationConstants.FIELD_SOCIETY_ID, societyId);
            }
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count notices", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count notices", e);
        }
    }

    // --- Polls ---

    @Override
    public PollEntity savePoll(PollEntity poll) {
        try {
            DocumentReference docRef;
            if (poll.getId() != null) {
                docRef = getPollsCollection().document(poll.getId());
            } else {
                docRef = getPollsCollection().document();
                poll.setId(docRef.getId());
            }
            docRef.set(poll).get();
            log.debug("[COMMUNICATION] Poll saved with ID: {}", poll.getId());
            return poll;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save poll", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save poll", e);
        }
    }

    @Override
    public Optional<PollEntity> findPollById(String id) {
        try {
            DocumentSnapshot doc = getPollsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(PollEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find poll", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find poll", e);
        }
    }

    @Override
    public List<PollEntity> findPolls(String societyId, int page, int size) {
        try {
            Query query = getPollsCollection()
                    .orderBy(CommunicationConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);
            if (societyId != null) {
                query = query.whereEqualTo(CommunicationConstants.FIELD_SOCIETY_ID, societyId);
            }
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(PollEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list polls", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list polls", e);
        }
    }

    @Override
    public long countPolls(String societyId) {
        try {
            Query query = getPollsCollection();
            if (societyId != null) {
                query = query.whereEqualTo(CommunicationConstants.FIELD_SOCIETY_ID, societyId);
            }
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count polls", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count polls", e);
        }
    }

    // --- Poll Votes ---

    @Override
    public PollVoteEntity savePollVote(PollVoteEntity vote) {
        try {
            DocumentReference docRef;
            if (vote.getId() != null) {
                docRef = getPollVotesCollection().document(vote.getId());
            } else {
                docRef = getPollVotesCollection().document();
                vote.setId(docRef.getId());
            }
            docRef.set(vote).get();
            log.debug("[COMMUNICATION] Poll vote saved with ID: {}", vote.getId());
            return vote;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save poll vote", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save poll vote", e);
        }
    }

    @Override
    public List<PollVoteEntity> findVotesByPollId(String pollId) {
        try {
            QuerySnapshot snapshot = getPollVotesCollection()
                    .whereEqualTo(CommunicationConstants.FIELD_POLL_ID, pollId)
                    .get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(PollVoteEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find poll votes", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find poll votes", e);
        }
    }

    @Override
    public Optional<PollVoteEntity> findVoteByPollIdAndVoterUid(String pollId, String voterUid) {
        try {
            QuerySnapshot snapshot = getPollVotesCollection()
                    .whereEqualTo(CommunicationConstants.FIELD_POLL_ID, pollId)
                    .whereEqualTo(CommunicationConstants.FIELD_VOTER_UID, voterUid)
                    .limit(1)
                    .get().get();
            return snapshot.isEmpty() ? Optional.empty()
                    : Optional.ofNullable(snapshot.getDocuments().get(0).toObject(PollVoteEntity.class));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find poll vote", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find poll vote", e);
        }
    }

    // --- Groups ---

    @Override
    public GroupEntity saveGroup(GroupEntity group) {
        try {
            DocumentReference docRef;
            if (group.getId() != null) {
                docRef = getGroupsCollection().document(group.getId());
            } else {
                docRef = getGroupsCollection().document();
                group.setId(docRef.getId());
            }
            docRef.set(group).get();
            log.debug("[COMMUNICATION] Group saved with ID: {}", group.getId());
            return group;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save group", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save group", e);
        }
    }

    @Override
    public Optional<GroupEntity> findGroupById(String id) {
        try {
            DocumentSnapshot doc = getGroupsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(GroupEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find group", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find group", e);
        }
    }

    @Override
    public List<GroupEntity> findGroups(String societyId, int page, int size) {
        try {
            Query query = getGroupsCollection()
                    .orderBy(CommunicationConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);
            if (societyId != null) {
                query = query.whereEqualTo(CommunicationConstants.FIELD_SOCIETY_ID, societyId);
            }
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(GroupEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list groups", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list groups", e);
        }
    }

    @Override
    public long countGroups(String societyId) {
        try {
            Query query = getGroupsCollection();
            if (societyId != null) {
                query = query.whereEqualTo(CommunicationConstants.FIELD_SOCIETY_ID, societyId);
            }
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count groups", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count groups", e);
        }
    }

    // --- Messages ---

    @Override
    public MessageEntity saveMessage(MessageEntity message) {
        try {
            DocumentReference docRef;
            if (message.getId() != null) {
                docRef = getMessagesCollection().document(message.getId());
            } else {
                docRef = getMessagesCollection().document();
                message.setId(docRef.getId());
            }
            docRef.set(message).get();
            log.debug("[COMMUNICATION] Message saved with ID: {}", message.getId());
            return message;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save message", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save message", e);
        }
    }

    @Override
    public List<MessageEntity> findMessagesByGroupId(String groupId, int page, int size) {
        try {
            Query query = getMessagesCollection()
                    .whereEqualTo(CommunicationConstants.FIELD_GROUP_ID, groupId)
                    .orderBy(CommunicationConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING)
                    .offset(page * size)
                    .limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(MessageEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list messages", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list messages", e);
        }
    }

    @Override
    public long countMessagesByGroupId(String groupId) {
        try {
            return getMessagesCollection()
                    .whereEqualTo(CommunicationConstants.FIELD_GROUP_ID, groupId)
                    .get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count messages", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count messages", e);
        }
    }

    // --- Documents ---

    @Override
    public DocumentEntity saveDocument(DocumentEntity document) {
        try {
            DocumentReference docRef;
            if (document.getId() != null) {
                docRef = getDocumentsCollection().document(document.getId());
            } else {
                docRef = getDocumentsCollection().document();
                document.setId(docRef.getId());
            }
            docRef.set(document).get();
            log.debug("[COMMUNICATION] Document saved with ID: {}", document.getId());
            return document;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save document", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save document", e);
        }
    }

    @Override
    public Optional<DocumentEntity> findDocumentById(String id) {
        try {
            DocumentSnapshot doc = getDocumentsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(DocumentEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find document", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find document", e);
        }
    }

    @Override
    public List<DocumentEntity> findDocuments(String societyId, int page, int size) {
        try {
            Query query = getDocumentsCollection()
                    .orderBy(CommunicationConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);
            if (societyId != null) {
                query = query.whereEqualTo(CommunicationConstants.FIELD_SOCIETY_ID, societyId);
            }
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(DocumentEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list documents", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list documents", e);
        }
    }

    @Override
    public long countDocuments(String societyId) {
        try {
            Query query = getDocumentsCollection();
            if (societyId != null) {
                query = query.whereEqualTo(CommunicationConstants.FIELD_SOCIETY_ID, societyId);
            }
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count documents", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count documents", e);
        }
    }
}
