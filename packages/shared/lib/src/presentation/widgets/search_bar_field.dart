import 'package:flutter/material.dart';
import 'package:core/core.dart';

class SearchBarField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onCleared;

  const SearchBarField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.onCleared,
  });

  @override
  State<SearchBarField> createState() => _SearchBarFieldState();
}

class _SearchBarFieldState extends State<SearchBarField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.isNotEmpty;
  }

  void _clear() {
    widget.controller.clear();
    setState(() => _hasText = false);
    widget.onChanged('');
    widget.onCleared?.call();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (v) {
        setState(() => _hasText = v.isNotEmpty);
        widget.onChanged(v);
      },
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.grey400),
        prefixIcon: const Icon(Icons.search_rounded,
            color: AppColors.grey400, size: 20),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.grey400, size: 20),
                onPressed: _clear,
              )
            : null,
        filled: true,
        fillColor: AppColors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
