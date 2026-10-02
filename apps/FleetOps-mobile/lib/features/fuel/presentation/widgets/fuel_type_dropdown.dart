import 'package:flutter/material.dart';

class FuelTypeDropdown extends StatefulWidget {
  final String? selectedValue;
  final Function(String?) onChanged;
  final bool isRequired;

  const FuelTypeDropdown({
    Key? key,
    this.selectedValue,
    required this.onChanged,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<FuelTypeDropdown> createState() => _FuelTypeDropdownState();
}

class _FuelTypeDropdownState extends State<FuelTypeDropdown> {
  final List<String> fuelTypes = [
    'Pertalite',
    'Pertamax',
    'Pertamax Green 95',
    'Pertamax Turbo',
    'Bio Solar',
    'Dexlite',
    'Pertamax Dex',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Jenis BBM',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            if (widget.isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: widget.selectedValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          items: fuelTypes.map((String fuel) {
            return DropdownMenuItem<String>(value: fuel, child: Text(fuel));
          }).toList(),
          onChanged: widget.onChanged,
          validator: (value) {
            if (widget.isRequired && (value == null || value.isEmpty)) {
              return 'Jenis BBM harus dipilih';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
