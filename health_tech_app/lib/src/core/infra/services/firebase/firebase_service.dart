import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_tech_app/firebase_options.dart';

import '../../../types/doc_mapper.dart';
class FirebaseService {
  FirebaseService(this._db);
  final FirebaseFirestore _db;

  static Future<FirebaseApp> initialize() =>
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Stream<int> countAll(String collection) =>
      _db.collection(collection).snapshots().map((s) => s.size);

  ({DateTime startThis, DateTime startNext, DateTime startPrev}) monthRanges([DateTime? now]) {
    final n = now ?? DateTime.now();
    final startThis = DateTime(n.year, n.month, 1);
    final startNext = DateTime(n.year, n.month + 1, 1);
    final startPrev = DateTime(n.year, n.month - 1, 1);
    return (startThis: startThis, startNext: startNext, startPrev: startPrev);
  }

  Stream<int> countWhereInRangeStream({
    required String collection,
    required String dateField,
    DateTime? start,
    DateTime? end,
    Map<String, Object?> equals = const {},
  }) {
    Query q = _db.collection(collection);
    for (final e in equals.entries) {
      q = q.where(e.key, isEqualTo: e.value);
    }
    if (start != null) {
      q = q.where(dateField, isGreaterThanOrEqualTo: Timestamp.fromDate(start));
    }
    if (end != null) {
      q = q.where(dateField, isLessThan: Timestamp.fromDate(end));
    }
    return q.snapshots().map((s) => s.size);
  }

  Stream<num> sumInRangeStream({
    required String collection,
    required String amountField,
    required String dateField,
    Map<String, Object?> equals = const {},
    required DateTime start,
    required DateTime end,
  }) {
    Query q = _db.collection(collection);
    for (final e in equals.entries) {
      q = q.where(e.key, isEqualTo: e.value);
    }
    q = q
        .where(dateField, isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where(dateField, isLessThan: Timestamp.fromDate(end));

    return q.snapshots().map(
          (s) => s.docs.fold<num>(0, (t, d) {
        final data = d.data() as Map<String, dynamic>;
        final amount = (data[amountField] ?? 0) as num;
        return t + amount;
      }),
    );
  }

  Stream<List<T>> streamCollection<T>({
    required String collection,
    required DocMapper<T> mapper,
    Map<String, Object?> equals = const {},
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    Query<Map<String, dynamic>> q = _db.collection(collection);

    for (final e in equals.entries) {
      q = q.where(e.key, isEqualTo: e.value);
    }

    if (orderBy != null) {
      q = q.orderBy(orderBy, descending: descending);
    }

    if (limit != null) {
      q = q.limit(limit);
    }

    return q.snapshots().map((s) => s.docs.map(mapper).toList());
  }

  Stream<T?> streamDocument<T>({
    required String collection,
    required String id,
    required DocMapper<T> mapper,
  }) {
    final docRef = _db.collection(collection).doc(id);
    return docRef.snapshots().map((snap) {
      if (!snap.exists) return null;
      return mapper(snap);
    });
  }

  Stream<List<T>> prefixSearchStream<T>({
    required String collection,
    required String field,
    required String prefix,
    required DocMapper<T> mapper,
    int limit = 20,
  }) {
    final start = prefix;
    final end = '$prefix\uf8ff';

    final q = _db.collection(collection).orderBy(field).startAt([start]).endAt([end]).limit(limit);

    return q.snapshots().map((s) => s.docs.map(mapper).toList());
  }

  Future<T?> getDocumentOnce<T>({
    required String collection,
    required String id,
    required DocMapper<T> mapper,
  }) async {
    final doc = await _db.collection(collection).doc(id).get();
    if (!doc.exists) return null;
    return mapper(doc);
  }

  Future<List<T>> getCollectionOnce<T>({
    required String collection,
    required DocMapper<T> mapper,
    Map<String, Object?> equals = const {},
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    Query<Map<String, dynamic>> q = _db.collection(collection);

    for (final e in equals.entries) {
      q = q.where(e.key, isEqualTo: e.value);
    }

    if (orderBy != null) {
      q = q.orderBy(orderBy, descending: descending);
    }

    if (limit != null) {
      q = q.limit(limit);
    }

    final snap = await q.get();
    return snap.docs.map(mapper).toList();
  }
}
