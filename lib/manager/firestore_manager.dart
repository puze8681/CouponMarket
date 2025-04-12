import 'dart:developer';

import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/auth_manager.dart';
import 'package:coupon_market/model/notification_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_market/model/store.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

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

  Future<(List<Store>, DocumentSnapshot?)> getStoreList({
    required int limit,
    DocumentSnapshot? lastDocument,
    int? cityId,
    int? districtId,
    List<int>? categories,
  }); // result

  Future<String?> useCoupon(Store store); // result
  Future<String?> downloadCoupon(Store store); // result
  Future<(List<Store>, DocumentSnapshot?)> getCouponStoreList(int limit, DocumentSnapshot? lastDocument); // result

  Future<void> postNotification(NotificationData notification); // notification
  Future<(List<NotificationData>, DocumentSnapshot?)> getNotificationList(int limit, DocumentSnapshot? lastDocument); // notification
  Future<void> patchNotification(NotificationData notification); // result
}

class FireStoreManager extends FireStoreService {
  var uuid = const Uuid();
  // {STORE_ID}/{DEVICE_ID}/versions/{VERSION}/{DOC_NAME}/
  var instance = firebaseManager.firestoreInstance;
  var userCollection = firebaseManager.firestoreInstance.collection('user');
  var storeCollection = firebaseManager.firestoreInstance.collection('store');
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
  Future<(List<Store>, DocumentSnapshot?)> getStoreList({
    required int limit,
    DocumentSnapshot? lastDocument,
    int? cityId,
    int? districtId,
    List<int>? categories,
  }) async {
    // 쿼리 시작
    Query query = FirebaseFirestore.instance
        .collection('store')
        .orderBy('createdAt', descending: true);

    // 필터 적용
    if (cityId != null) {
      query = query.where('city', isEqualTo: cityId);
    }

    if (districtId != null) {
      query = query.where('district', isEqualTo: districtId);
    }

    // 카테고리 필터 적용
    if (categories != null && categories.isNotEmpty) {
      final limitedCategories = categories.length > 10
          ? categories.sublist(0, 10)
          : categories;

      query = query.where('category', arrayContainsAny: limitedCategories);
    }

    // 결과 제한
    query = query.limit(limit);

    // 이전 페이지가 있는 경우
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    // 데이터 가져오기
    final querySnapshot = await query.get();

    // 결과가 없는 경우 빈 리스트 반환
    if (querySnapshot.docs.isEmpty) {
      return ([] as List<Store>, null);
    }

    // 문서들을 Store 객체로 변환
    final resultList = querySnapshot.docs.map((doc) {
      return Store.fromFirestore(doc);
    }).toList();

    // 마지막 문서 찾기
    final lastDoc = querySnapshot.docs.isNotEmpty
        ? querySnapshot.docs.last
        : null;

    return (resultList, lastDoc);
  }

  @override
  // 쿠폰 사용 함수 (로직 업데이트)
  Future<String?> useCoupon(Store store) async {
    try {
      // 트랜잭션 시작
      return await instance.runTransaction<String?>((transaction) async {
        // 1. 매장 정보 조회
        final storeDocRef = storeCollection.doc(store.id);
        final storeDoc = await transaction.get(storeDocRef);

        if (!storeDoc.exists) {
          return '"매장 데이터를 불리오는데 실패했습니다. 앱을 다시 실행해주세요';
        }

        // 2. 매장 쿠폰 재고 확인
        final storeData = storeDoc.data() as Map<String, dynamic>;
        final couponExistCount = storeData['couponExistCount'] as int;

        if (couponExistCount <= 0) {
          return '쿠폰 재고가 소진되었습니다.';
        }

        // 3. 쿠폰 재고 감소
        transaction.update(storeDocRef, {'couponExistCount': couponExistCount - 1});

        // 4. 사용 내역을 저장할 참조
        final historyDocRef = userCollection.doc(authManager.userId).collection('histories').doc();
        transaction.set(historyDocRef, store.useCoupon().toJson());

        // 성공 시 null 반환 (에러 없음)
        return null;
      });
    } catch (e) {
      return '쿠폰 사용 중 오류가 발생했습니다: ${e.toString()}';
    }
  }

  Future<Store?> getStore({required String storeId}) async {
    try {
      // Firestore에서 매장 문서 조회
      final DocumentSnapshot storeDoc = await storeCollection
          .doc(storeId)
          .get();

      // 문서가 존재하지 않는 경우 null 반환
      if (!storeDoc.exists) {
        return null;
      }

      // 문서가 존재하면 Store 객체로 변환하여 반환
      return Store.fromFirestore(storeDoc);
    } catch (e) {
      // 오류 발생 시 로그 기록
      print('Error fetching store: $e');
      return null;
    }
  }

  @override
  Future<String?> downloadCoupon(Store store) async {
    try{
      final ref = userCollection.doc(authManager.userId).collection("stores").doc(store.id);
      final existingDoc = await ref.get();
      if (existingDoc.exists) {
        return "이미 발급된 쿠폰입니다"; // 이미 다운로드한 쿠폰
      }else{
        await ref.set(store.toJson());
        return null;
      }
    }catch (e) {
      return "오류가 발생했습니다. 다시 시도해주세요 (${e.toString()})";
    }
  }

  @override
  Future<(List<Store>, DocumentSnapshot?)> getCouponStoreList(int limit, DocumentSnapshot? lastDocument) async {
    // 쿼리 시작
    Query query = dataCollection
        .doc(authManager.user.uid)
        .collection('stores')
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
      return (List<Store>.from([]), null);
    }

    // 문서들을 Notification 객체로 변환
    final resultList = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Store.fromJson(data);
    }).toList();

    return (resultList, querySnapshot.docs.lastOrNull);
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
