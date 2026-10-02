import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import '../blocs/inspection_history_bloc.dart';
import '../blocs/inspection_history_event.dart';
import '../blocs/inspection_history_state.dart';

class InspectionHistoryHeaderSection extends StatefulWidget {
  const InspectionHistoryHeaderSection({super.key});

  @override
  State<InspectionHistoryHeaderSection> createState() =>
      _InspectionHistoryHeaderSectionState();
}

class _InspectionHistoryHeaderSectionState
    extends State<InspectionHistoryHeaderSection> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionHistoryBloc, InspectionHistoryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Inspeksi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            SearchBarField(
              controller: _searchController,
              hintText: 'Cari kendaraan atau tanggal (15-06-2026)...',
              onChanged: (val) => context
                  .read<InspectionHistoryBloc>()
                  .add(InspectionHistorySearchChanged(val)),
            ),
          ],
        );
      },
    );
  }
}
