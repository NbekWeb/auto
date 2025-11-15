import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../services/vehicle_service.dart';
import 'vehicle_selection_page.dart';

class VehicleSummaryPage extends StatefulWidget {
  const VehicleSummaryPage({super.key});

  @override
  State<VehicleSummaryPage> createState() => _VehicleSummaryPageState();
}

class _VehicleSummaryPageState extends State<VehicleSummaryPage> {
  final VehicleService _vehicleService = VehicleService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vehicles = _vehicleService.vehicles;

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
              padding: EdgeInsets.zero,
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

                // Vehicle list
                if (vehicles.isNotEmpty) ...[
                  ...vehicles.asMap().entries.map((entry) {
                    final index = entry.key;
                    final vehicle = entry.value;
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16, left: 0, right: 0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.inputDark : AppColors.inputLight,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                             color: isDark ? AppColors.darkText : AppColors.lightText,
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${vehicle.brand} ${vehicle.model}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkText : AppColors.lightText,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  vehicle.year,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _vehicleService.removeVehicle(index);
                              });
                            },
                            child: Text(
                              'Изменить',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.orangeSelected,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'Добавьте ваше транспортное средство',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                // Complete button
                Container(
                  width: double.infinity,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: vehicles.isNotEmpty
                        ? const LinearGradient(
                            begin: Alignment(-0.8, -0.6),
                            end: Alignment(0.8, 0.6),
                            colors: [AppColors.orangeGradientStart, AppColors.orangeGradientEnd],
                            stops: [0.0, 1.0],
                          )
                        : null,
                    color: vehicles.isNotEmpty
                        ? null
                        : (isDark ? AppColors.inputDark : AppColors.inputLight),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: vehicles.isNotEmpty
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
                      onTap: vehicles.isNotEmpty ? _handleComplete : null,
                      child: Center(
                        child: Text(
                          'Завершить',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: vehicles.isNotEmpty
                                ? Colors.white
                                : (isDark ? AppColors.textGrey : AppColors.lightTextSecondary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Add another vehicle
                GestureDetector(
                  onTap: _handleAddAnother,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: AppColors.textGreySecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Добавить другое ТС',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGreySecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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

  void _handleComplete() {
    // Navigate to next page or show success
    print('Vehicle setup completed with ${_vehicleService.vehicles.length} vehicles');
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NextPage()));
  }

  void _handleAddAnother() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const VehicleSelectionPage(),
      ),
    );
  }
}