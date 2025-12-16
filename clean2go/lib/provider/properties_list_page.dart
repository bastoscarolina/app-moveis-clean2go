import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/property.dart';
import '../provider/properties_provider.dart';

class PropertiesListPage extends ConsumerWidget {
  const PropertiesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(propertiesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Meus Imóveis",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF001F3F),
      ),
      body: propertiesAsync.when(
        data: (data) => data.isEmpty 
            ? const Center(child: Text("Nenhum imóvel cadastrado.")) 
            : _buildListView(data),
        error: (error, stackTrace) => Center(child: Text('Erro: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navegar para tela de cadastro de imóvel
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView _buildListView(List<Property> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final property = list[index];
        return ListTile(
          leading: const Icon(Icons.home),
          title: Text(property.nome),
          subtitle: Text('${property.endereco} - ${property.cidade}/${property.estado}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Exemplo de deleção rápida (idealmente, colocar confirmação)
              // ref.read(propertiesControllerProvider.notifier).deleteProperty(property.id);
            },
          ),
        );
      },
    );
  }
}
