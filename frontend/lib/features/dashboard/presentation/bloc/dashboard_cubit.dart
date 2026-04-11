import 'package:equatable/equatable.dart'; import 'package:flutter_bloc/flutter_bloc.dart'; import 'package:myguard_frontend/features/dashboard/domain/entities/dashboard_entity.dart'; import 'package:myguard_frontend/features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart';

sealed class DashboardState extends Equatable { const DashboardState(); @override List<Object?> get props => []; }
class DashboardInitial extends DashboardState { const DashboardInitial(); }
class DashboardLoading extends DashboardState { const DashboardLoading(); }
class DashboardLoaded extends DashboardState { const DashboardLoaded(this.summary); final DashboardSummaryEntity summary; @override List<Object> get props => [summary]; }
class DashboardError extends DashboardState { const DashboardError(this.message); final String message; @override List<Object> get props => [message]; }

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required GetDashboardSummaryUseCase getDashboardSummaryUseCase}) : _getDashboardSummaryUseCase = getDashboardSummaryUseCase, super(const DashboardInitial());
  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;
  Future<void> loadSummary(String societyId) async { emit(const DashboardLoading()); final r = await _getDashboardSummaryUseCase(societyId); r.fold((f) => emit(DashboardError(f.message)), (s) => emit(DashboardLoaded(s))); }
}
