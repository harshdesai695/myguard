import 'package:myguard_frontend/core/network/dio_client.dart';
import 'package:myguard_frontend/core/network/paginated_response_model.dart';
import 'package:myguard_frontend/features/emergency/data/models/emergency_model.dart';

abstract class EmergencyRemoteDatasource { Future<PanicAlertModel> triggerPanic(Map<String, dynamic> data); Future<PaginatedResponseModel<PanicAlertModel>> getPanicAlerts({int page, int size, String? societyId}); Future<PanicAlertModel> resolvePanic(String id); Future<PaginatedResponseModel<EmergencyContactModel>> getContacts({int page, int size, String? societyId}); Future<EmergencyContactModel> createContact(Map<String, dynamic> data); Future<EmergencyContactModel> updateContact(String id, Map<String, dynamic> data); Future<void> deleteContact(String id); }

class EmergencyRemoteDatasourceImpl implements EmergencyRemoteDatasource {
  const EmergencyRemoteDatasourceImpl({required this.dioClient}); final DioClient dioClient;
  @override Future<PanicAlertModel> triggerPanic(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/emergency/panic', data: data); return PanicAlertModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<PaginatedResponseModel<PanicAlertModel>> getPanicAlerts({int page = 0, int size = 20, String? societyId}) async { final r = await dioClient.get<Map<String, dynamic>>('/emergency/panic', queryParameters: {'page': page, 'size': size, if (societyId != null) 'societyId': societyId}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => PanicAlertModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<PanicAlertModel> resolvePanic(String id) async { final r = await dioClient.patch<Map<String, dynamic>>('/emergency/panic/$id/resolve'); return PanicAlertModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<PaginatedResponseModel<EmergencyContactModel>> getContacts({int page = 0, int size = 20, String? societyId}) async { final r = await dioClient.get<Map<String, dynamic>>('/emergency/contacts', queryParameters: {'page': page, 'size': size, if (societyId != null) 'societyId': societyId}); return PaginatedResponseModel.fromJson(r.data!['data'] as Map<String, dynamic>, (j) => EmergencyContactModel.fromJson(j! as Map<String, dynamic>)); }
  @override Future<EmergencyContactModel> createContact(Map<String, dynamic> data) async { final r = await dioClient.post<Map<String, dynamic>>('/emergency/contacts', data: data); return EmergencyContactModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<EmergencyContactModel> updateContact(String id, Map<String, dynamic> data) async { final r = await dioClient.put<Map<String, dynamic>>('/emergency/contacts/$id', data: data); return EmergencyContactModel.fromJson(r.data!['data'] as Map<String, dynamic>); }
  @override Future<void> deleteContact(String id) async => dioClient.delete<void>('/emergency/contacts/$id');
}
