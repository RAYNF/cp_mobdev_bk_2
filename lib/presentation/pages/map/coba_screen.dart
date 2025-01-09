import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:mobile_inventory/data/models/coba/location_model.dart';

class CobaScreen extends StatefulWidget {
  const CobaScreen({super.key});

  @override
  State<CobaScreen> createState() => _CobaScreenState();
}

class _CobaScreenState extends State<CobaScreen> {
  late final MapController _mapController;
  LatLng.LatLng? currentPosition;
  LatLng.LatLng? selectedPosition;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Layanan lokasi tidak aktif')),
        );
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Izin lokasi ditolak')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Izin lokasi ditolak secara permanen')),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        currentPosition = LatLng.LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error mendapatkan lokasi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Map Example"),
        centerTitle: true,
      ),
      body: currentPosition == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentPosition!,
                initialZoom: 13.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    selectedPosition = point;
                  });
                  debugPrint('onTap dipanggil');
                  print(
                      'Koordinat lokasi yang dipilih: ${point.latitude}, ${point.longitude}');

                  Navigator.pop(context, {
                    'latitude': point.latitude,
                    'longitude': point.longitude
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                ),
                if (selectedPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: selectedPosition!,
                        child: Container(
                          width: 30,
                          height: 30,
                          child: Image.asset('assets/images/location.png'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}
