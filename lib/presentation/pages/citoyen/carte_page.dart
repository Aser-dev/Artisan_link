// lib/presentation/pages/citoyen/carte_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../providers/commerce_provider.dart';
import 'detail_commerce_page.dart';
import '../../../core/constants.dart';

class CartePage extends ConsumerStatefulWidget {
  const CartePage({super.key});

  @override
  ConsumerState<CartePage> createState() => _CartePageState();
}

class _CartePageState extends ConsumerState<CartePage> {
  final MapController _mapController = MapController();
  bool _gpsCharge = false;
  LatLng? _positionActuelle;

  @override
  void initState() {
    super.initState();
    _chargerPosition();
  }

  Future<void> _chargerPosition() async {
    bool serviceActive = await Geolocator.isLocationServiceEnabled();
    if (!serviceActive) {
      _fallbackOuaga();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      _fallbackOuaga();
      return;
    }

    try {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      setState(() {
        _positionActuelle = LatLng(pos.latitude, pos.longitude);
        _gpsCharge = true;
      });
      _chargerCommerces(pos.latitude, pos.longitude);
    } catch (_) {
      _fallbackOuaga();
    }
  }

  void _fallbackOuaga() {
    setState(() {
      _positionActuelle = AppConstants.ouagadougouCentre;
      _gpsCharge = true;
    });
    _chargerCommerces(
      AppConstants.ouagadougouCentre.latitude,
      AppConstants.ouagadougouCentre.longitude,
    );
  }

  void _chargerCommerces(double lat, double lon) {
    ref
        .read(commerceProvider.notifier)
        .chargerProches(latitude: lat, longitude: lon);
  }

  @override
  Widget build(BuildContext context) {
    final commerceState = ref.watch(commerceProvider);
    final commerces = commerceState.commerces;

    if (!_gpsCharge || commerceState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (commerceState.erreur != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(commerceState.erreur!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _chargerPosition,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    final markers = commerces.where((c) => c.aPosition).map((c) {
      return Marker(
        width: 60,
        height: 60,
        point: LatLng(c.latitude!, c.longitude!),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailCommercePage(commerceId: c.id),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6),
              ],
            ),
            child: const Icon(
              Icons.storefront,
              color: Color(0xFF2E4A0B),
              size: 28,
            ),
          ),
        ),
      );
    }).toList();

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _positionActuelle ?? AppConstants.ouagadougouCentre,
            initialZoom: 14.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.artisan_bf',
            ),
            MarkerLayer(markers: markers),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            onPressed: _chargerPosition,
            child: const Icon(Icons.my_location, color: Color(0xFF2E4A0B)),
          ),
        ),
      ],
    );
  }
}
