class Cleaning {
  final int id;
  final int property;
  final DateTime date;
  final String cleaner;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cleaning({
    required this.id,
    required this.property,
    required this.date,
    required this.status,
    required this.cleaner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Cleaning.fromJson(Map<String, dynamic> json) {
    return Cleaning(
      id: _parseNumero(json['id']),
      property: _parseNumero(json['property']),
      date: _parseDate(json['date']),
      status: _parseString(json['status']),
      cleaner: _parseString(json['cleaner']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }
  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static DateTime _parseDate(dynamic value) {
  if (value == null) {
    return DateTime.now();
  }

  if (value is DateTime) return value;

  final str = value.toString();

  try {
    return DateTime.parse(str);
  } catch (_) {
    // fallback para formato do Postgres
    return DateTime.parse(
      str.replaceFirst(' ', 'T'),
      );
    }
  }
  static int _parseNumero(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
  }
}

