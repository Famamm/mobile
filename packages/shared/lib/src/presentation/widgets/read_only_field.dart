import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:gap/gap.dart';

class ReadOnlyField extends StatelessWidget {
  final String hintText;
  final String? titleValue;
  final String? rightTitle;
  final double? borderRadius;
  final String? suffixText;
  final TextStyle? suffixStyle;
  final IconData? prefixIcon;
  final int? maxLines;
  final int? minLines;
  final String? labelText;
  final String? value;
  final TextStyle? valueStyle;
  final bool showCopyButton;
  final VoidCallback? onCopyPressed;

  const ReadOnlyField({
    super.key,
    required this.hintText,
    this.titleValue,
    this.rightTitle,
    this.borderRadius,
    this.suffixText,
    this.suffixStyle,
    this.labelText,
    this.prefixIcon,
    this.maxLines,
    this.minLines,
    this.value,
    this.valueStyle,
    this.showCopyButton = false,
    this.onCopyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;
    final displayValue = hasValue ? value : hintText;
    final isPlaceholder = !hasValue;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (titleValue != null && titleValue!.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titleValue!,
                style: const TextStyle(
                  color: AppColors.grey700,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (rightTitle != null && rightTitle!.isNotEmpty)
                Text(
                  rightTitle!,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          const Gap(4.0),
        ],
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 12.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.0),
            color: AppColors.grey50,
            border: Border.all(
              color: AppColors.grey200,
              width: 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (prefixIcon != null) ...[
                Icon(
                  prefixIcon,
                  size: 20,
                  color: AppColors.grey500,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (labelText != null && labelText!.isNotEmpty) ...[
                      Text(
                        labelText!,
                        style: const TextStyle(
                          color: AppColors.grey500,
                          fontSize: 12,
                        ),
                      ),
                      const Gap(2),
                    ],
                    Text(
                      displayValue!,
                      style: valueStyle ??
                          TextStyle(
                            color: isPlaceholder
                                ? AppColors.grey500
                                : AppColors.grey900,
                            fontSize: 14,
                            height: 1.2,
                          ),
                      maxLines: maxLines ?? 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (suffixText != null && suffixText!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  suffixText!,
                  style: suffixStyle ??
                      const TextStyle(
                        color: AppColors.grey500,
                        fontSize: 14,
                      ),
                ),
              ],
              if (showCopyButton && hasValue) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onCopyPressed,
                  child: const Icon(
                    Icons.copy,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
