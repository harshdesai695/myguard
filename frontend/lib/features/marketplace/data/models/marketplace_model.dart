import 'package:myguard_frontend/features/marketplace/domain/entities/marketplace_entity.dart';

class ListingModel extends ListingEntity {
  const ListingModel({required super.id, required super.title, required super.description, required super.category, required super.price, required super.condition, required super.status, super.photos, super.postedBy, super.flatId, super.societyId, super.createdAt});
  factory ListingModel.fromJson(Map<String, dynamic> j) => ListingModel(id: j['id'] as String, title: j['title'] as String, description: j['description'] as String, category: j['category'] as String, price: (j['price'] as num).toDouble(), condition: j['condition'] as String, status: j['status'] as String, photos: (j['photos'] as List<dynamic>?)?.cast<String>(), postedBy: j['postedBy'] as String?, flatId: j['flatId'] as String?, societyId: j['societyId'] as String?, createdAt: j['createdAt'] != null ? DateTime.parse(j['createdAt'] as String) : null);
}
