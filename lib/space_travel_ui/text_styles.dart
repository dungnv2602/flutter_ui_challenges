import 'package:flutter/material.dart';

const baseTextStyle = TextStyle(fontFamily: 'Poppins');

final smallTextStyle = commonTextStyle.copyWith(
  fontSize: 9.0,
);

final commonTextStyle = baseTextStyle.copyWith(
    color: const Color(0xffb6b2df),
    fontSize: 14.0,
    fontWeight: FontWeight.w400);

final titleTextStyle = baseTextStyle.copyWith(
    color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w600);

final headerTextStyle = baseTextStyle.copyWith(
    color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w400);
