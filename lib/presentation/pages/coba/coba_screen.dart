import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:mobile_inventory/data/models/coba/location_model.dart';

class CobaScreen extends StatefulWidget {
  const CobaScreen({super.key});

  @override
  State<CobaScreen> createState() => _CobaScreenState();
}

class _CobaScreenState extends State<CobaScreen> {
  late final MapController _mapController;
  late LatLng.LatLng position;

  List<Marker> getMarkers() {
    return List<Marker>.from(FakeData.fakeLocation.map(
      (e) => new Marker(
        point: LatLng.LatLng(e.latitude, e.longtitude),
        child: Container(
          width: 30,
          height: 30,
          child: Image.asset('assets/images/location.png'),
        ),
      ),
    ));
  }

  @override
  void initState() {
    _mapController = MapController();
    position = LatLng.LatLng(6.983214, 110.406690);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Map Example"),
        centerTitle: true,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: position, // Koordinat Jakarta
          initialZoom: 13.0, // Tingkat zoom peta
          onPositionChanged: (camera, hasGesture) {
            print(position.latitude.toString() + position.longitude.toString());
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: getMarkers(),
          ),
        ],
      ),
    );
  }
}
