import 'package:flutter/material.dart';
import 'package:mobile_inventory/data/models/firebase/supplier_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailSuplierScreen extends StatefulWidget {
  Suplier suplier;
  DetailSuplierScreen({
    Key? key,
    required this.suplier,
  }) : super(key: key);

  @override
  State<DetailSuplierScreen> createState() => _DetailSuplierScreenState();
}

class _DetailSuplierScreenState extends State<DetailSuplierScreen> {
  void _openMap(String latitude, String longtitude) async {
    final url = 'https://www.google.com/maps/place/$latitude,$longtitude';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Tidak dapat memanggil : $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Suplier"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nama Supplier:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  widget.suplier.nama,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Text(
                  "Alamat:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  widget.suplier.alamat,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Text(
                  "Kontak:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  widget.suplier.kontak,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                Text(
                  "Koordinat Lokasi:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Latitude: ${widget.suplier.latitude}",
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  "Longitude: ${widget.suplier.longtitude}",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _openMap(
                          widget.suplier.latitude, widget.suplier.longtitude);
                    },
                    icon: const Icon(Icons.map),
                    label: const Text("Buka di Google Maps"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
