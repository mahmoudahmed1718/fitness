abstract class DatabaseService {
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });
  Future<void> addDataInsideCollection({
    required String path,
    required String collectionName,
    required Map<String, dynamic> data,
    String? documentId,
  });
  Future<void> getDataInsideCollection({
    required String path,
    required String collectionName,

    required String documentId,
  });
  Future<Map<String, dynamic>> getData({
    required String path,
    required String documentId,
  });
  Future<List<Map<String, dynamic>>> getDataList({
    required String path,
    Map<String, dynamic>? query,
  });
  Future<bool> checkUserExists({
    required String path,
    required String documentId,
  });
}
