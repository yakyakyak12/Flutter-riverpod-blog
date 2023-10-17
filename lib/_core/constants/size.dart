import 'package:flutter/material.dart';

const double smallGap = 5.0;
const double mediumGap = 10.0;
const double largeGap = 20.0;
const double xlargeGap = 100.0;

// 휴대폰의 넓이
double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// 눌렀을때 쓰로우 되는 애들 (비율로 정의해서 화면마다 비슷하게)
double getDrawerWidth(BuildContext context) {
  return getScreenWidth(context) * 0.6;
}
