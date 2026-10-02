import 'dart:io';
import 'package:flutter/material.dart';
import 'package:core/core.dart';

class FuelPhotoPicker extends StatelessWidget {
  final File? selectedPhoto;
  final VoidCallback onPickPhoto;

  const FuelPhotoPicker({
    Key? key,
    required this.selectedPhoto,
    required this.onPickPhoto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPickPhoto,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.borderLight,
            style: BorderStyle.solid,
          ),
        ),
        child: selectedPhoto != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(selectedPhoto!, fit: BoxFit.cover),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined,
                      size: 32, color: AppColors.textSecondary),
                  SizedBox(height: 8),
                  Text('Unggah Foto Struk',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
      ),
    );
  }
}
