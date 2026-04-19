import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/pet/domain/entities/pet_entity.dart';
import 'package:myguard_frontend/features/pet/domain/usecases/get_pets_usecase.dart';
import 'package:myguard_frontend/features/pet/domain/usecases/pet_usecases.dart';

sealed class PetState extends Equatable { const PetState(); @override List<Object?> get props => []; }
class PetInitial extends PetState { const PetInitial(); }
class PetLoading extends PetState { const PetLoading(); }
class PetsLoaded extends PetState { const PetsLoaded({required this.pets, required this.hasMore}); final List<PetEntity> pets; final bool hasMore; @override List<Object> get props => [pets, hasMore]; }
class PetActionSuccess extends PetState { const PetActionSuccess(this.message); final String message; @override List<Object> get props => [message]; }
class VaccinationsLoaded extends PetState { const VaccinationsLoaded(this.vaccinations); final List<VaccinationEntity> vaccinations; @override List<Object> get props => [vaccinations]; }
class PetError extends PetState { const PetError(this.message); final String message; @override List<Object> get props => [message]; }

class PetCubit extends Cubit<PetState> {
  PetCubit({
    required GetPetsUseCase getPetsUseCase,
    required RegisterPetUseCase registerPetUseCase,
    required UpdatePetUseCase updatePetUseCase,
    required DeletePetUseCase deletePetUseCase,
    required AddVaccinationUseCase addVaccinationUseCase,
    required GetVaccinationsUseCase getVaccinationsUseCase,
  }) : _getPetsUseCase = getPetsUseCase,
       _registerPetUseCase = registerPetUseCase,
       _updatePetUseCase = updatePetUseCase,
       _deletePetUseCase = deletePetUseCase,
       _addVaccinationUseCase = addVaccinationUseCase,
       _getVaccinationsUseCase = getVaccinationsUseCase,
       super(const PetInitial());
  final GetPetsUseCase _getPetsUseCase;
  final RegisterPetUseCase _registerPetUseCase;
  final UpdatePetUseCase _updatePetUseCase;
  final DeletePetUseCase _deletePetUseCase;
  final AddVaccinationUseCase _addVaccinationUseCase;
  final GetVaccinationsUseCase _getVaccinationsUseCase;
  final List<PetEntity> _items = [];

  Future<void> loadPets({int page = 0, String? societyId}) async {
    if (page == 0) { _items.clear(); emit(const PetLoading()); }
    final r = await _getPetsUseCase(page: page, societyId: societyId);
    r.fold((f) => emit(PetError(f.message)), (p) { _items.addAll(p.content); emit(PetsLoaded(pets: List.unmodifiable(_items), hasMore: p.hasNext)); });
  }

  Future<void> registerPet(Map<String, dynamic> data) async {
    emit(const PetLoading());
    final r = await _registerPetUseCase(data);
    r.fold((f) => emit(PetError(f.message)), (_) => emit(const PetActionSuccess('Pet registered')));
  }

  Future<void> updatePet(String id, Map<String, dynamic> data) async {
    emit(const PetLoading());
    final r = await _updatePetUseCase(id, data);
    r.fold((f) => emit(PetError(f.message)), (_) => emit(const PetActionSuccess('Pet updated')));
  }

  Future<void> deletePet(String id) async {
    final r = await _deletePetUseCase(id);
    r.fold((f) => emit(PetError(f.message)), (_) => emit(const PetActionSuccess('Pet removed')));
  }

  Future<void> addVaccination(String petId, Map<String, dynamic> data) async {
    emit(const PetLoading());
    final r = await _addVaccinationUseCase(petId, data);
    r.fold((f) => emit(PetError(f.message)), (_) => emit(const PetActionSuccess('Vaccination added')));
  }

  Future<void> loadVaccinations(String petId) async {
    emit(const PetLoading());
    final r = await _getVaccinationsUseCase(petId);
    r.fold((f) => emit(PetError(f.message)), (v) => emit(VaccinationsLoaded(v)));
  }
}
