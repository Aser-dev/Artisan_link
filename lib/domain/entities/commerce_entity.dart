class CommerceEntity {
  final String id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final String address;
  final String note;
  final bool isPublished;

  const CommerceEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.note,
    required this.isPublished,
  });
}

