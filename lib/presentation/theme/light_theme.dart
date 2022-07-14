import 'package:flutter/material.dart';
import 'package:gifts_manager/resources/app_colors.dart';

// _base базовая тема из которой копируем в другие наши темы
final _base = ThemeData.light();

final lightTheme = _base.copyWith(
  backgroundColor: AppColors.lightLightBlue100,
);