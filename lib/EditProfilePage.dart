import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({required this.uid});

  final String uid;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  late final File _imageFile;

  Widget _buildInput(
    Icon icon,
    String hint,
    TextEditingController controller,
    bool obscure,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          hintText: hint,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 3),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1),
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: icon,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final user = firestore.collection('user');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 10),
              child: _buildInput(
                const Icon(Icons.person),
                'Name',
                _nameController,
                false,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                user
                    .doc(widget.uid)
                    .set({
                      'name': _nameController.text,
                    })
                    .then((value) => print('User update'))
                    .catchError((error) => print('Error: $error'));
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
