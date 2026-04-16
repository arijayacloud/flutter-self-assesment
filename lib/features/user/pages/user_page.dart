import 'package:flutter/material.dart';
import '../../../shared/widgets/app_card.dart';
import '../services/user_service.dart';
import 'user_form_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final service = UserService();
  late Future<List> futureData;

  @override
  void initState() {
    super.initState();
    futureData = service.getUsers();
  }

  void refresh() {
    setState(() {
      futureData = service.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserFormPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List>(
        future: futureData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final user = data[index];

              return AppCard(
                child: Row(
                  children: [
                    const CircleAvatar(child: Icon(Icons.person)),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            user['email'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    Chip(label: Text(user['role'])),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserFormPage(user: user),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 20,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await service.delete(user['id']);
                        refresh();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
