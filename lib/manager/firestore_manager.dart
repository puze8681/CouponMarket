import 'dart:developer';
import 'dart:io';

import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/auth_manager.dart';
import 'package:coupon_market/model/notification_data.dart';
import 'package:coupon_market/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

FireStoreService fireStoreManager = FireStoreManager();
abstract class FireStoreService {
  Future<void> setUser(String uid, String email, String name, String number); // user
  Future<bool> isUserExist(String uid);
  Future<String> getUserNumber(String uid);
  Future<String?> getEmail(String name, String number); // user
  Future<bool> getUserExist(String email); // user
  Future<void> deleteUser();

  Future<void> addCategory(String category); // category
  Future<List<String>> getCategoryList(); // category
  Future<void> deleteCategory(String category); // category

  Future<String> uploadImage(File image);
  Future<void> postTestResult(TestResult result); // result
  Future<TestResult?> getTestResult(String id); // result
  Future<(List<TestResult>, DocumentSnapshot?)> getTestResultList(int limit, DocumentSnapshot? lastDocument); // result
  Future<void> patchTestResult(TestResult result); // result
  Future<void> deleteTestResult(String category); // result

  Future<void> postNotification(NotificationData notification); // notification
  Future<(List<NotificationData>, DocumentSnapshot?)> getNotificationList(int limit, DocumentSnapshot? lastDocument); // notification
  Future<void> patchNotification(NotificationData notification); // result
}

class FireStoreManager extends FireStoreService {
  var uuid = const Uuid();
  // {STORE_ID}/{DEVICE_ID}/versions/{VERSION}/{DOC_NAME}/
  var userCollection = firebaseManager.firestoreInstance.collection('user');
  var dataCollection = firebaseManager.firestoreInstance.collection('data');

  @override
  Future<void> setUser(String uid, String email, String name, String number) async {
    authManager.setNumber(number);
    await userCollection.doc(uid).set({
      "email": email,
      "name": name,
      "number": number,
    });
  }

  @override
  Future<bool> isUserExist(String uid) async {
    var doc = userCollection.doc(uid);
    var snapshot = await doc.get();
    return snapshot.data() != null;
  }

  @override
  Future<String> getUserNumber(String uid) async {
    var doc = userCollection.doc(uid);
    var snapshot = await doc.get();
    var data = snapshot.data() ?? {};
    return data["number"] ?? "";
  }

  @override
  Future<String?> getEmail(String name, String number) async {
    var doc = userCollection.where("name", isEqualTo: name).where("number", isEqualTo: number);
    var querySnapshot = await doc.get();
    var snapshotList = querySnapshot.docs;
    if(snapshotList.isNotEmpty){
      var data = snapshotList[0].data();
      var email = data["email"] as String?;
      return email;
    }else{
      return null;
    }
  }

  @override
  Future<bool> getUserExist(String email) async {
    var doc = userCollection.where("email", isEqualTo: email);
    var querySnapshot = await doc.get();
    var snapshotList = querySnapshot.docs;
    if(snapshotList.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  @override
  Future<void> deleteUser() async {
    await userCollection.doc(authManager.user.uid).delete();
    await dataCollection.doc(authManager.user.uid).delete();
  }

  @override
  Future<void> addCategory(String category) async {
    try{
      await dataCollection.doc(authManager.user.uid).update({
        'categories': FieldValue.arrayUnion([category]),
      });
    } on FirebaseException catch (e) {
      log(e.toString());
      if(e.code == "not-found"){
        await dataCollection.doc(authManager.user.uid).set({
          'categories': [category],
        });
      }else{
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getCategoryList() async {
    final doc = await dataCollection.doc(authManager.user.uid).get();
    return List<String>.from(doc.data()?['categories'] ?? []);
  }

  @override
  Future<void> deleteCategory(String category) async {
    try{
      await dataCollection.doc(authManager.user.uid).update({
        'categories': FieldValue.arrayRemove([category]),
      });
    } on FirebaseException catch (e) {
      if(e.code == "not-found"){
        await dataCollection.doc(authManager.user.uid).set({
          'categories': List<String>.from([]),
        });
      }else{
        rethrow;
      }
    } catch (e) {
      rethrow;
    }


  }

  @override
  Future<String> uploadImage(File image) async {
    try {
      // 파일명을 현재 시간을 기반으로 생성
      String fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';

      // Storage에 업로드할 경로 지정
      Reference storageRef = firebaseManager.storageInstance.ref().child('images/$fileName');

      // 파일 업로드 시작
      UploadTask uploadTask = storageRef.putFile(image);

      // 업로드 완료 대기 및 결과 받기
      TaskSnapshot snapshot = await uploadTask;

      // 업로드된 파일의 다운로드 URL 받기
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('이미지 업로드 실패: $e');
    }
  }

  @override
  Future<void> postTestResult(TestResult result) async {
    await dataCollection.doc(authManager.user.uid).collection("results").doc(result.id).set(result.toJson());
  }

  Future<TestResult?> getTestResult(String id) async {
    var doc = await dataCollection.doc(authManager.user.uid).collection("results").doc(id).get();
    if(doc.exists){
      final data = doc.data() as Map<String, dynamic>;
      return TestResult.fromJson(data);
    }else{
      return null;
    }
  }

  @override
  Future<(List<TestResult>, DocumentSnapshot?)> getTestResultList(int limit, DocumentSnapshot? lastDocument) async {
    // 쿼리 시작
    Query query = dataCollection
        .doc(authManager.user.uid)
        .collection('results')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    // 이전 페이지가 있는 경우
    if (lastDocument != null) {
      query = query.startAfter([lastDocument]);
    }

    // 데이터 가져오기
    final querySnapshot = await query.get();

    // 결과가 없는 경우 빈 리스트 반환
    if (querySnapshot.docs.isEmpty) {
      return (List<TestResult>.from([]), null);
    }

    // 문서들을 Notification 객체로 변환
    final resultList = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return TestResult.fromJson(data);
    }).toList();

    return (resultList, querySnapshot.docs.lastOrNull);
  }

  @override
  Future<void> patchTestResult(TestResult result) async {
    await dataCollection.doc(authManager.user.uid).collection("results").doc(result.id).set(result.toJson());
  }

  @override
  Future<void> deleteTestResult(String category) async {
    var doc = dataCollection.doc(authManager.user.uid).collection("results").where("category", isEqualTo: category);
    var querySnapshot = await doc.get();
    var snapshotList = querySnapshot.docs;

    final batch = firebaseManager.firestoreInstance.batch();
    for(int i = 0; i < snapshotList.length; i++){
      var snapShot = snapshotList[i];
      batch.delete(snapShot.reference);
    }

    await batch.commit();
  }

  @override
  Future<void> postNotification(NotificationData notification) async {
    await dataCollection.doc(authManager.user.uid).collection("notifications").doc(notification.id.toString()).set(notification.toJson());
  }

  @override
  Future<(List<NotificationData>, DocumentSnapshot?)> getNotificationList(int limit, DocumentSnapshot? lastDocument) async {
    // 쿼리 시작
    Query query = dataCollection
        .doc(authManager.user.uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .limit(limit);

    // 이전 페이지가 있는 경우
    if (lastDocument != null) {
      query = query.startAfter([lastDocument]);
    }

    // 데이터 가져오기
    final querySnapshot = await query.get();

    // 결과가 없는 경우 빈 리스트 반환
    if (querySnapshot.docs.isEmpty) {
      return (List<NotificationData>.from([]), null);
    }

    // 문서들을 Notification 객체로 변환
    final notificationList = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return NotificationData.fromJson(data);
    }).toList();

    return (notificationList, querySnapshot.docs.lastOrNull);
  }

  @override
  Future<void> patchNotification(NotificationData notification) async {
    await dataCollection.doc(authManager.user.uid).collection("notifications").doc(notification.id.toString()).set(notification.toJson());
  }
}
