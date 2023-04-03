import 'package:cloud_firestore/cloud_firestore.dart';

class MyImage {
  final String url;
  final String description;
  final int size;
  final String userId;

  MyImage({required this.url, required this.description, required this.userId, required this.size});

  factory MyImage.fromSnapshot(QueryDocumentSnapshot snapshot) {
    return MyImage(
      url: snapshot['url'],
      description: snapshot['description'],
      size: snapshot['size'],
      userId: snapshot['userId'],
    );
  }
}