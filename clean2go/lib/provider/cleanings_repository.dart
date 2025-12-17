import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_provider.dart';
import '../models/cleaning.dart';

part 'cleanings_repository.g.dart';

// Repository CRUD de Cleanings
// Centraliza a lógica de acesso ao Supabase
@riverpod
CleaningsRepository cleaningsRepository(Ref ref) {
  return CleaningsRepository(ref.watch(supabaseProvider));
}

class CleaningsRepository {
  final SupabaseClient _db;
  static const String _tableName = 'cleanings';

  CleaningsRepository(this._db);

  // Get
  Future<List<Cleaning>> fetchAll() async {
    try {
      final result = await _db
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return result.map<Cleaning>((e) => Cleaning.fromJson(e)).toList();
    } on PostgrestException catch (e) {
      throw Exception('Error fetching cleanings: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching cleanings: $e');
    }
  }

  // Get by ID
  Future<Cleaning?> fetchById(String id) async {
    try {
      final json = await _db
          .from(_tableName)
          .select()
          .eq('id', id)
          .maybeSingle();

      return json == null ? null : Cleaning.fromJson(json);
    } on PostgrestException catch (e) {
      throw Exception('Error fetching cleaning: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error fetching cleaning: $e');
    }
  }

  // Create
  Future<Cleaning> create(CleaningInput input) async {
    try {
      final now = DateTime.now().toIso8601String();

      final result = await _db
          .from(_tableName)
          .insert({
            'property': input.property,
            'date': input.date.toIso8601String(),
            'status': input.status,
            'cleaner': input.cleaner,
            'created_at': now,
            'updated_at': now,
          })
          .select()
          .single();

      return Cleaning.fromJson(result);

    } on PostgrestException catch (e) {
      throw Exception('Error creating cleaning: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error creating cleaning: $e');
    }
  }

  // Update
  Future<Cleaning> update(String id, CleaningInput input) async {
    try {
      final result = await _db
          .from(_tableName)
          .update({
            'property': input.property,
            'date': input.date.toIso8601String(),
            'status':input.status,
            'cleaner': input.cleaner,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      return Cleaning.fromJson(result);

    } on PostgrestException catch (e) {
      throw Exception('Error updating cleaning: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error updating cleaning: $e');
    }
  }

  // Delete
  Future<void> delete(String id) async {
    try {
      await _db.from(_tableName).delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Error deleting cleaning: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error deleting cleaning: $e');
    }
  }
}

// Input Model
class CleaningInput {
  final int property;
  final DateTime date;
  final String cleaner;
  final String status;

  CleaningInput({
    required this.property,
    required this.date,
    required this.cleaner,
    required this.status
  });

  // Converção
  factory CleaningInput.fromCleaning(Cleaning cleaning) {
    return CleaningInput(
      property: cleaning.property,
      date: cleaning.date,
      cleaner: cleaning.cleaner,
      status: cleaning.status
    );
  }

  // Validação 
  String? validate() {
    if (property == null || property <= 0) return 'ID do imóvel é obrigatório!';
    if (cleaner.trim().isEmpty) return 'Diarista é obrigatório!';
    return null;
  }
}
