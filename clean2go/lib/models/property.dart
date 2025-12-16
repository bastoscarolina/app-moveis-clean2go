import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String id;
  final String nome;
  final String endereco;
  final String cidade;
  final String estado;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Property({
    required this.id,
    required this.nome,
    required this.endereco,
    required this.cidade,
    required this.estado,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as String,
      nome: json['nome'] as String,
      endereco: json['endereco'] as String,
      cidade: json['cidade'] as String,
      estado: json['estado'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'cidade': cidade,
      'estado': estado,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, nome, endereco, cidade, estado, createdAt, updatedAt];
}

// Input Model para Forms
class PropertyInput {
  final String nome;
  final String endereco;
  final String cidade;
  final String estado;

  PropertyInput({
    required this.nome,
    required this.endereco,
    required this.cidade,
    required this.estado,
  });

  factory PropertyInput.fromProperty(Property property) {
    return PropertyInput(
      nome: property.nome,
      endereco: property.endereco,
      cidade: property.cidade,
      estado: property.estado,
    );
  }

  String? validate() {
    if (nome.trim().isEmpty) return 'Nome/Apelido é obrigatório';
    if (endereco.trim().isEmpty) return 'Endereço é obrigatório';
    if (cidade.trim().isEmpty) return 'Cidade é obrigatória';
    if (estado.trim().isEmpty) return 'Estado é obrigatório';
    if (estado.length != 2) return 'Use a sigla do estado (Ex: SP)';
    return null;
  }
}
