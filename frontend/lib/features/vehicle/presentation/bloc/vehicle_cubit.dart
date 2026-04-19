import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/vehicle/domain/entities/vehicle_entity.dart';
import 'package:myguard_frontend/features/vehicle/domain/usecases/get_vehicles_usecase.dart';
import 'package:myguard_frontend/features/vehicle/domain/usecases/vehicle_usecases.dart';

sealed class VehicleState extends Equatable { const VehicleState(); @override List<Object?> get props => []; }
class VehicleInitial extends VehicleState { const VehicleInitial(); }
class VehicleLoading extends VehicleState { const VehicleLoading(); }
class VehiclesLoaded extends VehicleState { const VehiclesLoaded({required this.vehicles, required this.hasMore}); final List<VehicleEntity> vehicles; final bool hasMore; @override List<Object> get props => [vehicles, hasMore]; }
class VehicleActionSuccess extends VehicleState { const VehicleActionSuccess(this.message); final String message; @override List<Object> get props => [message]; }
class VehicleLookupResult extends VehicleState { const VehicleLookupResult(this.vehicle); final VehicleEntity vehicle; @override List<Object> get props => [vehicle]; }
class VehicleError extends VehicleState { const VehicleError(this.message); final String message; @override List<Object> get props => [message]; }

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit({
    required GetVehiclesUseCase getVehiclesUseCase,
    required RegisterVehicleUseCase registerVehicleUseCase,
    required UpdateVehicleUseCase updateVehicleUseCase,
    required DeleteVehicleUseCase deleteVehicleUseCase,
    required LookupVehicleUseCase lookupVehicleUseCase,
  }) : _getVehiclesUseCase = getVehiclesUseCase,
       _registerVehicleUseCase = registerVehicleUseCase,
       _updateVehicleUseCase = updateVehicleUseCase,
       _deleteVehicleUseCase = deleteVehicleUseCase,
       _lookupVehicleUseCase = lookupVehicleUseCase,
       super(const VehicleInitial());
  final GetVehiclesUseCase _getVehiclesUseCase;
  final RegisterVehicleUseCase _registerVehicleUseCase;
  final UpdateVehicleUseCase _updateVehicleUseCase;
  final DeleteVehicleUseCase _deleteVehicleUseCase;
  final LookupVehicleUseCase _lookupVehicleUseCase;
  final List<VehicleEntity> _items = [];

  Future<void> loadVehicles({int page = 0}) async {
    if (page == 0) { _items.clear(); emit(const VehicleLoading()); }
    final r = await _getVehiclesUseCase(page: page);
    r.fold((f) => emit(VehicleError(f.message)), (p) { _items.addAll(p.content); emit(VehiclesLoaded(vehicles: List.unmodifiable(_items), hasMore: p.hasNext)); });
  }

  Future<void> registerVehicle(Map<String, dynamic> data) async {
    emit(const VehicleLoading());
    final r = await _registerVehicleUseCase(data);
    r.fold((f) => emit(VehicleError(f.message)), (_) => emit(const VehicleActionSuccess('Vehicle registered')));
  }

  Future<void> updateVehicle(String id, Map<String, dynamic> data) async {
    emit(const VehicleLoading());
    final r = await _updateVehicleUseCase(id, data);
    r.fold((f) => emit(VehicleError(f.message)), (_) => emit(const VehicleActionSuccess('Vehicle updated')));
  }

  Future<void> deleteVehicle(String id) async {
    final r = await _deleteVehicleUseCase(id);
    r.fold((f) => emit(VehicleError(f.message)), (_) => emit(const VehicleActionSuccess('Vehicle removed')));
  }

  Future<void> lookupByPlate(String plateNumber) async {
    emit(const VehicleLoading());
    final r = await _lookupVehicleUseCase(plateNumber);
    r.fold((f) => emit(VehicleError(f.message)), (v) => emit(VehicleLookupResult(v)));
  }
}
