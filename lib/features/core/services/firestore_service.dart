import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/features/core/services/data_base_service.dart';

class FirestoreService implements DatabaseService {
  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    if (documentId != null) {
      await FirebaseFirestore.instance
          .collection(path)
          .doc(documentId)
          .set(data);
    } else {
      await FirebaseFirestore.instance.collection(path).add(data);
    }
  }

  @override
  Future<Map<String, dynamic>> getData({
    required String path,
    required String documentId,
  }) async {
    var data = await FirebaseFirestore.instance
        .collection(path)
        .doc(documentId)
        .get();
    return data.data() as Map<String, dynamic>;
  }

  @override
  Future<bool> checkUserExists({
    required String path,
    required String documentId,
  }) async {
    var doc = await FirebaseFirestore.instance
        .collection(path)
        .doc(documentId)
        .get();
    return doc.exists;
  }

  @override
  Future<List<Map<String, dynamic>>> getDataList({
    required String path,
    Map<String, dynamic>? query,
  }) async {
    // ignore: unused_local_variable
    var snapshot = await FirebaseFirestore.instance.collection(path).get();
    Query<Map<String, dynamic>> data = FirebaseFirestore.instance.collection(
      path,
    );
    if (query != null) {
      if (query['orderBy'] != null) {
        var orderBy = query['orderBy'];
        var descending = query['descending'];
        data = data.orderBy(orderBy, descending: descending);
      }
    }
    var result = await data.get();
    return result.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> addDataInsideCollection({
    required String path,
    required String collectionName,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(path)
          .doc(documentId)
          .collection(collectionName)
          .add(data);
    } catch (e) {
      throw Exception('Failed to add data inside collection: $e');
    }
  }

  @override
  Future<void> getDataInsideCollection({
    required String path,
    required String collectionName,
    required String documentId,
  }) {
    try {
      var snapshot = FirebaseFirestore.instance
          .collection(path)
          .doc(documentId)
          .collection(collectionName)
          .get();
      return snapshot;
    } catch (e) {
      throw Exception('Failed to get data inside collection: $e');
    }
  }
}
