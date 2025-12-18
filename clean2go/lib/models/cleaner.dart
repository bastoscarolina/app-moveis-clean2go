import 'package:equatable/equatable.dart';

/// Modelo de dados para Cleaner (Diarista)
/// Usa Equatable para comparação eficiente
class Cleaner extends Equatable {
  final int id;
  final String nome;
  final String telefone;
  final String email;
  final String cpf;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Cleaner({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.email,
    required this.cpf,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Cria Cleaner a partir do JSON do Supabase
  factory Cleaner.fromJson(Map<String, dynamic> json) {
    return Cleaner(
      id: json['new_id'] as int,
      nome: json['nome'] as String,
      telefone: json['telefone'] as String,
      email: json['email'] as String,
      cpf: json['cpf'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// Converte para JSON, caso o CleanerInput não seja utilizado
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'cpf': cpf,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Método copyWith para atualizações imutáveis
  Cleaner copyWith({
    int? id,
    String? nome,
    String? telefone,
    String? email,
    String? cpf,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cleaner(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Formata CPF para exibição (123.456.789-01)
  String get cpfFormatado {
    final numeros = cpf.replaceAll(RegExp(r'\D'), '');
    if (numeros.length != 11) return cpf;
    return '${numeros.substring(0, 3)}.${numeros.substring(3, 6)}.${numeros.substring(6, 9)}-${numeros.substring(9)}';
  }

  /// Formata telefone para exibição (11) 98765-4321
  String get telefoneFormatado {
    final numeros = telefone.replaceAll(RegExp(r'\D'), '');
    if (numeros.length == 11) {
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 7)}-${numeros.substring(7)}';
    } else if (numeros.length == 10) {
      return '(${numeros.substring(0, 2)}) ${numeros.substring(2, 6)}-${numeros.substring(6)}';
    }
    return telefone;
  }

  @override
  String toString() {
    return 'Cleaner(id: $id, nome: $nome, telefone: $telefone, email: $email)';
  }

  @override
  List<Object?> get props => [id, nome, telefone, email, cpf, createdAt, updatedAt];
}