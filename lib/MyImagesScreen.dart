import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'EditProfilePage.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({required this.uid});
  final String uid;

  @override
  State<ImagePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ImagePage> {
  int _counter = 0;

  Future<void> _incrementCounter() async {
    final picker = ImagePicker();
    final response = await picker.pickImage(source: ImageSource.gallery);
    if (response == null) return;

    final test = await response.readAsBytes();
    final path = '/images/' + getRandomString(5) + '.png';

    await FirebaseStorage.instance.ref(path).putData(test);

    setState(() {});
  }

  String link = '';
  List<ModelTest> fullpath = [];

  String getRandomString(int length) {
    final _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Future<void> initImage() async {
    final storageReference = FirebaseStorage.instance.ref('/images/').list();
    final list = await storageReference;
    fullpath = await Future.wait(list.items.map((element) async {
      final url = await element.getDownloadURL();
      return ModelTest(url, element.name);
    }));
    setState(() {});
  }

  @override
  void initState() {
    initImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Images"),
        actions: [
          IconButton(
            onPressed: initImage,
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: fullpath.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onLongPress: () async {
                      link = '';
                      await FirebaseStorage.instance
                          .ref("/images" + fullpath[index].name)
                          .delete();
                      await initImage();
                      setState(() {});
                    },
                    onTap: () {
                      setState(() {
                        link = fullpath[index].url;
                      });
                    },
                    child: ListTile(
                      title: Text(fullpath[index].name),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: link.isNotEmpty
                ? Image.network(
                    link,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Ошибка');
                    },
                  )
                : Container(),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(uid: widget.uid),
                ),
              );
            },
            tooltip: 'Profile',
            child: const Icon(Icons.person),
          )
        ],
      ),
    );
  }
}

class ModelTest {
  final String url;
  final String name;

  ModelTest(this.url, this.name);
}

String getRandomString(int length) {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final _rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
