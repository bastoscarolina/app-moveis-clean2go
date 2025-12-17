import 'package:clean2go/models/cleaning.dart';
import 'package:clean2go/provider/cleanings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CleaningListPage extends ConsumerWidget {
  const CleaningListPage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cleaningsAsyn = ref.watch(cleaningsListProvider);

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
        child: cleaningsAsyn.when(
          data: (data) => _buildListView(data),
          error: (error, stackTrace) => Text('Erro: $error'),
          loading: () => const CircularProgressIndicator(),
        ),));
  }

  ListView _buildListView(List<Cleaning> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(list[index].id.toString()),
      )
    );
  }
}