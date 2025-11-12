import 'api.dart';

class AuthService {
  // Login with email/identifier - sends verification code
  static Future<Map<String, dynamic>> loginWithEmail(
    String identifier, {
    String role = 'Driver',
  }) async {
    print('🔵 AuthService.loginWithEmail called with: $identifier, role: $role');
    try {
      final requestData = {
        'identifier': identifier,
        'role': role,
      };
      print('🔵 Request data: $requestData');

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

      print('🔵 Response status code: ${response.statusCode}');
      print('🔵 Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': response.data != null && response.data['message'] != null
              ? response.data['message'].toString()
              : 'Код успешно отправлен на email',
          'data': response.data,
        };
      } else {
        print('🔴 Login with email failed with status: ${response.statusCode}');
        print('🔴 Error response: ${response.data}');
        return {
          'success': false,
          'message': response.data != null && response.data['message'] != null
              ? response.data['message'].toString()
              : 'Не удалось отправить код',
          'error': response.data,
        };
      }
    } catch (e) {
      print('🔴 Login with email exception: $e');
      print('🔴 Exception type: ${e.runtimeType}');
      return {
        'success': false,
        'message': 'Ошибка сети. Попробуйте позже.',
        'error': e.toString(),
      };
    }
  }

  // Login with phone number - sends SMS code
  static Future<Map<String, dynamic>> loginWithPhone(String phoneNumber) async {
    print('🔵 AuthService.loginWithPhone called with: $phoneNumber');
    try {
      final requestData = {
        'phone_number': phoneNumber,
      };
      print('🔵 Request data: $requestData');
      
      final response = await ApiService.request(
        url: 'auth/login/',
        method: 'POST',
        data: requestData,
        open: true, // This endpoint doesn't require authentication
      );
      
      print('🔵 Response status code: ${response.statusCode}');
      print('🔵 Response data: ${response.data}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'SMS код успешно отправлен',
          'data': response.data,
        };
      } else {
        print('🔴 Login failed with status: ${response.statusCode}');
        print('🔴 Error response: ${response.data}');
        return {
          'success': false,
          'message': 'Не удалось отправить SMS код',
          'error': response.data,
        };
      }
    } catch (e) {
      print('🔴 Login exception: $e');
      print('🔴 Exception type: ${e.runtimeType}');
      print('🔴 Exception details: ${e.toString()}');
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
    print('🟡 AuthService.verifyCode called with identifier: $identifier, code: $code, role: $role');
    try {
      final requestData = {
        'identifier': identifier,
        'sms_code': code,
        'role': role,
      };
      print('🟡 Request data: $requestData');
      
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
      
      print('🟡 Response status code: ${response.statusCode}');
      print('🟡 Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Save token if provided
        if (response.data != null && response.data['access_token'] != null) {
          ApiService.setMemoryToken(response.data['access_token']);
        }
        
        return {
          'success': true,
          'message': response.data['message'] ?? 'Код успешно подтвержден',
          'data': response.data,
        };
      } else {
        print('🔴 Verify failed with status: ${response.statusCode}');
        print('🔴 Error response: ${response.data}');
        return {
          'success': false,
          'message': 'Неверный код подтверждения',
          'error': response.data,
        };
      }
    } catch (e) {
      print('🔴 Verify exception: $e');
      print('🔴 Exception type: ${e.runtimeType}');
      print('🔴 Exception details: ${e.toString()}');
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

      // Clear token from memory and storage
      ApiService.setMemoryToken(null);
      
      return {
        'success': true,
        'message': 'Выход выполнен успешно',
        'data': response.data,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Ошибка выхода. Попробуйте позже.',
        'error': e.toString(),
      };
    }
  }
}
