import 'package:flutter/material.dart';
import '../services/criteria_service.dart';
import '../models/criteria_model.dart';

class CriteriaPage extends StatefulWidget {
  const CriteriaPage({super.key});

  @override
  State<CriteriaPage> createState() => _CriteriaPageState();
}

class _CriteriaPageState extends State<CriteriaPage> {
  final service = CriteriaService();

  late Future<List<CriteriaModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = service.getCriteria();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kriteria')),
      body: FutureBuilder<List<CriteriaModel>>(
        future: futureData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return ListTile(
                title: Text(item.name),
                subtitle: Text('Bobot: ${item.weight}'),
              );
            },
          );
        },
      ),
    );
  }
}