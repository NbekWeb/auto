class VehicleService {
  static final VehicleService _instance = VehicleService._internal();
  factory VehicleService() => _instance;
  VehicleService._internal();

  List<VehicleData> _vehicles = [];

  List<VehicleData> get vehicles => _vehicles;

  void addVehicle(VehicleData vehicle) {
    _vehicles.add(vehicle);
  }

  void removeVehicle(int index) {
    if (index >= 0 && index < _vehicles.length) {
      _vehicles.removeAt(index);
    }
  }

  void updateVehicle(int index, VehicleData vehicle) {
    if (index >= 0 && index < _vehicles.length) {
      _vehicles[index] = vehicle;
    }
  }

  void clearVehicles() {
    _vehicles.clear();
  }
}

class VehicleData {
  final String type;
  final String brand;
  final String model;
  final String year;

  VehicleData({
    required this.type,
    required this.brand,
    required this.model,
    required this.year,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'brand': brand,
      'model': model,
      'year': year,
    };
  }

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      type: json['type'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
    );
  }

  @override
  String toString() {
    return '$brand $model $year';
  }
}


