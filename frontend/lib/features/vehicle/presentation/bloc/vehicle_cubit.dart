import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:myguard_frontend/features/vehicle/domain/usecases/get_vehicles_usecase.dart';

sealed class VehicleState extends Equatable { const VehicleState(); @override List<Object?> get props => []; }
class VehicleInitial extends VehicleState { const VehicleInitial(); }
class VehicleLoading extends VehicleState { const VehicleLoading(); }
class VehiclesLoaded extends VehicleState { const VehiclesLoaded({required this.vehicles, required this.hasMore}); final List<VehicleEntity> vehicles; final bool hasMore; @override List<Object> get props => [vehicles, hasMore]; }
class VehicleError extends VehicleState { const VehicleError(this.message); final String message; @override List<Object> get props => [message]; }

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit({required GetVehiclesUseCase getVehiclesUseCase}) : _getVehiclesUseCase = getVehiclesUseCase, super(const VehicleInitial());
  final GetVehiclesUseCase _getVehiclesUseCase;
  final List<VehicleEntity> _items = [];

  Future<void> loadVehicles({int page = 0}) async {
    if (page == 0) { _items.clear(); emit(const VehicleLoading()); }
    final r = await _getVehiclesUseCase(page: page);
    r.fold((f) => emit(VehicleError(f.message)), (p) { _items.addAll(p.content); emit(VehiclesLoaded(vehicles: List.unmodifiable(_items), hasMore: p.hasNext)); });
  }

  Future<void> lookupByPlate(String plateNumber) async {
    emit(const VehicleLoading());
    // Lookup will be handled via a dedicated use case when wired
    // For now triggers loading state - the datasource already supports it
    emit(const VehiclesLoaded(vehicles: [], hasMore: false));
  }
}
