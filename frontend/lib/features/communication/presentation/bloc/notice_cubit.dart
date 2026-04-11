import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/communication/domain/entities/communication_entity.dart';
import 'package:myguard_frontend/features/communication/domain/usecases/get_notices_usecase.dart';

sealed class NoticeState extends Equatable { const NoticeState(); @override List<Object?> get props => []; }
class NoticeInitial extends NoticeState { const NoticeInitial(); }
class NoticeLoading extends NoticeState { const NoticeLoading(); }
class NoticesLoaded extends NoticeState { const NoticesLoaded({required this.notices, required this.hasMore, required this.page}); final List<NoticeEntity> notices; final bool hasMore; final int page; @override List<Object> get props => [notices, hasMore, page]; }
class NoticeError extends NoticeState { const NoticeError(this.message); final String message; @override List<Object> get props => [message]; }

class NoticeCubit extends Cubit<NoticeState> {
  NoticeCubit({required GetNoticesUseCase getNoticesUseCase}) : _getNoticesUseCase = getNoticesUseCase, super(const NoticeInitial());
  final GetNoticesUseCase _getNoticesUseCase;
  final List<NoticeEntity> _items = [];

  Future<void> loadNotices({int page = 0, String? societyId}) async {
    if (page == 0) { _items.clear(); emit(const NoticeLoading()); }
    final result = await _getNoticesUseCase(page: page, societyId: societyId);
    result.fold((f) => emit(NoticeError(f.message)), (p) { _items.addAll(p.content); emit(NoticesLoaded(notices: List.unmodifiable(_items), hasMore: p.hasNext, page: p.page)); });
  }
}
