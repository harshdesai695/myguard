import 'package:equatable/equatable.dart';
import 'package:myguard_frontend/features/visitor/domain/entities/visitor_entity.dart';

sealed class VisitorEvent extends Equatable {
  const VisitorEvent();
  @override
  List<Object?> get props => [];
}

class VisitorsFetched extends VisitorEvent {
  const VisitorsFetched({this.page = 0, this.status});
  final int page;
  final String? status;
  @override
  List<Object?> get props => [page, status];
}

class VisitorPreApproved extends VisitorEvent {
  const VisitorPreApproved({
    required this.visitorName,
    required this.visitorPhone,
    required this.purpose,
  });
  final String visitorName;
  final String visitorPhone;
  final String purpose;
  @override
  List<Object> get props => [visitorName, visitorPhone, purpose];
}

class VisitorApproved extends VisitorEvent {
  const VisitorApproved(this.id);
  final String id;
  @override
  List<Object> get props => [id];
}

class VisitorRejected extends VisitorEvent {
  const VisitorRejected(this.id);
  final String id;
  @override
  List<Object> get props => [id];
}

class VisitorEntryLogged extends VisitorEvent {
  const VisitorEntryLogged({
    required this.visitorName,
    required this.visitorPhone,
    required this.purpose,
    required this.flatId,
    this.photoUrl,
    this.vehicleNumber,
    this.preApprovalId,
  });
  final String visitorName;
  final String visitorPhone;
  final String purpose;
  final String flatId;
  final String? photoUrl;
  final String? vehicleNumber;
  final String? preApprovalId;
  @override
  List<Object?> get props => [visitorName, visitorPhone, purpose, flatId, photoUrl, vehicleNumber, preApprovalId];
}

class VisitorExitMarked extends VisitorEvent {
  const VisitorExitMarked(this.id);
  final String id;
  @override
  List<Object> get props => [id];
}

sealed class VisitorState extends Equatable {
  const VisitorState();
  @override
  List<Object?> get props => [];
}

class VisitorInitial extends VisitorState {
  const VisitorInitial();
}

class VisitorLoading extends VisitorState {
  const VisitorLoading();
}

class VisitorsLoaded extends VisitorState {
  const VisitorsLoaded({
    required this.visitors,
    required this.hasMore,
    required this.currentPage,
  });
  final List<VisitorEntity> visitors;
  final bool hasMore;
  final int currentPage;
  @override
  List<Object> get props => [visitors, hasMore, currentPage];
}

class VisitorActionSuccess extends VisitorState {
  const VisitorActionSuccess(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}

class VisitorError extends VisitorState {
  const VisitorError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}
