import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/visitor/domain/entities/visitor_entity.dart';
import 'package:myguard_frontend/features/visitor/domain/usecases/approve_visitor_usecase.dart';
import 'package:myguard_frontend/features/visitor/domain/usecases/get_visitors_usecase.dart';
import 'package:myguard_frontend/features/visitor/domain/usecases/pre_approve_visitor_usecase.dart';
import 'package:myguard_frontend/features/visitor/domain/usecases/visitor_usecases.dart';
import 'package:myguard_frontend/features/visitor/presentation/bloc/visitor_bloc_models.dart';

class VisitorBloc extends Bloc<VisitorEvent, VisitorState> {
  VisitorBloc({
    required GetVisitorsUseCase getVisitorsUseCase,
    required PreApproveVisitorUseCase preApproveVisitorUseCase,
    required ApproveVisitorUseCase approveVisitorUseCase,
    required RejectVisitorUseCase rejectVisitorUseCase,
    required LogVisitorEntryUseCase logVisitorEntryUseCase,
    required MarkVisitorExitUseCase markVisitorExitUseCase,
  })  : _getVisitorsUseCase = getVisitorsUseCase,
        _preApproveVisitorUseCase = preApproveVisitorUseCase,
        _approveVisitorUseCase = approveVisitorUseCase,
        _rejectVisitorUseCase = rejectVisitorUseCase,
        _logVisitorEntryUseCase = logVisitorEntryUseCase,
        _markVisitorExitUseCase = markVisitorExitUseCase,
        super(const VisitorInitial()) {
    on<VisitorsFetched>(_onFetched);
    on<VisitorPreApproved>(_onPreApproved);
    on<VisitorApproved>(_onApproved);
    on<VisitorRejected>(_onRejected);
    on<VisitorEntryLogged>(_onEntryLogged);
    on<VisitorExitMarked>(_onExitMarked);
  }

  final GetVisitorsUseCase _getVisitorsUseCase;
  final PreApproveVisitorUseCase _preApproveVisitorUseCase;
  final ApproveVisitorUseCase _approveVisitorUseCase;
  final RejectVisitorUseCase _rejectVisitorUseCase;
  final LogVisitorEntryUseCase _logVisitorEntryUseCase;
  final MarkVisitorExitUseCase _markVisitorExitUseCase;

  final List<VisitorEntity> _visitors = [];

  Future<void> _onFetched(VisitorsFetched event, Emitter<VisitorState> emit) async {
    if (event.page == 0) {
      _visitors.clear();
      emit(const VisitorLoading());
    }

    final result = await _getVisitorsUseCase(
      page: event.page,
      status: event.status,
    );

    result.fold(
      (failure) => emit(VisitorError(failure.message)),
      (paginated) {
        _visitors.addAll(paginated.content);
        emit(VisitorsLoaded(
          visitors: List.unmodifiable(_visitors),
          hasMore: paginated.hasNext,
          currentPage: paginated.page,
        ));
      },
    );
  }

  Future<void> _onPreApproved(VisitorPreApproved event, Emitter<VisitorState> emit) async {
    emit(const VisitorLoading());

    final result = await _preApproveVisitorUseCase(
      visitorName: event.visitorName,
      visitorPhone: event.visitorPhone,
      purpose: event.purpose,
    );

    result.fold(
      (failure) => emit(VisitorError(failure.message)),
      (_) => emit(const VisitorActionSuccess('Visitor pre-approved successfully')),
    );
  }

  Future<void> _onApproved(VisitorApproved event, Emitter<VisitorState> emit) async {
    final result = await _approveVisitorUseCase(event.id);

    result.fold(
      (failure) => emit(VisitorError(failure.message)),
      (_) => emit(const VisitorActionSuccess('Visitor approved')),
    );
  }

  Future<void> _onRejected(VisitorRejected event, Emitter<VisitorState> emit) async {
    final result = await _rejectVisitorUseCase(event.id);
    result.fold(
      (failure) => emit(VisitorError(failure.message)),
      (_) => emit(const VisitorActionSuccess('Visitor rejected')),
    );
  }

  Future<void> _onEntryLogged(VisitorEntryLogged event, Emitter<VisitorState> emit) async {
    emit(const VisitorLoading());
    final result = await _logVisitorEntryUseCase(
      visitorName: event.visitorName,
      visitorPhone: event.visitorPhone,
      purpose: event.purpose,
      flatId: event.flatId,
      photoUrl: event.photoUrl,
      vehicleNumber: event.vehicleNumber,
      preApprovalId: event.preApprovalId,
    );
    result.fold(
      (failure) => emit(VisitorError(failure.message)),
      (_) => emit(const VisitorActionSuccess('Visitor entry logged')),
    );
  }

  Future<void> _onExitMarked(VisitorExitMarked event, Emitter<VisitorState> emit) async {
    final result = await _markVisitorExitUseCase(event.id);
    result.fold(
      (failure) => emit(VisitorError(failure.message)),
      (_) => emit(const VisitorActionSuccess('Visitor exit marked')),
    );
  }
}
