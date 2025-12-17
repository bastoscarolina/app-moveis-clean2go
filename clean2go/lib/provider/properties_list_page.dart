import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/property.dart';
import '../provider/properties_provider.dart';
import 'cleanings_repository.dart';
import 'package:uuid/uuid.dart';

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
            : _buildListView(context, ref, data),
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

  ListView _buildListView(BuildContext context,
  WidgetRef ref,List<Property> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final property = list[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.home),
            title: Text(property.nome),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${property.logradouro} - ${property.cidade}/${property.estado}'),
              ],
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Color.fromARGB(255, 3, 86, 103)),
                  onPressed: () {
                    _showPropertyDetails(context, property);
                    // Exemplo de deleção rápida (idealmente, colocar confirmação)
                    // ref.read(propertiesControllerProvider.notifier).deleteProperty(property.id);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cleaning_services),
                  tooltip: 'Agendar limpeza',
                  onPressed: ()  async {
                      try {
                        final uuid = Uuid();

                        final String id = uuid.v4();
                        final input = CleaningInput(
                          property: property.id,
                          date: DateTime.now(),
                          cleaner: id, status: 'agendada',
                        );

                        await ref
                            .read(cleaningsRepositoryProvider)
                            .create(input);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Limpeza agendada com sucesso!'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro: $e')),
                          );
                        }
                  },
                ),
              ],
            ),
            
          ),
        );
      },
    );
  }
}
void _showPropertyDetails(BuildContext context, Property property) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(property.nome),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailItem('Endereço', property.logradouro),
            _detailItem('Cidade', property.cidade),
            _detailItem('Estado', property.estado),
            _detailItem('Status', property.situacao),
            _detailItem(
              'Criado em',
              property.createdAt?.toString() ?? '—',
            ),
            _detailItem(
              'Atualizado em',
              property.updatedAt?.toString() ?? '—',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}
Widget _detailItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    ),
  );
}

