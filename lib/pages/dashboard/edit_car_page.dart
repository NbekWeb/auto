import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../colors.dart';
import '../../components/toast_service.dart';
import '../../services/cars_service.dart';

class EditCarPage extends StatefulWidget {
  final CarData car;

  const EditCarPage({
    super.key,
    required this.car,
  });

  @override
  State<EditCarPage> createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  String? _selectedVehicleType;
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _vehicleTypes = [
    {
      'id': 'passenger',
      'name': 'Легковой',
      'icon': 'car',
      'isSvg': true,
    },
    {
      'id': 'motorcycle',
      'name': 'Мото',
      'icon': 'moto',
      'isSvg': true,
    },
    {
      'id': 'cargo',
      'name': 'Грузовой',
      'icon': 'cargo',
      'isSvg': true,
    },
    {
      'id': 'bus',
      'name': 'Автобус',
      'icon': 'bus',
      'isSvg': true,
    },
    {
      'id': 'equipment',
      'name': 'Техника',
      'icon': 'equipment',
      'isSvg': true,
    },
    {
      'id': 'hydro',
      'name': 'Гидро',
      'icon': 'hydro',
      'isSvg': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    // Set initial values from car data
    _selectedVehicleType = _getVehicleTypeId(widget.car.typeCar);
    _brandController.text = widget.car.brand;
    _modelController.text = widget.car.model;
    _yearController.text = widget.car.year.toString();
  }

  String? _getVehicleTypeId(String typeCar) {
    switch (typeCar) {
      case 'Легковой':
        return 'passenger';
      case 'Мото':
        return 'motorcycle';
      case 'Грузовой':
        return 'cargo';
      case 'Автобус':
        return 'bus';
      case 'Техника':
        return 'equipment';
      case 'Гидро':
        return 'hydro';
      default:
        return null;
    }
  }

  String _getVehicleTypeName(String? id) {
    switch (id) {
      case 'passenger':
        return 'Легковой';
      case 'motorcycle':
        return 'Мото';
      case 'cargo':
        return 'Грузовой';
      case 'bus':
        return 'Автобус';
      case 'equipment':
        return 'Техника';
      case 'hydro':
        return 'Гидро';
      default:
        return '';
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
          'Изменение ТС',
          style: TextStyle(
            color: isDark ? AppColors.darkText : AppColors.lightText,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Manrope',
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Vehicle type section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Тип ТС',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Vehicle type grid
                SizedBox(
                  height: 240,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: _vehicleTypes.length,
                    itemBuilder: (context, index) {
                      final vehicle = _vehicleTypes[index];
                      final isSelected = _selectedVehicleType == vehicle['id'];

                      return GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              _selectedVehicleType = vehicle['id'];
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.orangeSelected
                                : AppColors.borderDark,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.orangeSelected
                                  : Colors.transparent,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.16),
                                offset: const Offset(6, 6),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.04),
                                offset: const Offset(-6, -6),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (vehicle['isSvg'] == true)
                                  ? SizedBox(
                                      width: 36,
                                      height: 36,
                                      child: SvgPicture.asset(
                                        'assets/icons/${vehicle['icon']}.svg',
                                        width: 36,
                                        height: 36,
                                        colorFilter: ColorFilter.mode(
                                          isSelected
                                              ? AppColors.textWhite
                                              : AppColors.orange,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    )
                                  : Icon(
                                      vehicle['icon'],
                                      size: 32,
                                      color: isSelected
                                          ? AppColors.textWhite
                                          : AppColors.orange,
                                    ),
                              const SizedBox(height: 8),
                              Text(
                                vehicle['name'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Brand input
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Марка',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.inputDark : AppColors.inputLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.inputBorder,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _brandController,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Укажите марку',
                      hintStyle: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                ),

                // Model input
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Модель',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.inputDark : AppColors.inputLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.inputBorder,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _modelController,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Укажите модель',
                      hintStyle: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                ),

                // Year input
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Год выпуска',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.inputDark : AppColors.inputLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.inputBorder,
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    maxLength: 4,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Укажите год выпуска',
                      hintStyle: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                ),

                const SizedBox(height: 40),

                // Action buttons - Отмена and Сохранить
                Row(
                  children: [
                    // Отмена button
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.inputDark : AppColors.inputLight,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadowGrey.withOpacity(0.24),
                              offset: const Offset(0, 0),
                              blurRadius: 24,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.pop(context),
                            child: Center(
                              child: Text(
                                'Отмена',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textGrey : AppColors.lightTextSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Сохранить button
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: _isFormComplete() && !_isSubmitting
                              ? const LinearGradient(
                                  begin: Alignment(-0.8, -0.6),
                                  end: Alignment(0.8, 0.6),
                                  colors: [AppColors.orangeGradientStart, AppColors.orangeGradientEnd],
                                  stops: [0.0, 1.0],
                                )
                              : null,
                          color: _isFormComplete() && !_isSubmitting
                              ? null
                              : (isDark ? AppColors.inputDark : AppColors.inputLight),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _isFormComplete() && !_isSubmitting
                              ? [
                                  BoxShadow(
                                    color: AppColors.orangeGradientShadow.withOpacity(0.2),
                                    offset: const Offset(0, 0),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: const Color(0xFF6F6F6F).withOpacity(0.24),
                                    offset: const Offset(0, 0),
                                    blurRadius: 24,
                                    spreadRadius: 0,
                                  ),
                                ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: _isFormComplete() && !_isSubmitting ? _handleSave : null,
                            child: Center(
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Сохранить',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: _isFormComplete() && !_isSubmitting
                                            ? Colors.white
                                            : (isDark ? const Color(0xFF818B93) : AppColors.lightTextSecondary),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isFormComplete() {
    return _selectedVehicleType != null &&
        _brandController.text.isNotEmpty &&
        _modelController.text.isNotEmpty &&
        _yearController.text.isNotEmpty;
  }

  Future<void> _handleSave() async {
    if (!_isFormComplete() || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final typeCar = _getVehicleTypeName(_selectedVehicleType);
    final year = int.tryParse(_yearController.text) ?? 0;

    final result = await CarsService.updateCar(
      carId: widget.car.id,
      typeCar: typeCar,
      brand: _brandController.text,
      model: _modelController.text,
      year: year,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.pop(context, true);
      ToastService.showSuccess(
        context,
        message: 'Машина успешно обновлена',
      );
    } else {
      ToastService.showError(
        context,
        message: result['message'] ?? 'Ошибка обновления машины',
      );
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}

