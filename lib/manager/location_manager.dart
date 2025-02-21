import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationManager {

  // 위치 권한 확인 및 요청
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // 현재 위치의 주소 가져오기
  Future<String> getCurrentAddress() async {
    try {
      // 위치 권한 확인
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        return '위치 권한이 필요합니다.';
      }

      // 현재 위치 좌표 가져오기
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 좌표를 주소로 변환
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return place.street ?? 'Unknown Place';
      }

      return '주소를 찾을 수 없습니다.';
    } catch (e) {
      return '오류가 발생했습니다: $e';
    }
  }
}