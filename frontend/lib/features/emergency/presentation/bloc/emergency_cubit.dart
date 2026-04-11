import 'package:equatable/equatable.dart'; import 'package:flutter_bloc/flutter_bloc.dart'; import 'package:myguard_frontend/features/emergency/domain/entities/emergency_entity.dart'; import 'package:myguard_frontend/features/emergency/domain/usecases/get_emergency_contacts_usecase.dart'; import 'package:myguard_frontend/features/emergency/domain/usecases/trigger_panic_usecase.dart';

sealed class EmergencyState extends Equatable { const EmergencyState(); @override List<Object?> get props => []; }
class EmergencyInitial extends EmergencyState { const EmergencyInitial(); }
class EmergencyLoading extends EmergencyState { const EmergencyLoading(); }
class EmergencyContactsLoaded extends EmergencyState { const EmergencyContactsLoaded(this.contacts); final List<EmergencyContactEntity> contacts; @override List<Object> get props => [contacts]; }
class PanicTriggered extends EmergencyState { const PanicTriggered(); }
class EmergencyError extends EmergencyState { const EmergencyError(this.message); final String message; @override List<Object> get props => [message]; }

class EmergencyCubit extends Cubit<EmergencyState> {
  EmergencyCubit({required TriggerPanicUseCase triggerPanicUseCase, required GetEmergencyContactsUseCase getEmergencyContactsUseCase}) : _triggerPanicUseCase = triggerPanicUseCase, _getEmergencyContactsUseCase = getEmergencyContactsUseCase, super(const EmergencyInitial());
  final TriggerPanicUseCase _triggerPanicUseCase; final GetEmergencyContactsUseCase _getEmergencyContactsUseCase;

  Future<void> triggerPanic(Map<String, dynamic> data) async { emit(const EmergencyLoading()); final r = await _triggerPanicUseCase(data); r.fold((f) => emit(EmergencyError(f.message)), (_) => emit(const PanicTriggered())); }
  Future<void> loadContacts({String? societyId}) async { emit(const EmergencyLoading()); final r = await _getEmergencyContactsUseCase(societyId: societyId); r.fold((f) => emit(EmergencyError(f.message)), (p) => emit(EmergencyContactsLoaded(p.content))); }
}
