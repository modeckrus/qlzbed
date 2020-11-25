import 'dart:io';
import 'dart:typed_data';

import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart' as fd;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'hive_store.dart';

class FirebaseService {
  static const String projectId = 'testplatform-modeck';
  static const String apiKey = 'AIzaSyACE4LOeZ7e6hg2Q3dPaxDhz4y6n97gjmo';
  static User user;
  static Future<int> init() async {
    final path = Directory.current.path;
    Hive.init(path);

    Hive.registerAdapter(TokenAdapter());
    fd.FirebaseAuth.initialize(apiKey, await HiveStore.create());
    fd.Firestore.initialize(projectId);
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
    return DocumentReference.fromFireDart(fd.Firestore.instance.document(path));
  }

  static CollectionGroup collection(String path) {
    return CollectionGroup(path);
  }

  static CollectionGroup collectionGroup(String name) {}

  static FireStorage storage() {}
}

class FireStorage {
  FireStorageFile child(String path) {
    return FireStorageFile(path);
  }
}

class FireStorageFile {
  final String path;

  FireStorageFile(this.path);
  Future<Uint8List> getData(int size) async {}
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

  dynamic operator [](String key) {}
  DocumentReference get reference {}
}

class DocumentReference {
  final String path;

  CollectionGroup collection(String path) {
    return CollectionGroup(path);
  }

  DocumentReference(this.path);
  Future<DocumentSnapshot> get() async {
    return null;
  }

  factory DocumentReference.fromFireDart(fd.DocumentReference doc) {
    return DocumentReference(doc.fullPath);
  }
  Future<void> updateData(Map<String, dynamic> map, {bool merge}) async {}
  Future<void> setData(Map<String, dynamic> map, {bool merge}) async {}
  Future<void> delete() async {}
}

class QueryReference {
  final String path;

  QueryReference(this.path);
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
    return QueryReference(path);
  }

  QueryReference orderBy(
    String fieldPath, {
    bool descending = false,
  }) {
    return this;
  }

  QueryReference limit(int count) {
    return this;
  }

  Future<List<DocumentSnapshot>> get() {
    return null;
  }

  void _addFilter(
    String fieldPath,
    dynamic value,
  ) {}
  Stream<QuerySnapshot> snapshots() {}
}

class QuerySnapshot {
  final String path;
  List<DocumentSnapshot> documents;
  QuerySnapshot(this.path);
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
    return QueryReference(path);
  }

  QueryReference orderBy(
    String fieldPath, {
    bool descending = false,
  }) {
    return this.reference.orderBy(fieldPath);
  }

  QueryReference limit(int count) {
    return this.reference.limit(count);
  }

  Future<List<DocumentSnapshot>> get() {
    return null;
  }

  void _addFilter(
    String fieldPath,
    dynamic value,
  ) {
    return this.reference._addFilter(fieldPath, value);
  }

  QueryReference get reference {
    return QueryReference(path);
  }
}

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
    return QueryReference(path).where(fieldPath,
        isEqualTo: isEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        isNull: isNull);
  }

  Stream<List<DocumentSnapshot>> snapshots() {}

  /// Returns [CollectionReference] that's additionally sorted by the specified
  /// [fieldPath].
  ///
  /// The field is a [String] representing a single field name.
  /// After a [CollectionReference] order by call, you cannot add any more [orderBy]
  /// calls.
  QueryReference orderBy(String fieldPath, {bool descending = false}) =>
      QueryReference(path).orderBy(fieldPath, descending: descending);

  /// Returns [CollectionReference] that's additionally limited to only return up
  /// to the specified number of documents.
  QueryReference limit(int count) => QueryReference(path).limit(count);

  DocumentReference document(String id) => DocumentReference('$path/$id');

  Future<Page<DocumentSnapshot>> get(
      {int pageSize = 1024, String nextPageToken = ''}) {}

  Stream<List<DocumentSnapshot>> get stream {}

  /// Create a document with a random id.
  Future<DocumentSnapshot> add(Map<String, dynamic> map) {}
}

class CollectionGroup {
  final String path;

  CollectionGroup(this.path);

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
    return QueryReference(path).where(fieldPath,
        isEqualTo: isEqualTo,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        isNull: isNull);
  }

  Stream<List<DocumentSnapshot>> snapshots() {}

  /// Returns [CollectionReference] that's additionally sorted by the specified
  /// [fieldPath].
  ///
  /// The field is a [String] representing a single field name.
  /// After a [CollectionReference] order by call, you cannot add any more [orderBy]
  /// calls.
  QueryReference orderBy(String fieldPath, {bool descending = false}) =>
      QueryReference(path).orderBy(fieldPath, descending: descending);

  /// Returns [CollectionReference] that's additionally limited to only return up
  /// to the specified number of documents.
  QueryReference limit(int count) => QueryReference(path).limit(count);

  DocumentReference document(String id) => DocumentReference('$path/$id');

  Future<Page<DocumentSnapshot>> get(
      {int pageSize = 1024, String nextPageToken = ''}) {}

  Stream<List<DocumentSnapshot>> get stream {}

  /// Create a document with a random id.
  Future<DocumentReference> add(Map<String, dynamic> map) {}
}
