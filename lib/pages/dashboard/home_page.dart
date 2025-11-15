import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import '../../colors.dart';
import '../../components/dashboard/home/services_grid.dart';
import '../../components/dashboard/home/workshops_section.dart';
import '../../components/dashboard/home/search_bar.dart';
import '../../services/location_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _cityName = 'Москва';
  bool _isLoadingLocation = false;

  final List<Map<String, dynamic>> _services = const [
    {
      'id': 'electronics',
      'name': 'Диагностика электроники',
      'icon': 'dio',
      'isSvg': true,
    },
    {
      'id': 'service',
      'name': 'Сервис и ТО',
      'icon': 'service',
      'isSvg': true,
    },
    {
      'id': 'tire',
      'name': 'Шиномонтаж',
      'icon': 'shino',
      'isSvg': true,
    },
    {
      'id': 'towing',
      'name': 'Буксировка',
      'icon': 'buka',
      'isSvg': true,
    },
    {
      'id': 'wash',
      'name': 'Автомойка',
      'icon': 'moyka',
      'isSvg': true,
    },
    {
      'id': 'roadside',
      'name': 'Помощь на дороге',
      'icon': 'help',
      'isSvg': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadCity();
  }

  Future<void> _loadCity() async {
    if (!mounted) return;
    
    // Load saved city from storage
    final savedCity = await LocationService.getSavedCity();
    print('Loading city - saved city: $savedCity');
    
    if (savedCity != null && savedCity.isNotEmpty && mounted) {
      setState(() {
        _cityName = savedCity;
      });
      print('City name set to: $_cityName');
    } else {
      // If no saved city, set default
      if (mounted) {
        setState(() {
          _cityName = 'Москва';
        });
        print('City name set to default: $_cityName');
      }
    }

    // Get current city if no saved city or should update
    final shouldUpdate = await LocationService.shouldUpdateLocation();
    if (shouldUpdate || savedCity == null) {
      if (mounted) {
        await _getCurrentCity();
      }
    }
  }

  Future<void> _getCurrentCity() async {
    if (_isLoadingLocation || !mounted) return;

    if (mounted) {
      setState(() {
        _isLoadingLocation = true;
      });
    }

    try {
      // Get current position (same as map_page - directly using geolocator)
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _isLoadingLocation = false;
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _isLoadingLocation = false;
          });
        }
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      print('Current location: ${position.latitude}, ${position.longitude}');
      
      // Get city name from coordinates using reverse geocoding
      String? cityName = await LocationService.getCityFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      print('City name from geocoding: $cityName');
      
      // Use geocoded city name, or saved city, or default
      final newCityName = cityName ?? 
                         await LocationService.getSavedCity() ?? 
                         'Москва';
      
      // Save the city name if we got it from geocoding, or save default if no saved city
      if (cityName != null && cityName.isNotEmpty) {
        await LocationService.saveCity(cityName);
        print('Saved city name: $cityName');
      } else {
        // If no city from geocoding and no saved city, save default to prevent infinite loop
        final savedCity = await LocationService.getSavedCity();
        if (savedCity == null) {
          await LocationService.saveCity('Москва');
          print('Saved default city name: Москва');
        }
      }
      
      if (mounted) {
        print('Setting city name to: $newCityName');
        setState(() {
          _cityName = newCityName;
          _isLoadingLocation = false;
        });
        print('City name after setState: $_cityName');
      }
    } catch (e) {
      print('Error getting location: $e');
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header with location and menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Location with nav.svg icon
                  GestureDetector(
                    onTap: _getCurrentCity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/nav.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(
                            AppColors.orangeSelected,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _isLoadingLocation
                            ? Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.orangeSelected,
                                    ),
                                  ),
                                ),
                              )
                            : Flexible(
                                child: Text(
                                  _cityName.isNotEmpty ? _cityName : 'Москва',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? AppColors.darkText
                                        : AppColors.lightText,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            // Search bar
            CustomSearchBar(
              hintText: 'Найти СТО, мойки и другое',
              onChanged: (value) {
                // Handle search text changes
              },
              onSubmitted: (value) {
                // Handle search submission
              },
            ),
            const SizedBox(height: 24),
            // Services section
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServicesGrid(services: _services),
                    const SizedBox(height: 32),
                    WorkshopsSection(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
