import 'api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Login with email/identifier - sends verification code
  static Future<Map<String, dynamic>> loginWithEmail(
    String identifier, {
    String role = 'Driver',
  }) async {
    try {
      final requestData = {'identifier': identifier, 'role': role};

      final response = await ApiService.request(
        url: 'auth/login/',
        method: 'POST',
        data: requestData,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        open: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data != null && response.data['message'] != null
              ? response.data['message'].toString()
              : 'Код успешно отправлен на email',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': response.data != null && response.data['message'] != null
              ? response.data['message'].toString()
              : 'Не удалось отправить код',
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

  // Login with phone number - sends SMS code
  static Future<Map<String, dynamic>> loginWithPhone(String phoneNumber) async {
    try {
      final requestData = {'phone_number': phoneNumber};

      final response = await ApiService.request(
        url: 'auth/login/',
        method: 'POST',
        data: requestData,
        open: true, // This endpoint doesn't require authentication
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'SMS код успешно отправлен',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'Не удалось отправить SMS код',
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

  // Verify SMS code
  static Future<Map<String, dynamic>> verifyCode(
    String identifier,
    String code, {
    String role = 'Driver',
  }) async {
    try {
      final requestData = {
        'identifier': identifier,
        'sms_code': code,
        'role': role,
      };

      final response = await ApiService.request(
        url: 'auth/check-sms-code/',
        method: 'POST',
        data: requestData,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        open: true, // This endpoint doesn't require authentication
      );
      if (response.statusCode == 200) {
        // Save token if provided
        // Token can be in format: tokens.access or access_token
        String? token;
        if (response.data != null) {
          if (response.data['tokens'] != null && 
              response.data['tokens']['access'] != null) {
            token = response.data['tokens']['access'] as String;
          } else if (response.data['access_token'] != null) {
            token = response.data['access_token'] as String;
          }
        }
        
        if (token != null) {
          ApiService.setMemoryToken(token);
          
          // Save token to localStorage (shared_preferences)
          try {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('access_token', token);
          } catch (e) {
            print('🔴 Error saving token to localStorage: $e');
          }
        } else {
          print('⚠️ No access token found in response');
        }

        return {
          'success': true,
          'message': response.data['message'] ?? 'Код успешно подтвержден',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'Неверный код подтверждения',
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

  // Logout
  static Future<Map<String, dynamic>> logout() async {
    try {
      final response = await ApiService.request(
        url: 'auth/logout/',
        method: 'POST',
      );

      // Clear token from memory
      ApiService.setMemoryToken(null);

      // Clear token from secure storage
      try {
        const storage = FlutterSecureStorage();
        await storage.delete(key: 'access_token');
      } catch (e) {
        print('🔴 Error removing token from secure storage: $e');
      }

      // Clear token from localStorage (shared_preferences)
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
      } catch (e) {
        print('🔴 Error removing token from localStorage: $e');
      }

      return {
        'success': true,
        'message': 'Выход выполнен успешно',
        'data': response.data,
      };
    } catch (e) {
      // Even if API call fails, clear tokens locally
      ApiService.setMemoryToken(null);
      
      try {
        const storage = FlutterSecureStorage();
        await storage.delete(key: 'access_token');
      } catch (e) {
        print('🔴 Error removing token from secure storage: $e');
      }

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
      } catch (e) {
        print('🔴 Error removing token from localStorage: $e');
      }

      return {
        'success': true,
        'message': 'Выход выполнен (локально)',
        'data': null,
      };
    }
  }
}
