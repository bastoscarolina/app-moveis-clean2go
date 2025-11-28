import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_provider.dart';
import '../models/cleaner.dart';

part 'cleaners_repository.g.dart';

/// Repository para operações de CRUD de Cleaners
/// Centraliza toda lógica de acesso ao Supabase
@riverpod
CleanersRepository cleanersRepository(Ref ref) {
  return CleanersRepository(ref.watch(supabaseProvider));
}

class CleanersRepository {
  final SupabaseClient _db;
  static const String _tableName = 'cleaners';

  CleanersRepository(this._db);

  /// Busca todos os cleaners
  Future<List<Cleaner>> fetchAll() async {
    try {
      final List<dynamic> result = await _db
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return result.map<Cleaner>((e) => Cleaner.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Erro ao buscar diaristas: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao buscar diaristas: $e');
    }
  }

  /// Busca um cleaner específico por ID
  Future<Cleaner?> fetchById(String id) async {
    try {
      final json = await _db
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      return json == null ? null : Cleaner.fromJson(json);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao buscar diarista: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao buscar diarista: $e');
    }
  }

  /// Cria um novo cleaner e retorna o objeto criado
  Future<Cleaner> create(CleanerInput input) async {
    try {
      final now = DateTime.now().toIso8601String();
      final result = await _db
          .from(_tableName)
          .insert({
        'nome': input.nome,
        'telefone': input.telefone,
        'email': input.email,
        'cpf': input.cpf,
        'created_at': now,
        'updated_at': now,
      })
          .select()
          .single();

      return Cleaner.fromJson(result);
    } on PostgrestException catch (e) {

      // Trata violação de constraint UNIQUE (CPF ou email duplicado)
      if (e.code == '23505') {
        throw Exception('CPF ou email já cadastrado');
      }
      throw Exception('Erro ao criar diarista: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao criar diarista: $e');
    }
  }

  /// Atualiza dados de um cleaner existente e retorna o objeto atualizado
  Future<Cleaner> update(String id, CleanerInput input) async {
    try {
      final result = await _db
          .from(_tableName)
          .update({
        'nome': input.nome,
        'telefone': input.telefone,
        'email': input.email,
        'cpf': input.cpf,
        'updated_at': DateTime.now().toIso8601String(),
      })
          .eq('id', id)
          .select()
          .single();

      return Cleaner.fromJson(result);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        throw Exception('CPF ou email já cadastrado');
      }
      throw Exception('Erro ao atualizar diarista: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao atualizar diarista: $e');
    }
  }

  /// Remove um cleaner pelo ID
  Future<void> delete(String id) async {
    try {
      await _db.from(_tableName).delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao deletar diarista: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado ao deletar diarista: $e');
    }
  }
}

/// Classe para input de criação/atualização (sem ID e timestamps)
class CleanerInput {
  final String nome;
  final String telefone;
  final String email;
  final String cpf;

  CleanerInput({
    required this.nome,
    required this.telefone,
    required this.email,
    required this.cpf,
  });

  /// Cria CleanerInput a partir de um Cleaner existente
  /// Útil para formulários de edição
  factory CleanerInput.fromCleaner(Cleaner cleaner) {
    return CleanerInput(
      nome: cleaner.nome,
      telefone: cleaner.telefone,
      email: cleaner.email,
      cpf: cleaner.cpf,
    );
  }

  /// Validação básica dos campos
  String? validate() {
    if (nome.trim().isEmpty) return 'Nome é obrigatório';
    if (telefone.trim().isEmpty) return 'Telefone é obrigatório';
    if (email.trim().isEmpty) return 'Email é obrigatório';
    if (!email.contains('@')) return 'Email inválido';
    if (cpf.trim().isEmpty) return 'CPF é obrigatório';
    if (cpf.replaceAll(RegExp(r'\D'), '').length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    return null;
  }
}