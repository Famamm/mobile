import 'package:core/core.dart';
import 'custom_button.dart';
import 'custom_card.dart';
import 'package:flutter/material.dart';

class CustomCardForm extends StatelessWidget {
  final String title;
  final List<Widget> formFields;
  final VoidCallback? onSubmit;

  const CustomCardForm({
    super.key,
    required this.title,
    required this.formFields,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          Divider(color: AppColors.bgprimary, thickness: 1, height: 24),
          Column(
            children: [
              ...formFields
                  .toList(),
              if (onSubmit != null)
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    onPressed: onSubmit,
                    text: 'Submit',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
