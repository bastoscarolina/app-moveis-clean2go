import 'package:clean2go/models/cleaner.dart';
import 'package:clean2go/provider/cleaners_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CleanersListPage extends ConsumerWidget {
  const CleanersListPage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleanerAsyn = ref.watch(cleanersListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: 
        Text("Clean2Go",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),)),
        backgroundColor: const Color(0xFF001F3F),
      ),
      body: Center(
        child: cleanerAsyn.when(
          data: (data) => _buildListView(data),
          error: (error, stackTrace) => Text('Erro: $error'),
          loading: () => const CircularProgressIndicator(),
        ),));
  }

   ListView _buildListView(List<Cleaner> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => ListTile(
        // REMOVIDO o "?? ''" pois a variável não é nula
        title: Text(list[index].nome), 
      )
    );
  }
}