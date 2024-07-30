import 'package:flutter/material.dart';
import 'package:hot_spot/src/data/fang_data.dart';
import 'package:intl/intl.dart';

class FangDetailsScreen extends StatelessWidget {
  final FangData fang;

  const FangDetailsScreen({Key? key, required this.fang}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fang Details'),
        backgroundColor: Color.fromARGB(255, 191, 226, 193),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (fang.bildUrl != null && fang.bildUrl!.isNotEmpty)
              Image.network(
                fang.bildUrl!,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[300],
                child: Icon(Icons.image_not_supported,
                    size: 100, color: Colors.grey[600]),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fang.fischart,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  DetailRow(
                      title: 'Größe',
                      value: '${fang.groesse.toStringAsFixed(2)} cm'),
                  DetailRow(
                      title: 'Gewicht',
                      value: '${fang.gewicht.toStringAsFixed(2)} g'),
                  DetailRow(
                      title: 'Gefangen am',
                      value: DateFormat('dd.MM.yyyy').format(fang.datum)),
                  DetailRow(title: 'Gewässer', value: fang.gewaesser),
                  if (fang.angelmethode != null)
                    DetailRow(title: 'Angelmethode', value: fang.angelmethode!),
                  if (fang.naturkoeder != null)
                    DetailRow(title: 'Naturköder', value: fang.naturkoeder!),
                  SizedBox(height: 16),
                  Text(
                    'Gefangen von: ${fang.username}', // Changed from userID to username
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String value;

  const DetailRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
