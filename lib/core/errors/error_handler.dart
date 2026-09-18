import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ErrorHandler {
  static void showDioError(BuildContext context, DioException e) {
    String message = 'An unexpected error occurred.';
    
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      message = 'Connection timeout. Please check your internet connection or server status.';
    } else if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('error')) {
        message = data['error'];
      } else {
        message = 'Server error (${e.response?.statusCode}). Please try again.';
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}