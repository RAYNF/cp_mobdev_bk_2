import 'package:flutter/material.dart';
import 'package:mobile_inventory/presentation/utils/styles.dart';

class ItemBeranda extends StatelessWidget {
  final String title;
  final String imagePath;
  final Future<int> Function() fetchTotalProducts;
  final VoidCallback onTap;
  const ItemBeranda(
      {super.key,
      required this.imagePath,
      required this.fetchTotalProducts,
      required this.onTap,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: primaryColor),
        child: Padding(
          padding: EdgeInsets.all(
            16,
          ),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Image.asset(imagePath),
              ),
              const SizedBox(
                width: 10,
              ),
              FutureBuilder<int>(
                future: fetchTotalProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Text(
                      '$title : ${snapshot.data}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    );
                  } else {
                    return const Text('Tidak ada data');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
