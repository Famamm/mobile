import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/inspection_history_bloc.dart';
import '../blocs/inspection_history_event.dart';
import '../blocs/inspection_history_state.dart';
import '../pages/inspection_history_detail_page.dart';
import '../widgets/cards/inspection_history_card.dart';
import '../widgets/states/inspection_empty_state.dart';
import '../widgets/states/inspection_error_state.dart';

class InspectionHistoryListSection extends StatelessWidget {
  const InspectionHistoryListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InspectionHistoryBloc, InspectionHistoryState>(
      builder: (context, state) {
        if (state.status == InspectionHistoryStatus2.loading) {
          return const Padding(
            padding: EdgeInsets.only(top: 48),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1A6BFF),
                strokeWidth: 2.5,
              ),
            ),
          );
        }

        if (state.status == InspectionHistoryStatus2.failure) {
          return InspectionErrorState(
            message: state.errorMessage ?? 'Terjadi kesalahan.',
            onRetry: () => context
                .read<InspectionHistoryBloc>()
                .add(const InspectionHistoryRefreshed()),
          );
        }

        if (state.isEmpty) {
          return InspectionEmptyState(
            message: state.searchQuery.isNotEmpty
                ? 'Tidak ada hasil untuk "${state.searchQuery}"'
                : 'Belum ada riwayat inspeksi.',
          );
        }

        return Column(
          children: state.histories
              .map((item) => InspectionHistoryCard(
                    key: ValueKey(item.id),
                    item: item,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => InspectionHistoryDetailPage(
                            inspectionId: item.id,
                          ),
                        ),
                      );
                    },
                  ))
              .toList(),
        );
      },
    );
  }
}
