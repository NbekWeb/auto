import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../colors.dart';
import '../../components/auth/vehicle_selection_header.dart';
import '../../components/auth/vehicle_type_grid.dart';
import '../../components/auth/vehicle_input_field.dart';
import '../../components/auth/done_button.dart';
import '../../components/auth/fill_later_button.dart';
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
                  const VehicleSelectionHeader(),
                  VehicleTypeGrid(
                    vehicleTypes: _vehicleTypes,
                    selectedVehicleType: _selectedVehicleType,
                    onVehicleTypeSelected: (id) {
                      if (mounted) {
                        setState(() {
                          _selectedVehicleType = id;
                        });
                      }
                    },
                  ),
                  // Brand input (appears after type selection)
                  if (_selectedVehicleType != null) ...[
                    const SizedBox(height: 40),
                    VehicleInputField(
                      label: 'Марка',
                      hintText: 'Укажите марку',
                      controller: _brandController,
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                  ],
                  // Model input (appears after brand is filled)
                  if (_selectedVehicleType != null && _brandController.text.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    VehicleInputField(
                      label: 'Модель',
                      hintText: 'Укажите модель',
                      controller: _modelController,
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                  ],
                  // Year input (appears after model is filled)
                  if (_selectedVehicleType != null &&
                      _brandController.text.isNotEmpty &&
                      _modelController.text.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    VehicleInputField(
                      label: 'Год выпуска',
                      hintText: 'Укажите год выпуска',
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      maxLength: 4,
                      onChanged: (value) {
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 40),
                  DoneButton(
                    isEnabled: _isFormComplete(),
                    onPressed: _handleDone,
                  ),
                  const SizedBox(height: 16),
                  FillLaterButton(
                    onTap: _handleFillLater,
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
