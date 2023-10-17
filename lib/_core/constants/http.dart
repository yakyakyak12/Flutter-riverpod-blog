import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// http 통신을 위한 것
final dio = Dio(
  BaseOptions(
    baseUrl: "http://192.168.0.40:8080", // 내 IP 입력
    contentType: "application/json; charset=utf-8",
  ),
);

// 휴대폰 로컬에 파일로 저장
const secureStorage = FlutterSecureStorage(); // 토큰 확인후 유효하면 저동 로그인
