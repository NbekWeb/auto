import 'api.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/navigator_key.dart';

class UserService {
  // Get user profile data
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await ApiService.request(
        url: 'auth/user/',
        method: 'GET',
      );

      if (response.statusCode == 200 && response.data != null) {
        return {'success': true, 'data': response.data};
      } else {
        return {
          'success': false,
          'message': 'Не удалось загрузить профиль',
          'error': response.data,
        };
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          // Clear token from secure storage and memory
          try {
            ApiService.setMemoryToken(null);
          } catch (clearError) {
            print('🔴 Error clearing token: $clearError');
          }

          // Clear token from localStorage (shared_preferences)
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('access_token');
          } catch (clearError) {
            print('🔴 Error removing token from localStorage: $clearError');
          }

          // Navigate to login page
          if (navigatorKey.currentState != null) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }

          return {
            'success': false,
            'message': 'Требуется авторизация',
            'error': e.response?.data ?? e.toString(),
          };
        }
      }

      return {
        'success': false,
        'message': 'Ошибка сети. Попробуйте позже.',
        'error': e.toString(),
      };
    }
  }

  // Update user profile data
  static Future<Map<String, dynamic>> updateUserProfile({
    String? firstName,
    String? lastName,
    String? address,
    String? phoneNumber,
    Uint8List? avatarBytes,
  }) async {
    try {
      Map<String, dynamic> data = {};

      if (firstName != null) {
        data['first_name'] = firstName;
      }
      if (lastName != null) {
        data['last_name'] = lastName;
      }
      if (address != null) {
        data['address'] = address;
      }
      if (phoneNumber != null) {
        data['phone_number'] = phoneNumber;
      }

      Response response;

      // If avatar is provided, use uploadFile method (form data)
      if (avatarBytes != null) {
        data['avatar'] = avatarBytes;
        response = await ApiService.uploadFile(
          url: 'auth/user/',
          method: 'PATCH',
          data: data,
        );
      } else {
        // Otherwise use regular request (JSON)
        response = await ApiService.request(
          url: 'auth/user/',
          method: 'PATCH',
          data: data,
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Профиль успешно обновлен',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': response.data != null && response.data['message'] != null
              ? response.data['message'].toString()
              : 'Не удалось обновить профиль',
          'error': response.data,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Ошибка сети. Попробуйте позже.',
        'error': e.toString(),
      };
    }
  }
}
