import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/society/domain/entities/society_entity.dart';
import 'package:myguard_frontend/features/society/domain/repositories/society_repository.dart';
import 'package:myguard_frontend/features/society/domain/usecases/get_societies_usecase.dart';

// Events
sealed class SocietyEvent extends Equatable {
  const SocietyEvent();
  @override
  List<Object?> get props => [];
}

class SocietiesFetched extends SocietyEvent {
  const SocietiesFetched({this.page = 0});
  final int page;
  @override
  List<Object> get props => [page];
}

class SocietyDetailFetched extends SocietyEvent {
  const SocietyDetailFetched(this.societyId);
  final String societyId;
  @override
  List<Object> get props => [societyId];
}

class FlatsFetched extends SocietyEvent {
  const FlatsFetched({required this.societyId, this.page = 0});
  final String societyId;
  final int page;
  @override
  List<Object> get props => [societyId, page];
}

class SocietyUpdated extends SocietyEvent {
  const SocietyUpdated({required this.societyId, required this.data});
  final String societyId;
  final Map<String, dynamic> data;
  @override
  List<Object> get props => [societyId, data];
}

class FlatCreated extends SocietyEvent {
  const FlatCreated({required this.societyId, required this.data});
  final String societyId;
  final Map<String, dynamic> data;
  @override
  List<Object> get props => [societyId, data];
}

// States
sealed class SocietyState extends Equatable {
  const SocietyState();
  @override
  List<Object?> get props => [];
}

class SocietyInitial extends SocietyState {
  const SocietyInitial();
}

class SocietyLoading extends SocietyState {
  const SocietyLoading();
}

class SocietiesLoaded extends SocietyState {
  const SocietiesLoaded({required this.societies, required this.hasMore});
  final List<SocietyEntity> societies;
  final bool hasMore;
  @override
  List<Object> get props => [societies, hasMore];
}

class SocietyDetailLoaded extends SocietyState {
  const SocietyDetailLoaded(this.society);
  final SocietyEntity society;
  @override
  List<Object> get props => [society];
}

class FlatsLoaded extends SocietyState {
  const FlatsLoaded({required this.flats, required this.hasMore, required this.page});
  final List<FlatEntity> flats;
  final bool hasMore;
  final int page;
  @override
  List<Object> get props => [flats, hasMore, page];
}

class SocietyActionSuccess extends SocietyState {
  const SocietyActionSuccess(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}

class SocietyError extends SocietyState {
  const SocietyError(this.message);
  final String message;
  @override
  List<Object> get props => [message];
}

// BLoC
class SocietyBloc extends Bloc<SocietyEvent, SocietyState> {
  SocietyBloc({
    required GetSocietiesUseCase getSocietiesUseCase,
    required SocietyRepository repository,
  })  : _getSocietiesUseCase = getSocietiesUseCase,
        _repository = repository,
        super(const SocietyInitial()) {
    on<SocietiesFetched>(_onFetched);
    on<SocietyDetailFetched>(_onDetailFetched);
    on<FlatsFetched>(_onFlatsFetched);
    on<SocietyUpdated>(_onUpdated);
    on<FlatCreated>(_onFlatCreated);
  }

  final GetSocietiesUseCase _getSocietiesUseCase;
  final SocietyRepository _repository;
  final List<SocietyEntity> _societies = [];
  final List<FlatEntity> _flats = [];

  Future<void> _onFetched(SocietiesFetched e, Emitter<SocietyState> emit) async {
    if (e.page == 0) { _societies.clear(); emit(const SocietyLoading()); }
    final r = await _getSocietiesUseCase(page: e.page);
    if (r.isLeft()) { r.fold((f) => emit(SocietyError(f.message)), (_) {}); return; }
    final p = r.getOrElse(() => throw StateError('unreachable'));
    _societies.addAll(p.content);
    emit(SocietiesLoaded(societies: List.unmodifiable(_societies), hasMore: p.hasNext));
  }

  Future<void> _onDetailFetched(SocietyDetailFetched e, Emitter<SocietyState> emit) async {
    emit(const SocietyLoading());
    final r = await _repository.getSocietyById(e.societyId);
    if (r.isLeft()) { r.fold((f) => emit(SocietyError(f.message)), (_) {}); return; }
    emit(SocietyDetailLoaded(r.getOrElse(() => throw StateError('unreachable'))));
  }

  Future<void> _onFlatsFetched(FlatsFetched e, Emitter<SocietyState> emit) async {
    if (e.page == 0) { _flats.clear(); emit(const SocietyLoading()); }
    final r = await _repository.getFlats(e.societyId, page: e.page);
    if (r.isLeft()) { r.fold((f) => emit(SocietyError(f.message)), (_) {}); return; }
    final p = r.getOrElse(() => throw StateError('unreachable'));
    _flats.addAll(p.content);
    emit(FlatsLoaded(flats: List.unmodifiable(_flats), hasMore: p.hasNext, page: p.page));
  }

  Future<void> _onUpdated(SocietyUpdated e, Emitter<SocietyState> emit) async {
    emit(const SocietyLoading());
    final r = await _repository.updateSociety(e.societyId, e.data);
    if (r.isLeft()) { r.fold((f) => emit(SocietyError(f.message)), (_) {}); return; }
    emit(const SocietyActionSuccess('Society updated'));
  }

  Future<void> _onFlatCreated(FlatCreated e, Emitter<SocietyState> emit) async {
    emit(const SocietyLoading());
    final r = await _repository.createFlat(e.societyId, e.data);
    if (r.isLeft()) { r.fold((f) => emit(SocietyError(f.message)), (_) {}); return; }
    emit(const SocietyActionSuccess('Flat created'));
  }
}
