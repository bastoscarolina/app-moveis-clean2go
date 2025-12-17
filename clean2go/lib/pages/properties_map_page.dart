import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Certifique-se de ter rodado: flutter pub add flutter_map
import 'package:latlong2/latlong.dart';       // Certifique-se de ter rodado: flutter pub add latlong2
import '../models/property.dart';

class PropertiesMapPage extends StatefulWidget {
  final List<Property> properties;

  const PropertiesMapPage({super.key, required this.properties});

  @override
  State<PropertiesMapPage> createState() => _PropertiesMapPageState();
}

class _PropertiesMapPageState extends State<PropertiesMapPage> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    // Define o centro inicial. 
    // Se a lista tiver imóveis com coordenadas válidas (!= 0), usa o primeiro.
    // Senão, centraliza em São Paulo como fallback.
    final validProperties = widget.properties.where((p) => p.latitude != 0 && p.longitude != 0).toList();
    
    final initialCenter = validProperties.isNotEmpty
        ? LatLng(validProperties.first.latitude, validProperties.first.longitude)
        : const LatLng(-23.5505, -46.6333);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Imóveis'),
        backgroundColor: const Color(0xFF001F3F),
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: initialCenter,
          initialZoom: 13.0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.clean2go.app', // Importante para o OSM não bloquear
          ),
          MarkerLayer(
            markers: validProperties.map((property) {
              return Marker(
                point: LatLng(property.latitude, property.longitude),
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: () => _showPropertyDetails(context, property),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showPropertyDetails(BuildContext context, Property property) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 250,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                property.nome,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_city, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${property.logradouro}, ${property.numero}',
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 26),
                child: Text(
                  '${property.cidade} - ${property.estado}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: property.situacao == 'Ativo' ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  property.situacao,
                  style: TextStyle(
                    color: property.situacao == 'Ativo' ? Colors.green[800] : Colors.red[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001F3F),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fechar'),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
