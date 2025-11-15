import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../colors.dart';
import '../../components/toast_service.dart';
import '../../services/cars_service.dart';
import 'add_car_page.dart';
import 'edit_car_page.dart';

class MyGaragePage extends StatefulWidget {
  const MyGaragePage({super.key});

  @override
  State<MyGaragePage> createState() => _MyGaragePageState();
}

class _MyGaragePageState extends State<MyGaragePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    setState(() {
      _isLoading = true;
    });

    final result = await CarsService.getCarsAll();

    setState(() {
      _isLoading = false;
    });

    if (result['success'] != true) {
      if (mounted) {
        ToastService.showError(
          context,
          message: result['message'] ?? 'Ошибка загрузки машин',
        );
      }
    }
  }

  String _getVehicleTypeIcon(String typeCar) {
    switch (typeCar) {
      case 'Легковой':
        return 'car';
      case 'Мото':
        return 'moto';
      case 'Грузовой':
        return 'cargo';
      case 'Автобус':
        return 'bus';
      case 'Техника':
        return 'equipment';
      case 'Гидро':
        return 'hydro';
      default:
        return 'car';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Мой гараж',
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Manrope',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddCarPage(),
                ),
              );
              if (result == true) {
                _loadCars();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.orange,
                ),
              ),
            )
          : CarsService.cars.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car_outlined,
                        size: 64,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Нет машин',
                        style: TextStyle(
                          fontSize: 18,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                          fontFamily: 'Manrope',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Добавьте свою первую машину',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: CarsService.cars.length,
                  itemBuilder: (context, index) {
                    final car = CarsService.cars[index];
                    final iconName = _getVehicleTypeIcon(car.typeCar);

                    return Dismissible(
                      key: Key(car.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 4, top: 4),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/delete.svg',
                          width: 28,
                          height: 28,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await _showDeleteConfirmation(context, car, isDark);
                      },
                      onDismissed: (direction) {
                        _deleteCar(car);
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 4, top: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardDark : AppColors.cardLight,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              // Car icon without wrapper
                              SvgPicture.asset(
                                'assets/icons/$iconName.svg',
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.iconGrey,
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Car info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${car.brand} ${car.model}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? AppColors.darkText : AppColors.lightText,
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${car.year}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                        fontFamily: 'Manrope',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Edit button
                              TextButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditCarPage(car: car),
                                    ),
                                  );
                                  if (result == true) {
                                    _loadCars();
                                  }
                                },
                                child: Text(
                                  'Изменить',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.orange,
                                    fontFamily: 'Manrope',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context, CarData car, bool isDark) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Trash icon
              SvgPicture.asset(
                'assets/icons/delete.svg',
                width: 48,
                height: 48,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 16),
              // Question text
              Text(
                'Вы действительно хотите удалить добавленное ТС?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                  fontFamily: 'Manrope',
                ),
              ),
              const SizedBox(height: 24),
              // Buttons
              Column(
                children: [
                  // Оставить button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.borderDark : AppColors.cardLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Оставить',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Удалить button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? AppColors.borderDark : AppColors.cardLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Удалить',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteCar(CarData car) async {
    final result = await CarsService.deleteCar(car.id);

    if (result['success'] == true) {
      if (mounted) {
        ToastService.showSuccess(
          context,
          message: result['message'] ?? 'Машина успешно удалена',
        );
        _loadCars();
      }
    } else {
      if (mounted) {
        ToastService.showError(
          context,
          message: result['message'] ?? 'Ошибка удаления машины',
        );
        _loadCars(); // Reload to restore the item if delete failed
      }
    }
  }
}

