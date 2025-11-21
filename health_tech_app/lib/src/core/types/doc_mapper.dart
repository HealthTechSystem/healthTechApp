import 'package:cloud_firestore/cloud_firestore.dart';

typedef DocMapper<T> = T Function(DocumentSnapshot<Map<String, dynamic>> doc);
