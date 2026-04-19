import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/material/domain/entities/material_entity.dart';
import 'package:myguard_frontend/features/material/domain/repositories/material_repository.dart';
import 'package:myguard_frontend/features/material/domain/usecases/get_gatepasses_usecase.dart';
import 'package:myguard_frontend/features/material/domain/usecases/material_usecases.dart';

sealed class MaterialState extends Equatable { const MaterialState(); @override List<Object?> get props => []; }
class MaterialInitial extends MaterialState { const MaterialInitial(); }
class MaterialLoading extends MaterialState { const MaterialLoading(); }
class GatepassesLoaded extends MaterialState { const GatepassesLoaded({required this.gatepasses, required this.hasMore}); final List<GatepassEntity> gatepasses; final bool hasMore; @override List<Object> get props => [gatepasses, hasMore]; }
class MaterialActionSuccess extends MaterialState { const MaterialActionSuccess(this.message); final String message; @override List<Object> get props => [message]; }
class MaterialError extends MaterialState { const MaterialError(this.message); final String message; @override List<Object> get props => [message]; }

class MaterialCubit extends Cubit<MaterialState> {
  MaterialCubit({
    required GetGatepassesUseCase getGatepassesUseCase,
    required CreateGatepassUseCase createGatepassUseCase,
    required ApproveGatepassUseCase approveGatepassUseCase,
    required VerifyGatepassUseCase verifyGatepassUseCase,
    required MaterialRepository repository,
  }) : _getGatepassesUseCase = getGatepassesUseCase,
       _createGatepassUseCase = createGatepassUseCase,
       _approveGatepassUseCase = approveGatepassUseCase,
       _verifyGatepassUseCase = verifyGatepassUseCase,
       _repository = repository,
       super(const MaterialInitial());
  final GetGatepassesUseCase _getGatepassesUseCase;
  final CreateGatepassUseCase _createGatepassUseCase;
  final ApproveGatepassUseCase _approveGatepassUseCase;
  final VerifyGatepassUseCase _verifyGatepassUseCase;
  final MaterialRepository _repository;
  final List<GatepassEntity> _items = [];

  Future<void> loadGatepasses({int page = 0}) async {
    if (page == 0) { _items.clear(); emit(const MaterialLoading()); }
    final r = await _getGatepassesUseCase(page: page);
    r.fold((f) => emit(MaterialError(f.message)), (p) { _items.addAll(p.content); emit(GatepassesLoaded(gatepasses: List.unmodifiable(_items), hasMore: p.hasNext)); });
  }

  Future<void> createGatepass(Map<String, dynamic> data) async {
    emit(const MaterialLoading());
    final r = await _createGatepassUseCase(data);
    r.fold((f) => emit(MaterialError(f.message)), (_) => emit(const MaterialActionSuccess('Gatepass created')));
  }

  Future<void> approveGatepass(String id) async {
    final r = await _approveGatepassUseCase(id);
    r.fold((f) => emit(MaterialError(f.message)), (_) => emit(const MaterialActionSuccess('Gatepass approved')));
  }

  Future<void> verifyGatepass(String id) async {
    final r = await _verifyGatepassUseCase(id);
    r.fold((f) => emit(MaterialError(f.message)), (_) => emit(const MaterialActionSuccess('Gatepass verified')));
  }

  Future<void> loadAdminGatepasses({int page = 0}) async {
    if (page == 0) { _items.clear(); emit(const MaterialLoading()); }
    final r = await _repository.getAdminGatepasses(page: page);
    r.fold((f) => emit(MaterialError(f.message)), (p) { _items.addAll(p.content); emit(GatepassesLoaded(gatepasses: List.unmodifiable(_items), hasMore: p.hasNext)); });
  }
}
