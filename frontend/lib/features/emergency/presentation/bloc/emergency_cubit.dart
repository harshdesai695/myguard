import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myguard_frontend/features/emergency/domain/entities/emergency_entity.dart';
import 'package:myguard_frontend/features/emergency/domain/usecases/get_emergency_contacts_usecase.dart';
import 'package:myguard_frontend/features/emergency/domain/usecases/trigger_panic_usecase.dart';
import 'package:myguard_frontend/features/emergency/domain/usecases/emergency_usecases.dart';

sealed class EmergencyState extends Equatable { const EmergencyState(); @override List<Object?> get props => []; }
class EmergencyInitial extends EmergencyState { const EmergencyInitial(); }
class EmergencyLoading extends EmergencyState { const EmergencyLoading(); }
class EmergencyContactsLoaded extends EmergencyState { const EmergencyContactsLoaded(this.contacts); final List<EmergencyContactEntity> contacts; @override List<Object> get props => [contacts]; }
class PanicAlertsLoaded extends EmergencyState { const PanicAlertsLoaded(this.alerts); final List<PanicAlertEntity> alerts; @override List<Object> get props => [alerts]; }
class ChildAlertsLoaded extends EmergencyState { const ChildAlertsLoaded(this.alerts); final List<ChildAlertEntity> alerts; @override List<Object> get props => [alerts]; }
class PanicTriggered extends EmergencyState { const PanicTriggered(); }
class EmergencyActionSuccess extends EmergencyState { const EmergencyActionSuccess(this.message); final String message; @override List<Object> get props => [message]; }
class EmergencyError extends EmergencyState { const EmergencyError(this.message); final String message; @override List<Object> get props => [message]; }

class EmergencyCubit extends Cubit<EmergencyState> {
  EmergencyCubit({
    required TriggerPanicUseCase triggerPanicUseCase,
    required GetEmergencyContactsUseCase getEmergencyContactsUseCase,
    required GetPanicAlertsUseCase getPanicAlertsUseCase,
    required ResolvePanicUseCase resolvePanicUseCase,
    required CreateEmergencyContactUseCase createEmergencyContactUseCase,
    required UpdateEmergencyContactUseCase updateEmergencyContactUseCase,
    required DeleteEmergencyContactUseCase deleteEmergencyContactUseCase,
  }) : _triggerPanicUseCase = triggerPanicUseCase,
       _getEmergencyContactsUseCase = getEmergencyContactsUseCase,
       _getPanicAlertsUseCase = getPanicAlertsUseCase,
       _resolvePanicUseCase = resolvePanicUseCase,
       _createEmergencyContactUseCase = createEmergencyContactUseCase,
       _updateEmergencyContactUseCase = updateEmergencyContactUseCase,
       _deleteEmergencyContactUseCase = deleteEmergencyContactUseCase,
       super(const EmergencyInitial());
  final TriggerPanicUseCase _triggerPanicUseCase;
  final GetEmergencyContactsUseCase _getEmergencyContactsUseCase;
  final GetPanicAlertsUseCase _getPanicAlertsUseCase;
  final ResolvePanicUseCase _resolvePanicUseCase;
  final CreateEmergencyContactUseCase _createEmergencyContactUseCase;
  final UpdateEmergencyContactUseCase _updateEmergencyContactUseCase;
  final DeleteEmergencyContactUseCase _deleteEmergencyContactUseCase;

  Future<void> triggerPanic(Map<String, dynamic> data) async { emit(const EmergencyLoading()); final r = await _triggerPanicUseCase(data); r.fold((f) => emit(EmergencyError(f.message)), (_) => emit(const PanicTriggered())); }

  Future<void> loadContacts({String? societyId}) async { emit(const EmergencyLoading()); final r = await _getEmergencyContactsUseCase(societyId: societyId); r.fold((f) => emit(EmergencyError(f.message)), (p) => emit(EmergencyContactsLoaded(p.content))); }

  Future<void> loadPanicAlerts({String? societyId}) async { emit(const EmergencyLoading()); final r = await _getPanicAlertsUseCase(societyId: societyId); r.fold((f) => emit(EmergencyError(f.message)), (p) => emit(PanicAlertsLoaded(p.content))); }

  Future<void> resolvePanic(String id) async { final r = await _resolvePanicUseCase(id); r.fold((f) => emit(EmergencyError(f.message)), (_) => emit(const EmergencyActionSuccess('Panic alert resolved'))); }

  Future<void> createContact(Map<String, dynamic> data) async { emit(const EmergencyLoading()); final r = await _createEmergencyContactUseCase(data); r.fold((f) => emit(EmergencyError(f.message)), (_) => emit(const EmergencyActionSuccess('Contact added'))); }

  Future<void> updateContact(String id, Map<String, dynamic> data) async { emit(const EmergencyLoading()); final r = await _updateEmergencyContactUseCase(id, data); r.fold((f) => emit(EmergencyError(f.message)), (_) => emit(const EmergencyActionSuccess('Contact updated'))); }

  Future<void> deleteContact(String id) async { final r = await _deleteEmergencyContactUseCase(id); r.fold((f) => emit(EmergencyError(f.message)), (_) => emit(const EmergencyActionSuccess('Contact deleted'))); }

  Future<void> loadChildAlerts() async { emit(const EmergencyLoading()); emit(const ChildAlertsLoaded([])); }
}
