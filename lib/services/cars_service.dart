import 'api.dart';
import 'package:dio/dio.dart';
import '../constants/navigator_key.dart';

class CarsService {
  static List<CarData> _cars = [];

  static List<CarData> get cars => _cars;

  // Get all cars from API
  static Future<Map<String, dynamic>> getCarsAll() async {
    try {
      final response = await ApiService.request(
        url: 'car/cars/',
        method: 'GET',
      );

      if (response.statusCode == 200 && response.data != null) {
        // Parse the response data
        List<dynamic> carsList = [];
        
        if (response.data is List) {
          carsList = response.data;
        } else if (response.data is Map && response.data['data'] != null) {
          carsList = response.data['data'] is List 
              ? response.data['data'] 
              : [];
        }

        // Convert to CarData objects
        _cars = carsList.map((json) => CarData.fromJson(json)).toList();

        return {
          'success': true,
          'data': _cars,
          'message': 'Машины успешно загружены',
        };
      } else {
        return {
          'success': false,
          'message': 'Не удалось загрузить машины',
          'error': response.data,
        };
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
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

  // Add new car
  static Future<Map<String, dynamic>> addCar({
    required String typeCar,
    required String brand,
    required String model,
    required int year,
  }) async {
    try {
      final response = await ApiService.request(
        url: 'car/cars/',
        method: 'POST',
        data: {
          'type_car': typeCar,
          'brand': brand,
          'model': model,
          'year': year,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response and add to list
        if (response.data != null) {
          final carData = CarData.fromJson(response.data);
          _cars.add(carData);
        }

        return {
          'success': true,
          'message': 'Машина успешно добавлена',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'Не удалось добавить машину',
          'error': response.data,
        };
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
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

        // Handle validation errors
        if (e.response?.statusCode == 400) {
          final errorData = e.response?.data;
          String errorMessage = 'Ошибка валидации';
          
          if (errorData is Map) {
            if (errorData['detail'] != null) {
              errorMessage = errorData['detail'].toString();
            } else if (errorData['message'] != null) {
              errorMessage = errorData['message'].toString();
            }
          }

          return {
            'success': false,
            'message': errorMessage,
            'error': errorData,
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

  // Update car
  static Future<Map<String, dynamic>> updateCar({
    required int carId,
    required String typeCar,
    required String brand,
    required String model,
    required int year,
  }) async {
    try {
      final response = await ApiService.request(
        url: 'car/cars/$carId/',
        method: 'PUT',
        data: {
          'type_car': typeCar,
          'brand': brand,
          'model': model,
          'year': year,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update the car in the list
        if (response.data != null) {
          final updatedCar = CarData.fromJson(response.data);
          final index = _cars.indexWhere((car) => car.id == carId);
          if (index != -1) {
            _cars[index] = updatedCar;
          }
        }

        return {
          'success': true,
          'message': 'Машина успешно обновлена',
          'data': response.data,
        };
      } else {
        return {
          'success': false,
          'message': 'Не удалось обновить машину',
          'error': response.data,
        };
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
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

        // Handle validation errors
        if (e.response?.statusCode == 400) {
          final errorData = e.response?.data;
          String errorMessage = 'Ошибка валидации';
          
          if (errorData is Map) {
            if (errorData['detail'] != null) {
              errorMessage = errorData['detail'].toString();
            } else if (errorData['message'] != null) {
              errorMessage = errorData['message'].toString();
            }
          }

          return {
            'success': false,
            'message': errorMessage,
            'error': errorData,
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

  // Delete car
  static Future<Map<String, dynamic>> deleteCar(int carId) async {
    try {
      final response = await ApiService.request(
        url: 'car/cars/$carId/',
        method: 'DELETE',
      );

      if (response.statusCode == 204 || response.statusCode == 200) {
        // Remove the car from the list
        _cars.removeWhere((car) => car.id == carId);

        return {
          'success': true,
          'message': 'Машина успешно удалена',
        };
      } else {
        return {
          'success': false,
          'message': 'Не удалось удалить машину',
          'error': response.data,
        };
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
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

        if (e.response?.statusCode == 403) {
          return {
            'success': false,
            'message': 'Нет прав доступа',
            'error': e.response?.data ?? e.toString(),
          };
        }

        if (e.response?.statusCode == 404) {
          return {
            'success': false,
            'message': 'Машина не найдена',
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

  // Clear cars list
  static void clearCars() {
    _cars.clear();
  }
}

class CarData {
  final int id;
  final String typeCar;
  final String brand;
  final String model;
  final int year;
  final int user;
  final String? userName;
  final String? userPhone;
  final String createdAt;
  final String updatedAt;

  CarData({
    required this.id,
    required this.typeCar,
    required this.brand,
    required this.model,
    required this.year,
    required this.user,
    this.userName,
    this.userPhone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CarData.fromJson(Map<String, dynamic> json) {
    return CarData(
      id: json['id'] as int? ?? 0,
      typeCar: json['type_car']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      year: json['year'] as int? ?? 0,
      user: json['user'] as int? ?? 0,
      userName: json['user_name']?.toString(),
      userPhone: json['user_phone']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_car': typeCar,
      'brand': brand,
      'model': model,
      'year': year,
      'user': user,
      'user_name': userName,
      'user_phone': userPhone,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return '$brand $model ($year)';
  }
}

