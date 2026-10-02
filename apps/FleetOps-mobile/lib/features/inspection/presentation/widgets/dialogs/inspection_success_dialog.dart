// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fleetops_mobile/core/themes/app_colors.dart';
// import 'package:fleetops_mobile/features/inspection/presentation/widgets/utils/inspection_constans.dart';
// import 'package:fleetops_mobile/features/navigation/presentation/blocs/bottom_nav_cubit.dart';

// class InspectionSuccessDialog extends StatelessWidget {
//   final BuildContext parentContext;
//   final String message;

//   const InspectionSuccessDialog({
//     super.key,
//     required this.parentContext,
//     required this.message,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: AppColors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       title: const Text(
//         InspectionStrings.inspectionComplete,
//         style: TextStyle(
//           fontWeight: FontWeight.w700,
//           color: AppColors.textPrimary,
//         ),
//       ),
//       content: Text(
//         message,
//         style: const TextStyle(
//           color: AppColors.textSecondary,
//           height: 1.5,
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//             context.read<BottomNavCubit>().changeTab(1);
//           },
//           child: const Text(
//             InspectionStrings.continueToTrip,
//             style: TextStyle(color: AppColors.primary),
//           ),
//         ),
//       ],
//     );
//   }
// }
