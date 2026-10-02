import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleetops_mobile/features/inspection/presentation/pages/inspection_page.dart';
import 'package:fleetops_mobile/features/inspection/presentation/blocs/inspection_bloc.dart';
import 'package:fleetops_mobile/injection_container.dart';

class InspectionPageWrapper extends StatelessWidget {
  const InspectionPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<InspectionBloc>(),
      child: const InspectionPage(),
    );
  }
}
