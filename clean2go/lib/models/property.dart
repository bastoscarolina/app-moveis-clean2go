import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Property extends Equatable {
  final String id;
  final String nome;
  final String logradouro;
  final String cep;
  final int numero;
  final String cidade;
  final String estado;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String situacao;

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
    required this.situacao
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: _parseString(json['id']) ,
      nome: _parseString(json['nome']) ,
      logradouro: _parseString(json['logradouro']) ,
      cidade: _parseString(json['cidade']) ,
      cep: _parseString(json['cep']) ,
      numero: _parseNumero(json['numero']),
      estado: _parseString(json['estado']) ,
      situacao: _parseString(json['situacao']) ,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': logradouro,
      'cidade': cidade,
      'cep':cep,
      'estado': estado,
      'numero':numero,
      'situacao':situacao,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, nome, logradouro, cidade, estado, createdAt, updatedAt];
}

// Input Model para Forms
class PropertyInput {
  final String nome;
  final String logradouro;
  final String cidade;
  final String estado;

  PropertyInput({
    required this.nome,
    required this.logradouro,
    required this.cidade,
    required this.estado,
  });

  factory PropertyInput.fromProperty(Property property) {
    return PropertyInput(
      nome: property.nome,
      logradouro: property.logradouro,
      cidade: property.cidade,
      estado: property.estado,
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
