import 'package:myguard_frontend/features/society/domain/entities/society_entity.dart';

class SocietyModel extends SocietyEntity {
  const SocietyModel({required super.id, required super.name, required super.address, super.city, super.state, super.pincode, super.totalBlocks, super.totalFlats, super.logoUrl, super.status, super.createdAt, super.updatedAt});
  factory SocietyModel.fromJson(Map<String, dynamic> j) => SocietyModel(id: j['id'] as String, name: j['name'] as String, address: j['address'] as String, city: j['city'] as String?, state: j['state'] as String?, pincode: j['pincode'] as String?, totalBlocks: j['totalBlocks'] as int?, totalFlats: j['totalFlats'] as int?, logoUrl: j['logoUrl'] as String?, status: j['status'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null, updatedAt: j['updatedAt'] != null ? DateTime.parse(j['updatedAt'] as String) : null);
}

class FlatModel extends FlatEntity {
  const FlatModel({required super.id, required super.societyId, required super.block, required super.flatNumber, super.flatType, super.area, super.primaryResidentUid, super.status, super.createdAt});
  factory FlatModel.fromJson(Map<String, dynamic> j) => FlatModel(id: j['id'] as String, societyId: j['societyId'] as String, block: j['block'] as String, flatNumber: j['flatNumber'] as String, flatType: j['flatType'] as String?, area: (j['area'] as num?)?.toDouble(), primaryResidentUid: j['primaryResidentUid'] as String?, status: j['status'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}
