import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Ajuste os imports conforme a estrutura real das suas pastas
import '../models/property.dart';
import '../provider/properties_provider.dart'; 
import 'properties_map_page.dart';

class PropertiesListPage extends ConsumerWidget {
  const PropertiesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observa o provider que busca a lista do Supabase
    final propertiesAsync = ref.watch(propertiesListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Meus Imóveis",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF001F3F),
        actions: [
          // Botão de Mapa (Só aparece se os dados carregaram com sucesso)
          propertiesAsync.maybeWhen(
            data: (properties) => IconButton(
              icon: const Icon(Icons.map, color: Colors.white),
              tooltip: 'Ver no Mapa',
              onPressed: () {
                if (properties.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PropertiesMapPage(properties: properties),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nenhum imóvel cadastrado para visualizar.')),
                  );
                }
              },
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: propertiesAsync.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum imóvel cadastrado.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return _buildListView(data);
        },
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Erro ao carregar imóveis: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF001F3F),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // TODO: Navegar para a tela de cadastro (Create)
          // Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyFormPage()));
        },
      ),
    );
  }

  Widget _buildListView(List<Property> list) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final property = list[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF001F3F),
              child: Text(
                property.nome.isNotEmpty ? property.nome[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              property.nome,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${property.logradouro}, ${property.numero}'),
                Text(
                  '${property.cidade}/${property.estado}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            onTap: () {
              // TODO: Navegar para detalhes ou edição
            },
          ),
        );
      },
    );
  }
}
