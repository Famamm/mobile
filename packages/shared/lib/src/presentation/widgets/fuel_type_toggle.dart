import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Toggle pilihan jenis bahan bakar (Diesel / Bensin).
class FuelTypeToggle extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const FuelTypeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: ['Diesel', 'Bensin'].map((tipe) {
        final isSelected = selected == tipe;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: tipe == 'Diesel' ? 8 : 0),
            child: GestureDetector(
              onTap: () => onChanged(tipe),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    tipe,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
