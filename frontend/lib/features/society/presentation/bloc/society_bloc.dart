import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/society/domain/entities/society_entity.dart';
import 'package:myguard_frontend/features/society/domain/usecases/get_societies_usecase.dart';

sealed class SocietyEvent extends Equatable { const SocietyEvent(); @override List<Object?> get props => []; }
class SocietiesFetched extends SocietyEvent { const SocietiesFetched({this.page = 0}); final int page; @override List<Object> get props => [page]; }

sealed class SocietyState extends Equatable { const SocietyState(); @override List<Object?> get props => []; }
class SocietyInitial extends SocietyState { const SocietyInitial(); }
class SocietyLoading extends SocietyState { const SocietyLoading(); }
class SocietiesLoaded extends SocietyState { const SocietiesLoaded({required this.societies, required this.hasMore}); final List<SocietyEntity> societies; final bool hasMore; @override List<Object> get props => [societies, hasMore]; }
class SocietyError extends SocietyState { const SocietyError(this.message); final String message; @override List<Object> get props => [message]; }

class SocietyBloc extends Bloc<SocietyEvent, SocietyState> {
  SocietyBloc({required GetSocietiesUseCase getSocietiesUseCase}) : _getSocietiesUseCase = getSocietiesUseCase, super(const SocietyInitial()) { on<SocietiesFetched>(_onFetched); }
  final GetSocietiesUseCase _getSocietiesUseCase; final List<SocietyEntity> _items = [];
  Future<void> _onFetched(SocietiesFetched e, Emitter<SocietyState> emit) async { if (e.page == 0) { _items.clear(); emit(const SocietyLoading()); } final r = await _getSocietiesUseCase(page: e.page); r.fold((f) => emit(SocietyError(f.message)), (p) { _items.addAll(p.content); emit(SocietiesLoaded(societies: List.unmodifiable(_items), hasMore: p.hasNext)); }); }
}
