import 'package:flutter/material.dart';
import '../../colors.dart';
import 'vehicle_type_button.dart';

class VehicleTypeGrid extends StatelessWidget {
  final List<Map<String, dynamic>> vehicleTypes;
  final String? selectedVehicleType;
  final Function(String) onVehicleTypeSelected;

  const VehicleTypeGrid({
    super.key,
    required this.vehicleTypes,
    required this.selectedVehicleType,
    required this.onVehicleTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'Тип ТС',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.darkText : AppColors.lightText,
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
            itemCount: vehicleTypes.length,
            itemBuilder: (context, index) {
              final vehicle = vehicleTypes[index];
              final isSelected = selectedVehicleType == vehicle['id'];

              return VehicleTypeButton(
                vehicle: vehicle,
                isSelected: isSelected,
                onTap: () => onVehicleTypeSelected(vehicle['id']),
              );
            },
          ),
        ),
      ],
    );
  }
}

