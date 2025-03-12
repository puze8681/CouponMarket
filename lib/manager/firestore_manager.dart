import 'dart:developer';
import 'dart:io';

import 'package:coupon_market/manager/firebase_manager.dart';
import 'package:coupon_market/manager/auth_manager.dart';
import 'package:coupon_market/model/coupon.dart';
import 'package:coupon_market/model/notification_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_market/model/store.dart';
import 'package:coupon_market/model/user_coupon.dart';
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

  Future<(List<Store>, DocumentSnapshot?)> getStoreList({
    required int limit,
    DocumentSnapshot? lastDocument,
    int? cityId,
    int? districtId,
    List<int>? categories,
  }); // result
  Future<Store?> getStore({required String storeId}); // result
  Future<(List<Coupon>, DocumentSnapshot?)> getCouponList({
    required int limit,
    DocumentSnapshot? lastDocument,
    int? cityId,
    int? districtId,
    List<int>? categories,
  }); // r
  
  Future<String> uploadImage(File image);
  Future<String?> useCoupon(Coupon coupon); // result
  Future<String?> downloadCoupon(Coupon coupon); // result
  Future<UserCoupon?> getUserCoupon(String id); // result
  Future<(List<UserCoupon>, DocumentSnapshot?)> getUserCouponList(int limit, DocumentSnapshot? lastDocument); // result
  Future<void> patchUserCoupon(UserCoupon result); // result
  Future<void> deleteUserCoupon(String category); // result

  Future<void> postNotification(NotificationData notification); // notification
  Future<(List<NotificationData>, DocumentSnapshot?)> getNotificationList(int limit, DocumentSnapshot? lastDocument); // notification
  Future<void> patchNotification(NotificationData notification); // result
}

class FireStoreManager extends FireStoreService {
  var uuid = const Uuid();
  // {STORE_ID}/{DEVICE_ID}/versions/{VERSION}/{DOC_NAME}/
  var instance = firebaseManager.firestoreInstance;
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
  Future<Store?> getStore({required String storeId}) async {
    try {
      // Firestore에서 매장 문서 조회
      final DocumentSnapshot storeDoc = await FirebaseFirestore.instance
          .collection('store')
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
  Future<(List<Coupon>, DocumentSnapshot?)> getCouponList({
    required int limit,
    DocumentSnapshot? lastDocument,
    int? cityId,
    int? districtId,
    List<int>? categories,
  }) async {
    // 쿼리 시작
    Query query = instance
        .collection('coupon')
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
      return ([] as List<Coupon>, null);
    }

    // 문서들을 Coupon 객체로 변환
    final resultList = querySnapshot.docs.map((doc) {
      return Coupon.fromFirestore(doc);
    }).toList();

    // 마지막 문서 찾기
    final lastDoc = querySnapshot.docs.isNotEmpty
        ? querySnapshot.docs.last
        : null;

    return (resultList, lastDoc);
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
  // 쿠폰 사용 함수 (로직 업데이트)
  Future<String?> useCoupon(Coupon coupon) async {
    try {
      // 트랜잭션 시작
      return await instance.runTransaction<String?>((transaction) async {
        // 1. 쿠폰 재고 확인
        final couponDocRef = instance.collection('coupon').doc(coupon.id);
        final couponDoc = await transaction.get(couponDocRef);

        if (!couponDoc.exists) {
          return '존재하지 않는 쿠폰입니다.';
        }

        // 쿠폰 데이터 가져오기
        final couponData = couponDoc.data() as Map<String, dynamic>;
        final currentStock = couponData['stock'] as int;

        // 재고 확인
        if (currentStock <= 0) {
          return '쿠폰 재고가 소진되었습니다.';
        }

        // 쿠폰 만료 여부 확인
        final now = DateTime.now();
        if (now.isAfter(coupon.useEndAt)) {
          return '만료된 쿠폰입니다.';
        }

        if (now.isBefore(coupon.useStartAt)) {
          return '아직 사용 가능한 기간이 아닙니다.';
        }

        // 2. 쿠폰 재고 감소
        transaction.update(couponDocRef, {'stock': currentStock - 1});

        // 3. 사용자의 쿠폰 소유 여부 확인
        final userCouponQuery = await userCollection.doc(authManager.userId)
            .collection('coupons')
            .where('couponId', isEqualTo: coupon.id)
            .limit(1)
            .get();

        // 사용 내역을 저장할 참조
        final userCouponDocRef = userCollection.doc(authManager.userId).collection('coupons').doc();

        if (userCouponQuery.docs.isNotEmpty) { // 4. UserCoupon이 존재하는 경우
          final userCouponDoc = userCouponQuery.docs.first;
          final userCouponData = userCouponDoc.data();
          final userCoupon = UserCoupon.fromJson(userCouponData);
          transaction.set(userCouponDocRef, userCoupon.use().toJson());
        } else {  // 5. UserCoupon이 존재하지 않는 경우 Coupon으로부터 새 UserCoupon 생성 후 use() 호출하여 History에 저장
          transaction.set(userCouponDocRef, coupon.download.use().toJson());
        }

        // 성공 시 null 반환 (에러 없음)
        return null;
      });
    } catch (e) {
      return '쿠폰 사용 중 오류가 발생했습니다: ${e.toString()}';
    }
  }

  @override
  Future<String?> downloadCoupon(Coupon coupon) async {
    try{
      final couponRef = dataCollection.doc(authManager.userId).collection("coupons").doc(coupon.id);
      final existingDoc = await couponRef.get();
      if (existingDoc.exists) {
        return "이미 발급된 쿠폰입니다"; // 이미 다운로드한 쿠폰
      }else{
        await couponRef.set(coupon.download.toJson());
        return null;
      }
    }catch (e) {
      return "오류가 발생했습니다. 다시 시도해주세요 (${e.toString()})";
    }
  }

  @override
  Future<UserCoupon?> getUserCoupon(String id) async {
    var doc = await dataCollection.doc(authManager.user.uid).collection("coupons").doc(id).get();
    if(doc.exists){
      final data = doc.data() as Map<String, dynamic>;
      return UserCoupon.fromJson(data);
    }else{
      return null;
    }
  }

  @override
  Future<(List<UserCoupon>, DocumentSnapshot?)> getUserCouponList(int limit, DocumentSnapshot? lastDocument) async {
    // 쿼리 시작
    Query query = dataCollection
        .doc(authManager.user.uid)
        .collection('coupons')
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
      return (List<UserCoupon>.from([]), null);
    }

    // 문서들을 Notification 객체로 변환
    final resultList = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return UserCoupon.fromJson(data);
    }).toList();

    return (resultList, querySnapshot.docs.lastOrNull);
  }

  @override
  Future<void> patchUserCoupon(UserCoupon result) async {
    await dataCollection.doc(authManager.user.uid).collection("results").doc(result.id).set(result.toJson());
  }

  @override
  Future<void> deleteUserCoupon(String category) async {
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
