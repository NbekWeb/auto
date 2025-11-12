import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../colors.dart';
import '../../services/vehicle_service.dart';
import 'vehicle_summary_page.dart';

class VehicleSelectionPage extends StatefulWidget {
  const VehicleSelectionPage({super.key});

  @override
  State<VehicleSelectionPage> createState() => _VehicleSelectionPageState();
}

class _VehicleSelectionPageState extends State<VehicleSelectionPage> {
  String? _selectedVehicleType;
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final VehicleService _vehicleService = VehicleService();

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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Add safety check to prevent rendering errors
    if (!mounted) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
              children: [
              const SizedBox(height: 20),

              // Header title inside scroll
              Center(
                child: Text(
                  'Ваш авто',
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Main title
              Center(
                child: Text(
                  'Укажите своё ТС',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                'Ваши заявки будут точнее, а мастера смогут быстрее откликаться, зная особенности вашего авто',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),

              const SizedBox(height: 40),

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
                height: 240, // Fixed height to prevent layout issues
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling
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
                              ? const Color(0xFFFF8635)
                              : const Color(0xFF252F37),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFFF8635)
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
                                            ? const Color(0xFFF4F4F4)
                                            : const Color(0xFFFF771C),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    vehicle['icon'],
                                    size: 32,
                                    color: isSelected
                                        ? const Color(0xFFF4F4F4)
                                        : const Color(0xFFFF771C),
                                  ),
                            const SizedBox(height: 8),
                            Text(
                              vehicle['name'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFF4F4F4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Brand input (appears after type selection)
              if (_selectedVehicleType != null) ...[
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
                    color: isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4F5B63),
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
              ],

              // Model input (appears after brand is filled)
              if (_selectedVehicleType != null && _brandController.text.isNotEmpty) ...[
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
                    color: isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4F5B63),
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
              ],

              // Year input (appears after model is filled)
              if (_selectedVehicleType != null && 
                  _brandController.text.isNotEmpty && 
                  _modelController.text.isNotEmpty) ...[
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
                    color: isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF4F5B63),
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
              ],

              const SizedBox(height: 40),

              // Done button
              Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  gradient: _isFormComplete()
                      ? const LinearGradient(
                          begin: Alignment(-0.8, -0.6),
                          end: Alignment(0.8, 0.6),
                          colors: [Color(0xFFF67824), Color(0xFFF6A523)],
                          stops: [0.0, 1.0],
                        )
                      : null,
                  color: _isFormComplete()
                      ? null
                      : (isDark ? const Color(0xFF343F47) : const Color(0xFFF5F5F5)),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _isFormComplete()
                      ? [
                          BoxShadow(
                            color: const Color(0xFFF68324).withOpacity(0.2),
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
                    onTap: _isFormComplete() ? _handleDone : null,
                    child: Center(
                      child: Text(
                        'Готово',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _isFormComplete()
                              ? Colors.white
                              : (isDark ? const Color(0xFF818B93) : AppColors.lightTextSecondary),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Fill later option
              GestureDetector(
                onTap: _handleFillLater,
                child: Text(
                  'Заполнить данные позже',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF9FA7AD),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Manrope',
                    height: 1.3,
                    letterSpacing: 0,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ],
            ),
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

  void _handleDone() {
    if (_isFormComplete()) {
      // Create vehicle data
      final vehicleData = VehicleData(
        type: _selectedVehicleType!,
        brand: _brandController.text,
        model: _modelController.text,
        year: _yearController.text,
      );

      // Add to service
      _vehicleService.addVehicle(vehicleData);

      // Navigate to summary page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const VehicleSummaryPage(),
        ),
      );
    }
  }

  void _handleFillLater() {
    print('User chose to fill data later');
    // Navigate to next page without vehicle selection
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextPage()));
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
  }
}
