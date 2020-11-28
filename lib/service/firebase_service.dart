import 'dart:io';
import 'dart:typed_data';

import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'hive_store.dart';

class FirebaseService {
  static const String projectId = 'education-modeck';
  static const String apiKey = 'AIzaSyCq3t89dA9D19NxINpONcxKGkOYw0CB224';
  static const String bucketId = 'education-modeck.appspot.com';
  static fd.FirebaseAuth auth;
  static User user;
  static fd.FirebaseStorage fbStorage;
  static Future<int> init() async {
    final path = Directory.current.path;
    Hive.init(path);

    Hive.registerAdapter(TokenAdapter());
    auth = fd.FirebaseAuth.initialize(apiKey, await HiveStore.create());
    fd.Firestore.initialize(projectId);
    fbStorage = await fd.FirebaseStorage.getBucket(projectId, bucketId, auth);
    // await FirebaseAuth.instance.signIn('huis@gmail.com', '12345678');
    // user = await FirebaseAuth.instance.getUser();
    return 1;
  }

  static Future<void> login(String email, String password) async {
    try {
      await fd.FirebaseAuth.instance.signIn(email, password);
      user = await fd.FirebaseAuth.instance.getUser();
      print('Login success: ${user.toString()}');
    } catch (e) {
      print('Error login: ${e.toString()}');
    }
  }

  static Future<void> register(String email, String password) async {
    try {
      await fd.FirebaseAuth.instance.signUp(email, password);
      user = await fd.FirebaseAuth.instance.getUser();
      print('Register success: ${user.toString()}');
    } catch (e) {
      print('Error login: ${e.toString()}');
    }
  }

  static DocumentReference document(String path) {
    return DocumentReference(path);
  }

  static Collection collection(String path) {
    return Collection(path);
  }

  // static CollectionGroup collectionGroup(String name) {
  //   return CollectionGroup(name);
  // }

  static FireStorage storage() {
    return FireStorage(
      fbStorage: fbStorage,
    );
  }

  static bool isDesktop() {
    if (Platform.isAndroid || Platform.isIOS) {
      return false;
    } else {
      return true;
    }
  }
}

class FireStorage {
  final fd.FirebaseStorage fbStorage;

  FireStorage({@required this.fbStorage});
  FireStorageFile child(String path) {
    return FireStorageFile(path);
  }
}

class FireStorageFile {
  final String path;

  FireStorageFile(this.path);
  Future<Uint8List> getData(int size) async {
    if (FirebaseService.isDesktop()) {
      await FirebaseService.fbStorage.download(path, './file.txt');
      final file = File('./file.txt');
      return file.readAsBytes();
    }
  }

  Future<void> delete() async {}
  Future<void> putData(Uint8List data) async {}
}

class DocumentSnapshot {
  final String id;

  final String path;

  final DateTime createTime;

  final DateTime updateTime;

  final Map<String, dynamic> map;

  final bool exists;

  Map<String, dynamic> get data => map;

  DocumentSnapshot(
      {@required this.id,
      @required this.path,
      @required this.createTime,
      @required this.updateTime,
      @required this.map,
      @required this.exists});

  dynamic operator [](String key) {
    return map[key];
  }

  DocumentReference get reference {
    return DocumentReference(path);
  }

  factory DocumentSnapshot.fromFireDart(fd.Document doc) {
    return DocumentSnapshot(
      path: doc.path,
      id: doc.id,
      createTime: doc.createTime,
      updateTime: doc.updateTime,
      map: doc.map,
      // exists: doc.reference.exists,
      exists: doc.map == null ? false : true,
    );
  }
  Future<void> updateData(Map<String, dynamic> map, {bool merge}) async {
    return reference.updateData(map);
  }

  Future<void> setData(Map<String, dynamic> map, {bool merge}) async {
    return reference.setData(map);
  }

  Future<void> delete() async {
    return reference.delete();
  }
}

class DocumentReference {
  final String path;

  Collection collection(String newpath) {
    return Collection('$path/$newpath');
  }

  DocumentReference(this.path);
  Future<DocumentSnapshot> get() async {
    if (FirebaseService.isDesktop()) {
      final docsnap = await fd.Firestore.instance.document(path).get();
      return DocumentSnapshot.fromFireDart(docsnap);
    }
  }

  factory DocumentReference.fromFireDart(fd.DocumentReference doc) {
    return DocumentReference(doc.path);
  }
  Future<void> updateData(Map<String, dynamic> map, {bool merge}) async {
    if (FirebaseService.isDesktop()) {
      await fd.Firestore.instance.document(path).update(map);
    }
  }

  Future<void> setData(Map<String, dynamic> map, {bool merge}) async {
    if (FirebaseService.isDesktop()) {
      await fd.Firestore.instance.document(path).set(map);
    }
  }

  Future<void> delete() async {
    if (FirebaseService.isDesktop()) {
      await fd.Firestore.instance.document(path).delete();
    }
  }
}

class QueryReference {
  // final String path;
  final fd.QueryReference fdQurry;

  QueryReference({
    @required this.fdQurry,
  });
  QueryReference where(
    String fieldPath, {
    dynamic isEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
    dynamic arrayContains,
    List<dynamic> arrayContainsAny,
    List<dynamic> whereIn,
    bool isNull = false,
  }) {
    return QueryReference(
        fdQurry: fdQurry.where(fieldPath,
            isEqualTo: isEqualTo,
            isLessThan: isLessThan,
            isGreaterThan: isGreaterThan,
            isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
            isLessThanOrEqualTo: isLessThanOrEqualTo,
            isNull: isNull));
  }

  QueryReference orderBy(
    String fieldPath, {
    bool descending = false,
  }) {
    return QueryReference(
        fdQurry: fdQurry.orderBy(fieldPath, descending: descending));
  }

  QueryReference limit(int count) {
    return QueryReference(fdQurry: fdQurry.limit(count));
  }

  Future<List<DocumentSnapshot>> get() async {
    if (FirebaseService.isDesktop()) {
      return (await fdQurry.get()).map((e) => DocumentSnapshot.fromFireDart(e));
    }
  }

  void _addFilter(
    String fieldPath,
    dynamic value,
  ) {}
  // Stream<List<DocumentSnapshot>> snapshots() {
  //   if (FirebaseService.isDesktop()) {
  //     yield (fdQurry.  .map((e) => DocumentSnapshot.fromFireDart(e));
  //   }
  // }
}

// class QuerySnapshot {
//   final String path;
//   List<DocumentSnapshot> documents;
//   final fd.QueryReference fdQuery;
//   QuerySnapshot(this.path, {@required this.fdQuery});
//   QueryReference where(
//     String fieldPath, {
//     dynamic isEqualTo,
//     dynamic isLessThan,
//     dynamic isLessThanOrEqualTo,
//     dynamic isGreaterThan,
//     dynamic isGreaterThanOrEqualTo,
//     dynamic arrayContains,
//     List<dynamic> arrayContainsAny,
//     List<dynamic> whereIn,
//     bool isNull = false,
//   }) {
//     return reference.
//   }

//   QueryReference orderBy(
//     String fieldPath, {
//     bool descending = false,
//   }) {
//     return this.reference.orderBy(fieldPath);
//   }

//   QueryReference limit(int count) {
//     return this.reference.limit(count);
//   }

//   Future<List<DocumentSnapshot>> get() async {
//     if (FirebaseService.isDesktop()) {
//       // fd.Firestore.instance.collection(path).limit(count)
//       return (await fdQuery.get())
//           .map((doc) => DocumentSnapshot.fromFireDart(doc));
//     }
//     return null;
//   }

//   QueryReference get reference {
//     return QueryReference(

//     );
//   }
// }

class Collection {
  final String path;

  Collection(this.path);

  QueryReference where(
    String fieldPath, {
    dynamic isEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
    dynamic arrayContains,
    List<dynamic> arrayContainsAny,
    List<dynamic> whereIn,
    bool isNull = false,
  }) {
    return QueryReference(
        fdQurry: fd.Firestore.instance.collection(path).where(fieldPath,
            isEqualTo: isEqualTo,
            isLessThan: isLessThan,
            isLessThanOrEqualTo: isLessThanOrEqualTo,
            isGreaterThan: isGreaterThan,
            isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
            arrayContains: arrayContains,
            arrayContainsAny: arrayContainsAny,
            whereIn: whereIn,
            isNull: isNull));
  }

  Stream<List<DocumentSnapshot>> snapshots() {
    return stream;
  }

  /// Returns [CollectionReference] that's additionally sorted by the specified
  /// [fieldPath].
  ///
  /// The field is a [String] representing a single field name.
  /// After a [CollectionReference] order by call, you cannot add any more [orderBy]
  /// calls.
  QueryReference orderBy(String fieldPath, {bool descending = false}) =>
      QueryReference(
          fdQurry: fd.Firestore.instance
              .collection(path)
              .orderBy(fieldPath, descending: descending));

  /// Returns [CollectionReference] that's additionally limited to only return up
  /// to the specified number of documents.
  QueryReference limit(int count) => QueryReference(
      fdQurry: fd.Firestore.instance.collection(path).limit(count));

  DocumentReference document(String id) => DocumentReference('$path/$id');

  Future<List<DocumentSnapshot>> get(
      {int pageSize = 1024, String nextPageToken = ''}) async {
    if (FirebaseService.isDesktop()) {
      final fd.Page<fd.Document> sfd = await fd.Firestore.instance
          .collection(path)
          .get(pageSize: pageSize, nextPageToken: nextPageToken);
      List<DocumentSnapshot> docs = List();
      sfd.forEach((element) {
        print(element);
        docs.add(DocumentSnapshot.fromFireDart(element));
      });
      return docs;
    }
  }

  Stream<List<DocumentSnapshot>> get stream {
    if (FirebaseService.isDesktop()) {
      return fd.Firestore.instance
          .collection(path)
          .stream
          .map((list) => list.map((doc) => DocumentSnapshot.fromFireDart(doc)));
    }
  }

  /// Create a document with a random id.
  Future<DocumentReference> add(Map<String, dynamic> map) async {
    if (FirebaseService.isDesktop()) {
      final doc = await fd.Firestore.instance.document(path).create(map);
      DocumentSnapshot docsnap = DocumentSnapshot.fromFireDart(doc);
      return docsnap.reference;
    }
  }
}

// class CollectionGroup {
//   final String path;

//   CollectionGroup(this.path);

//   QueryReference where(
//     String fieldPath, {
//     dynamic isEqualTo,
//     dynamic isLessThan,
//     dynamic isLessThanOrEqualTo,
//     dynamic isGreaterThan,
//     dynamic isGreaterThanOrEqualTo,
//     dynamic arrayContains,
//     List<dynamic> arrayContainsAny,
//     List<dynamic> whereIn,
//     bool isNull = false,
//   }) {
//     return QueryReference(fdQurry: fd.Firestore.instance.collection(path).where(
//     fieldPath: fieldPath,
//      isEqualTo,
//     dynamic isLessThan,
//     dynamic isLessThanOrEqualTo,
//     dynamic isGreaterThan,
//     dynamic isGreaterThanOrEqualTo,
//     dynamic arrayContains,
//     List<dynamic> arrayContainsAny,
//     List<dynamic> whereIn,
//     bool isNull = false,
//   ));
//   }

//   Stream<List<DocumentSnapshot>> snapshots() {}

//   /// Returns [CollectionReference] that's additionally sorted by the specified
//   /// [fieldPath].
//   ///
//   /// The field is a [String] representing a single field name.
//   /// After a [CollectionReference] order by call, you cannot add any more [orderBy]
//   /// calls.
//   QueryReference orderBy(String fieldPath, {bool descending = false}) =>
//       QueryReference(path).orderBy(fieldPath, descending: descending);

//   /// Returns [CollectionReference] that's additionally limited to only return up
//   /// to the specified number of documents.
//   QueryReference limit(int count) => QueryReference(path).limit(count);

//   DocumentReference document(String id) => DocumentReference('$path/$id');

//   Future<Page<DocumentSnapshot>> get(
//       {int pageSize = 1024, String nextPageToken = ''}) {}

//   Stream<List<DocumentSnapshot>> get stream {}

//   /// Create a document with a random id.
//   Future<DocumentReference> add(Map<String, dynamic> map) {}
// }
