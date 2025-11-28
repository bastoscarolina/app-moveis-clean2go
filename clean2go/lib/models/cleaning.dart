class Cleaning {
  final String id;
  final String property;
  final DateTime date;
  final String cleaner;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cleaning({
    required this.id,
    required this.property,
    required this.date,
    required this.cleaner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cleaning.fromJson(Map<String, dynamic> json) {
    return Cleaning(
      id: json['id'],
      property: json['property'],
      date: DateTime.parse(json['date']),
      cleaner: json['cleaner'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
