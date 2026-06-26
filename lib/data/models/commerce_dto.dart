import '../../domain/entities/commerce_entity.dart';

class CommerceDto {
  final String id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final String address;
  final String note;
  final bool isPublished;

  const CommerceDto({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.note,
    required this.isPublished,
  });

  factory CommerceDto.fromMap(Map<String, dynamic> map) {
    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    bool toBool(dynamic v) {
      if (v is bool) return v;
      if (v is int) return v == 1;
      return v?.toString() == 'true';
    }

    return CommerceDto(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      latitude: toDouble(map['latitude']),
      longitude: toDouble(map['longitude']),
      address: map['address']?.toString() ?? '',
      note: map['note']?.toString() ?? '',
      isPublished: toBool(map['is_published']),
    );
  }

  CommerceEntity toEntity() => CommerceEntity(
    id: id,
    name: name,
    category: category,
    latitude: latitude,
    longitude: longitude,
    address: address,
    note: note,
    isPublished: isPublished,
  );
}
