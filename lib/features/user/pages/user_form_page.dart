import 'package:flutter/material.dart';
import '../services/user_service.dart';

class UserFormPage extends StatefulWidget {
  final Map? user;

  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final service = UserService();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  String role = 'guru';

  @override
  void initState() {
    super.initState();

    if (widget.user != null) {
      name.text = widget.user!['name'];
      email.text = widget.user!['email'];
      role = widget.user!['role'];
    }
  }

  void save() async {
    final data = {
      'name': name.text,
      'email': email.text,
      'role': role,
      if (widget.user == null) 'password': password.text,
    };

    if (widget.user == null) {
      await service.create(data);
    } else {
      await service.update(widget.user!['id'], data);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Tambah User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Nama')),
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
            
            if (widget.user == null)
              TextField(
                controller: password,
                decoration: const InputDecoration(labelText: 'Password'),
              ),

            DropdownButton<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: 'guru', child: Text('Guru')),
                DropdownMenuItem(value: 'kepsek', child: Text('Kepsek')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}