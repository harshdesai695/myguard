import 'package:equatable/equatable.dart'; import 'package:flutter_bloc/flutter_bloc.dart'; import 'package:myguard_frontend/features/pet/domain/entities/pet_entity.dart'; import 'package:myguard_frontend/features/pet/domain/usecases/get_pets_usecase.dart';

sealed class PetState extends Equatable { const PetState(); @override List<Object?> get props => []; }
class PetInitial extends PetState { const PetInitial(); }
class PetLoading extends PetState { const PetLoading(); }
class PetsLoaded extends PetState { const PetsLoaded({required this.pets, required this.hasMore}); final List<PetEntity> pets; final bool hasMore; @override List<Object> get props => [pets, hasMore]; }
class PetError extends PetState { const PetError(this.message); final String message; @override List<Object> get props => [message]; }

class PetCubit extends Cubit<PetState> {
  PetCubit({required GetPetsUseCase getPetsUseCase}) : _getPetsUseCase = getPetsUseCase, super(const PetInitial());
  final GetPetsUseCase _getPetsUseCase; final List<PetEntity> _items = [];
  Future<void> loadPets({int page = 0, String? societyId}) async { if (page == 0) { _items.clear(); emit(const PetLoading()); } final r = await _getPetsUseCase(page: page, societyId: societyId); r.fold((f) => emit(PetError(f.message)), (p) { _items.addAll(p.content); emit(PetsLoaded(pets: List.unmodifiable(_items), hasMore: p.hasNext)); }); }
}
