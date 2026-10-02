import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:core/core.dart';
import 'custom_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImagePickerWidget extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;
  final String? imagePath;
  final double? height;
  final String? title;
  final String innerTitle;

  const ImagePickerWidget({
    super.key,
    required this.onPickImage,
    required this.onRemoveImage,
    this.imagePath,
    this.height,
    this.title,
    this.innerTitle = 'Ambil Foto',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && title!.isNotEmpty) ...[
          Text(title!),
          Gap(4.0),
        ],
        if (imagePath != null)
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(imagePath!),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Pilih Ulang',
                      textColor: AppColors.primary,
                      color: AppColors.white,
                      borderColor: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                      onPressed: onPickImage,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Hapus Foto',
                      textColor: AppColors.error,
                      color: AppColors.white,
                      borderColor: AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                      onPressed: onRemoveImage,
                    ),
                  ),
                ],
              ),
            ],
          )
        else
          GestureDetector(
            onTap: onPickImage,
            child: DottedBorder(
              color: AppColors.grey300,
              strokeWidth: 1.0,
              borderType: BorderType.RRect,
              radius: Radius.circular(8.0),
              dashPattern: [5, 3],
              child: Container(
                height: height ?? 100,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt_outlined, color: AppColors.grey400),
                      Gap(4.0),
                      Text(
                        innerTitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
