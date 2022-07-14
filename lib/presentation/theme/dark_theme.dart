import 'package:flutter/material.dart';
import 'package:gifts_manager/resources/app_colors.dart';

// _base базовая тема из которой копируем в другие наши темы
final _base = ThemeData.dark();

final darkTheme = _base.copyWith(
  backgroundColor: AppColors.darkBlack100,
);