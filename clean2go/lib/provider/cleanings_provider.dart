import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'cleanings_repository.dart';
import '../models/cleaning.dart';

part 'cleanings_provider.g.dart';

// Get
@Riverpod(keepAlive: true)
Future<List<Cleaning>> cleaningsList(Ref ref) async {
  final repository = ref.watch(cleaningsRepositoryProvider);
  return repository.fetchAll();
}

// Get by ID
@riverpod
Future<Cleaning?> cleaning(Ref ref, String id) async {
  final repository = ref.watch(cleaningsRepositoryProvider);
  return repository.fetchById(id);
}

// Controller responsável por criar/editar/deletar cleanings
// Mantém estado para UI (loading, success, error)
@Riverpod(keepAlive: true)
class CleaningsController extends _$CleaningsController {
  @override
  FutureOr<void> build() {
    // Estado inicial vazio
  }

  /// Create
  Future<Cleaning> createCleaning(CleaningInput input) async {
    final validationError = input.validate();
    if (validationError != null) throw Exception(validationError);

    state = const AsyncLoading();

    late Cleaning created;

    state = await AsyncValue.guard(() async {
      final repo = ref.read(cleaningsRepositoryProvider);
      created = await repo.create(input);

      // refresh
      ref.invalidate(cleaningsListProvider);
    });

    if (state.hasError) throw state.error!;
    return created;
  }

  // Update
  Future<Cleaning> updateCleaning(String id, CleaningInput input) async {
    final validationError = input.validate();
    if (validationError != null) throw Exception(validationError);

    state = const AsyncLoading();

    late Cleaning updated;

    state = await AsyncValue.guard(() async {
      final repo = ref.read(cleaningsRepositoryProvider);
      updated = await repo.update(id, input);

      ref.invalidate(cleaningsListProvider);
      ref.invalidate(cleaningProvider(id));
    });

    if (state.hasError) throw state.error!;
    return updated;
  }

  // Delete
  Future<void> deleteCleaning(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(cleaningsRepositoryProvider);
      await repo.delete(id);

      ref.invalidate(cleaningsListProvider);
    });

    if (state.hasError) throw state.error!;
  }
}
