import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class LocationService {
  static const String _cityKey = 'user_city';
  static const String _lastUpdateKey = 'location_last_update';

  // Get current location (same as map_page uses geolocator)
  static Future<Position?> getCurrentPosition() async {
    try {
      // Check permissions (same as map_page)
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Get current position (same as map_page)
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  // Get current city - just returns saved city or null
  // Reverse geocoding will be handled by Yandex MapKit when it's properly configured
  static Future<String?> getCurrentCity() async {
    // For now, just return saved city
    // Reverse geocoding can be added later when Yandex MapKit SearchManager is properly configured
    return await getSavedCity();
  }

  // Save city to local storage
  static Future<void> saveCity(String city) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cityKey, city);
      await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error saving city: $e');
    }
  }

  // Get saved city from local storage
  static Future<String?> getSavedCity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_cityKey);
    } catch (e) {
      print('Error getting saved city: $e');
      return null;
    }
  }

  // Update city in background (should be called periodically)
  static Future<String?> updateCityInBackground() async {
    try {
      final city = await getCurrentCity();
      if (city != null) {
        await saveCity(city);
      }
      return city;
    } catch (e) {
      print('Error updating city in background: $e');
      return null;
    }
  }

  // Check if location needs update (e.g., every hour)
  static Future<bool> shouldUpdateLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUpdate = prefs.getInt(_lastUpdateKey);
      if (lastUpdate == null) return true;

      final lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(lastUpdate);
      final now = DateTime.now();
      final difference = now.difference(lastUpdateTime);

      // Update if more than 1 hour has passed
      return difference.inHours >= 1;
    } catch (e) {
      return true;
    }
  }

  // Get city name from coordinates using Yandex Geocoder API
  static Future<String?> getCityFromCoordinates(double latitude, double longitude) async {
    try {
      // Use Yandex Geocoder API for reverse geocoding
      // This is faster and more reliable than MapKit SearchManager
      final dio = Dio();
      final response = await dio.get(
        'https://geocode-maps.yandex.ru/1.x/',
        queryParameters: {
          'apikey': '491a85a5-7445-4d5d-a419-84bda4ad6328', // Yandex Maps API key
          'geocode': '$longitude,$latitude',
          'format': 'json',
          'kind': 'locality', // Get city/locality information
          'results': 1,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          );
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final geoObjectCollection = response.data['response']?['GeoObjectCollection'];
        if (geoObjectCollection != null) {
          final featureMembers = geoObjectCollection['featureMember'] as List?;
          if (featureMembers != null && featureMembers.isNotEmpty) {
            final geoObject = featureMembers[0]['GeoObject'];
            final metaDataProperty = geoObject['metaDataProperty'];
            final geocoderMetaData = metaDataProperty['GeocoderMetaData'];
            final address = geocoderMetaData['Address'];
            
            // Extract city name from address components
            final components = address['Components'] as List?;
            if (components != null) {
              // Find locality component (city)
              for (var component in components) {
                final kind = component['kind'];
                if (kind == 'locality' || kind == 'district') {
                  return component['name'] as String?;
                }
              }
              // If no locality found, try to get from formatted address
              final formatted = address['formatted'] as String?;
              if (formatted != null && formatted.isNotEmpty) {
                final parts = formatted.split(',');
                if (parts.isNotEmpty) {
                  return parts[0].trim();
                }
              }
            }
          }
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting city from coordinates using Yandex Geocoder: $e');
      return null;
    }
  }
}

