import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

AppTheme lightTheme = AppTheme.light().copyWith(
    id: 'light',
    data: AppTheme.light()
        .data
        .copyWith(inputDecorationTheme: blackInputDecorationTheme));

AppTheme darkTheme = AppTheme.dark().copyWith(
    id: 'dark',
    data: AppTheme.dark()
        .data
        .copyWith(inputDecorationTheme: whiteInputDecorationTheme));

var whiteInputDecorationTheme = InputDecorationTheme(
  contentPadding: EdgeInsets.symmetric(
    horizontal: 6,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.white),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.white),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.white),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.white),
  ),
);

var blackInputDecorationTheme = InputDecorationTheme(
  contentPadding: EdgeInsets.symmetric(
    horizontal: 6,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.black),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.black),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.black),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: Colors.black),
  ),
);