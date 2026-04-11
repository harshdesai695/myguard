import 'package:equatable/equatable.dart'; import 'package:flutter_bloc/flutter_bloc.dart'; import 'package:myguard_frontend/features/material/domain/entities/material_entity.dart'; import 'package:myguard_frontend/features/material/domain/usecases/get_gatepasses_usecase.dart';

sealed class MaterialState extends Equatable { const MaterialState(); @override List<Object?> get props => []; }
class MaterialInitial extends MaterialState { const MaterialInitial(); }
class MaterialLoading extends MaterialState { const MaterialLoading(); }
class GatepassesLoaded extends MaterialState { const GatepassesLoaded({required this.gatepasses, required this.hasMore}); final List<GatepassEntity> gatepasses; final bool hasMore; @override List<Object> get props => [gatepasses, hasMore]; }
class MaterialError extends MaterialState { const MaterialError(this.message); final String message; @override List<Object> get props => [message]; }

class MaterialCubit extends Cubit<MaterialState> {
  MaterialCubit({required GetGatepassesUseCase getGatepassesUseCase}) : _getGatepassesUseCase = getGatepassesUseCase, super(const MaterialInitial());
  final GetGatepassesUseCase _getGatepassesUseCase; final List<GatepassEntity> _items = [];
  Future<void> loadGatepasses({int page = 0}) async { if (page == 0) { _items.clear(); emit(const MaterialLoading()); } final r = await _getGatepassesUseCase(page: page); r.fold((f) => emit(MaterialError(f.message)), (p) { _items.addAll(p.content); emit(GatepassesLoaded(gatepasses: List.unmodifiable(_items), hasMore: p.hasNext)); }); }
}
