// ignore_for_file: non_const_argument_for_const_parameter
import 'package:flutter/material.dart';

/// Creates an [IconData] from runtime values persisted in the database.
///
/// Uses a file-level ignore for [non_const_argument_for_const_parameter]
/// because icon codes are dynamic values loaded at runtime, not compile-time
/// constants.
IconData categoryIconData(
  int codePoint, {
  String? fontFamily,
  String? fontPackage,
}) =>
    IconData(
      codePoint,
      fontFamily: fontFamily ?? 'MaterialIcons',
      fontPackage: fontPackage,
    );
