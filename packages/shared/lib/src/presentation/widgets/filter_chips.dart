import 'package:flutter/material.dart';
import 'package:core/core.dart';

class FilterChips extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final ValueChanged<String> onSelected;
  final double chipWidth;
  final EdgeInsetsGeometry padding;

  const FilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onSelected,
    this.chipWidth = 120,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onSelected(filter),
                child: AnimatedContainer(
                  width: chipWidth,
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.grey200,
                    ),
                  ),
                  child: Text(
                    filter,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.grey600,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}