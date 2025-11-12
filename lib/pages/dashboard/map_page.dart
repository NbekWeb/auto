import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';
import '../../colors.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  YandexMapController? _mapController;
  Point? _userLocation;
  bool _isLoadingLocation = false;
  final Point _tashkentCenter = const Point(latitude: 41.2995, longitude: 69.2401);
  
  var _routePoints = <Point>[];
  var _currentRoutingType = RoutingType.driving;
  
  List<MapObject> _mapObjects = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeMap();
    });
  }

  void _initializeMap() async {
    try {
      await _getCurrentLocation();
    } catch (e) {
      print('Error initializing map: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar("Joylashuv ruxsati rad etildi");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar("Joylashuv ruxsati doimiy ravishda rad etilgan");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = Point(
          latitude: position.latitude,
          longitude: position.longitude,
        );
        _isLoadingLocation = false;
      });

      // Move map to user location
      if (_mapController != null && _userLocation != null) {
        await _mapController!.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: _userLocation!,
              zoom: 15,
            ),
          ),
        );
      }

      print('Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      print('Error getting location: $e');
      _showSnackBar("Joylashuvni olishda xato");
    }
  }

  void _centerOnUserLocation() {
    if (_userLocation != null && _mapController != null) {
      _mapController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _userLocation!,
            zoom: 15,
          ),
        ),
      );
    } else {
      _getCurrentLocation();
    }
  }

  void _toggleMapType() {
    setState(() {
      switch (_currentRoutingType) {
        case RoutingType.driving:
          _currentRoutingType = RoutingType.pedestrian;
        case RoutingType.pedestrian:
          _currentRoutingType = RoutingType.publicTransport;
        case RoutingType.publicTransport:
          _currentRoutingType = RoutingType.driving;
      }
    });
  }

  void _refreshRoute() {
    if (_routePoints.length >= 2) {
      _showSnackBar("Marshrut yangilandi");
    } else {
      _showSnackBar("Marshrut uchun kamida 2 ta nuqta kerak");
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Qidiruv'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Manzil yoki joy nomini kiriting',
          ),
          onSubmitted: (value) {
            Navigator.pop(context);
            _performSearch(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performSearch('');
            },
            child: const Text('Qidirish'),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      _showSnackBar("Qidiruv so'rovini kiriting");
      return;
    }
    _showSnackBar("Qidiruv: $query");
    // Bu yerda haqiqiy qidiruv logikasi bo'ladi
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _onMapCreated(YandexMapController controller) async {
    _mapController = controller;
    
    // Move to user location or Tashkent
    if (_userLocation != null) {
      await controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _userLocation!,
            zoom: 15,
          ),
        ),
      );
    } else {
      await controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _tashkentCenter,
            zoom: 10,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xarita'),
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
            tooltip: 'Qidiruv',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          YandexMap(
            onMapCreated: _onMapCreated,
            mapObjects: _mapObjects,
            onMapTap: (Point point) {
              // Handle map tap
            },
            onMapLongTap: (Point point) {
              setState(() {
                _routePoints.add(point);
                _updateMapObjects();
                if (_routePoints.length == 1) {
                  _showSnackBar("Birinchi marshrut nuqtasi qo'shildi");
                }
              });
            },
          ),
          
          // Map controls
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                // Location button
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: _centerOnUserLocation,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        _isLoadingLocation ? Icons.hourglass_empty : Icons.my_location,
                        color: AppColors.lightPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Map type button
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: _toggleMapType,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        _currentRoutingType == RoutingType.driving
                            ? Icons.directions_car
                            : _currentRoutingType == RoutingType.pedestrian
                                ? Icons.directions_walk
                                : Icons.directions_bus,
                        color: AppColors.lightPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Refresh button
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: _refreshRoute,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        Icons.refresh,
                        color: AppColors.lightPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Route type indicator
          Positioned(
            bottom: 100,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Marshrut turi: ${_currentRoutingType.name}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${_routePoints.length} nuqta',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Clear routes button
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _routePoints = [];
                  _mapObjects = [];
                });
                _showSnackBar("Barcha marshrutlar tozalandi");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Marshrutlarni tozalash',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateMapObjects() {
    _mapObjects = _routePoints.map((point) {
      return PlacemarkMapObject(
        mapId: MapObjectId('placemark_${point.latitude}_${point.longitude}'),
        point: point,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/icons/user.png'),
            scale: 1.5,
          ),
        ),
      );
    }).toList();
  }
}

// Routing types
enum RoutingType {
  driving,
  pedestrian,
  publicTransport,
}

extension RoutingTypeExtension on RoutingType {
  String get name {
    switch (this) {
      case RoutingType.driving:
        return 'Avtomobil';
      case RoutingType.pedestrian:
        return 'Piyoda';
      case RoutingType.publicTransport:
        return 'Jamoat transporti';
    }
  }
}