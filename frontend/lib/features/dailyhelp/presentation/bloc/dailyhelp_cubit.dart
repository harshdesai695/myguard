import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/entities/dailyhelp_entity.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/usecases/get_daily_helps_usecase.dart';
import 'package:myguard_frontend/features/dailyhelp/domain/usecases/mark_attendance_usecase.dart';

// States
sealed class DailyHelpState extends Equatable {
  const DailyHelpState();
  @override
  List<Object?> get props => [];
}

class DailyHelpInitial extends DailyHelpState { const DailyHelpInitial(); }
class DailyHelpLoading extends DailyHelpState { const DailyHelpLoading(); }

class DailyHelpsLoaded extends DailyHelpState {
  const DailyHelpsLoaded({required this.dailyHelps, required this.hasMore, required this.page});
  final List<DailyHelpEntity> dailyHelps;
  final bool hasMore;
  final int page;
  @override
  List<Object> get props => [dailyHelps, hasMore, page];
}

class DailyHelpActionSuccess extends DailyHelpState {
  const DailyHelpActionSuccess(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}

class DailyHelpError extends DailyHelpState {
  const DailyHelpError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}

class DailyHelpCubit extends Cubit<DailyHelpState> {
  DailyHelpCubit({
    required GetDailyHelpsUseCase getDailyHelpsUseCase,
    required MarkAttendanceUseCase markAttendanceUseCase,
  })  : _getDailyHelpsUseCase = getDailyHelpsUseCase,
        _markAttendanceUseCase = markAttendanceUseCase,
        super(const DailyHelpInitial());

  final GetDailyHelpsUseCase _getDailyHelpsUseCase;
  final MarkAttendanceUseCase _markAttendanceUseCase;
  final List<DailyHelpEntity> _items = [];

  Future<void> loadDailyHelps({int page = 0}) async {
    if (page == 0) { _items.clear(); emit(const DailyHelpLoading()); }
    final result = await _getDailyHelpsUseCase(page: page);
    result.fold(
      (f) => emit(DailyHelpError(f.message)),
      (p) { _items.addAll(p.content); emit(DailyHelpsLoaded(dailyHelps: List.unmodifiable(_items), hasMore: p.hasNext, page: p.page)); },
    );
  }

  Future<void> markAttendance(String id) async {
    final result = await _markAttendanceUseCase(id);
    result.fold(
      (f) => emit(DailyHelpError(f.message)),
      (_) => emit(const DailyHelpActionSuccess('Attendance marked')),
    );
  }
}
