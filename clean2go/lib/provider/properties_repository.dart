import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_provider.dart';
import '../models/property.dart';

part 'properties_repository.g.dart';

@riverpod
PropertiesRepository propertiesRepository(Ref ref) {
  return PropertiesRepository(ref.watch(supabaseProvider));
}

class PropertiesRepository {
  final SupabaseClient _db;
  static const String _tableName = 'properties';

  PropertiesRepository(this._db);

  // Fetch All
  Future<List<Property>> fetchAll() async {
    try {
      final result = await _db
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return result.map<Property>((e) => Property.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Erro ao buscar imóveis: ${e.message}');
    } catch (e) {
      throw Exception('Erro inesperado: $e');
    }
  }

  // Fetch By ID
  Future<Property?> fetchById(String id) async {
    try {
      final json = await _db
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      return json == null ? null : Property.fromJson(json);
    } catch (e) {
      throw Exception('Erro ao buscar imóvel: $e');
    }
  }

  // Create
  Future<Property> create(PropertyInput input) async {
    try {
      final now = DateTime.now().toIso8601String();
      final result = await _db
          .from(_tableName)
          .insert({
            'nome': input.nome,
            'endereco': input.logradouro,
            'cidade': input.cidade,
            'estado': input.estado,
            'created_at': now,
            'updated_at': now,
          })
          .select()
          .single();

      return Property.fromJson(result);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao criar imóvel: ${e.message}');
    }
  }

  // Update
  Future<Property> update(String id, PropertyInput input) async {
    try {
      final result = await _db
          .from(_tableName)
          .update({
            'nome': input.nome,
            'endereco': input.logradouro,
            'cidade': input.cidade,
            'estado': input.estado,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      return Property.fromJson(result);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao atualizar imóvel: ${e.message}');
    }
  }

  // Delete
  Future<void> delete(String id) async {
    try {
      await _db.from(_tableName).delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao deletar imóvel: ${e.message}');
    }
  }
}
