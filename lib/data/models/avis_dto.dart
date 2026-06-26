import '../../domain/entities/avis_entity.dart';

class AvisDto {
  final String id;
  final String commentaire;
  final double noteIA;
  final DateTime date;

  const AvisDto({
    required this.id,
    required this.commentaire,
    required this.noteIA,
    required this.date,
  });

  factory AvisDto.fromMap(Map<String, dynamic> map) {
    double toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    final dateRaw = map['date'] ?? map['created_at'];

    return AvisDto(
      id: map['id']?.toString() ?? '',
      commentaire: map['commentaire']?.toString() ?? '',
      noteIA: toDouble(map['note_ia'] ?? map['noteIA']),
      date: dateRaw == null
          ? DateTime.now()
          : DateTime.tryParse(dateRaw.toString()) ?? DateTime.now(),
    );
  }

  AvisEntity toEntity() =>
      AvisEntity(id: id, commentaire: commentaire, noteIA: noteIA, date: date);
}
