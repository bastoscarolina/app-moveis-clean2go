import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'cleaners_repository.dart';
import '../models/cleaner.dart';

part 'cleaners_provider.g.dart';

/// Provider que fornece a lista de cleaners
/// Auto-refresh quando há mutações
@Riverpod(keepAlive: true)
Future<List<Cleaner>> cleanersList(Ref ref) async {
  final repository = ref.watch(cleanersRepositoryProvider);
  return repository.fetchAll();
}

/// Provider para buscar um cleaner específico por ID
@riverpod
Future<Cleaner?> cleaner(Ref ref, String id) async {
  final repository = ref.watch(cleanersRepositoryProvider);
  return repository.fetchById(id);
}

/// Notifier para gerenciar operações de CRUD
/// Permite controle de estado para UI (loading, error, success)
@Riverpod(keepAlive: true)
class CleanersController extends _$CleanersController {
  @override
  FutureOr<void> build() {
    // Estado inicial vazio
  }

  /// Cria um novo cleaner e retorna o objeto criado
  Future<Cleaner> createCleaner(CleanerInput input) async {
    // Validação antes de enviar
    final validationError = input.validate();
    if (validationError != null) {
      throw Exception(validationError);
    }

    state = const AsyncLoading();

    late Cleaner createdCleaner;

    state = await AsyncValue.guard(() async {
      final repository = ref.read(cleanersRepositoryProvider);
      createdCleaner = await repository.create(input);

      // Invalida lista para forçar refresh
      ref.invalidate(cleanersListProvider);
    });

    // Lança exceção se houve erro
    if (state.hasError) {
      throw state.error!;
    }

    return createdCleaner;
  }

  /// Atualiza um cleaner existente e retorna o objeto atualizado
  Future<Cleaner> updateCleaner(String id, CleanerInput input) async {
    final validationError = input.validate();
    if (validationError != null) {
      throw Exception(validationError);
    }

    state = const AsyncLoading();

    late Cleaner updatedCleaner;

    state = await AsyncValue.guard(() async {
      final repository = ref.read(cleanersRepositoryProvider);
      updatedCleaner = await repository.update(id, input);

      // Invalida lista e cleaner específico
      ref.invalidate(cleanersListProvider);
      ref.invalidate(cleanerProvider(id));
    });

    // Lança exceção se houve erro
    if (state.hasError) {
      throw state.error!;
    }

    return updatedCleaner;
  }

  /// Deleta um cleaner
  Future<void> deleteCleaner(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(cleanersRepositoryProvider);
      await repository.delete(id);

      // Invalida lista
      ref.invalidate(cleanersListProvider);
    });

    // Lança exceção se houve erro
    if (state.hasError) {
      throw state.error!;
    }
  }
}