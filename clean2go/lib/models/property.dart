import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final int id;
  final String nome;
  final String logradouro;
  final String cep;
  final int numero;
  final String cidade;
  final String estado;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String situacao;
  
  // NOVOS CAMPOS PARA O MAPA
  final double latitude;
  final double longitude;

  const Property({
    required this.id,
    required this.nome,
    required this.logradouro,
    required this.cidade,
    required this.cep,
    required this.numero,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
    required this.situacao,
    // Novos requeridos (com valores padrão no fromJson se não existirem)
    required this.latitude,
    required this.longitude,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: _parseNumero(json['id']),
      nome: _parseString(json['nome']),
      logradouro: _parseString(json['logradouro']),
      cidade: _parseString(json['cidade']),
      cep: _parseString(json['cep']),
      numero: _parseNumero(json['numero']),
      estado: _parseString(json['estado']),
      situacao: _parseString(json['situacao']),
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      // Parsing seguro para double
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
    );
  }

  static int _parseNumero(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  // Novo Helper para tratar números decimais (Double)
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
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
      // fallback para formato do Postgres se necessário
      return DateTime.parse(
        str.replaceFirst(' ', 'T'),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'logradouro': logradouro, // Nota: mantive a chave que você usava antes
      'cidade': cidade,
      'cep': cep,
      'estado': estado,
      'numero': numero,
      'situacao': situacao,
      'latitude': latitude,   // Novo
      'longitude': longitude, // Novo
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        nome,
        logradouro,
        cidade,
        cep,
        estado,
        numero,
        situacao,
        createdAt,
        updatedAt,
        latitude,
        longitude
      ];
}

// Input Model para Forms
class PropertyInput {
  final String nome;
  final String logradouro;
  final String cidade;
  final String estado;
  // Adicionei opcionais aqui para não quebrar seu form atual,
  // mas você poderá usá-los no futuro.
  final double? latitude;
  final double? longitude;

  PropertyInput({
    required this.nome,
    required this.logradouro,
    required this.cidade,
    required this.estado,
    this.latitude,
    this.longitude,
  });

  factory PropertyInput.fromProperty(Property property) {
    return PropertyInput(
      nome: property.nome,
      logradouro: property.logradouro,
      cidade: property.cidade,
      estado: property.estado,
      latitude: property.latitude,
      longitude: property.longitude,
    );
  }

  String? validate() {
    if (nome.trim().isEmpty) return 'Nome/Apelido é obrigatório';
    if (logradouro.trim().isEmpty) return 'Endereço é obrigatório';
    if (cidade.trim().isEmpty) return 'Cidade é obrigatória';
    if (estado.trim().isEmpty) return 'Estado é obrigatório';
    if (estado.length != 2) return 'Use a sigla do estado (Ex: SP)';
    return null;
  }
}
