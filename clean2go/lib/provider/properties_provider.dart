import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'properties_repository.dart';
import '../models/property.dart';

part 'properties_provider.g.dart';

// Lista de Imóveis
@Riverpod(keepAlive: true)
Future<List<Property>> propertiesList(Ref ref) async {
  final repository = ref.watch(propertiesRepositoryProvider);
  return repository.fetchAll();
}

// Imóvel único
@riverpod
Future<Property?> property(Ref ref, String id) async {
  final repository = ref.watch(propertiesRepositoryProvider);
  return repository.fetchById(id);
}

// Controller (Create, Update, Delete)
@Riverpod(keepAlive: true)
class PropertiesController extends _$PropertiesController {
  @override
  FutureOr<void> build() {}

  Future<Property> createProperty(PropertyInput input) async {
    final validationError = input.validate();
    if (validationError != null) throw Exception(validationError);

    state = const AsyncLoading();
    late Property created;

    state = await AsyncValue.guard(() async {
      final repo = ref.read(propertiesRepositoryProvider);
      created = await repo.create(input);
      ref.invalidate(propertiesListProvider);
    });

    if (state.hasError) throw state.error!;
    return created;
  }

  Future<Property> updateProperty(String id, PropertyInput input) async {
    final validationError = input.validate();
    if (validationError != null) throw Exception(validationError);

    state = const AsyncLoading();
    late Property updated;

    state = await AsyncValue.guard(() async {
      final repo = ref.read(propertiesRepositoryProvider);
      updated = await repo.update(id, input);
      ref.invalidate(propertiesListProvider);
      ref.invalidate(propertyProvider(id));
    });

    if (state.hasError) throw state.error!;
    return updated;
  }

  Future<void> deleteProperty(String id) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(propertiesRepositoryProvider);
      await repo.delete(id);
      ref.invalidate(propertiesListProvider);
    });

    if (state.hasError) throw state.error!;
  }
}
