import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleetops_mobile/injection_container.dart';
import 'package:core/core.dart';

import '../../data/data_sources/inspection_history_remote_data_source.dart';
import '../../data/repositories/inspection_history_repository_impl.dart';
import '../../domain/usecases/get_inspection_histories_usecase.dart';
import '../../domain/usecases/get_inspection_summary_usecase.dart';
import '../blocs/inspection_history_bloc.dart';
import '../blocs/inspection_history_event.dart';
import '../blocs/inspection_history_state.dart';
import '../sections/inspection_history_header_section.dart';
import '../sections/inspection_history_list_section.dart';
import '../widgets/cards/inspection_summary_card.dart';

class InspectionHistoryPage extends StatelessWidget {
  const InspectionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final repo = InspectionHistoryRepositoryImpl(
          remoteDataSource: InspectionHistoryRemoteDataSourceImpl(
            httpService: sl<HttpService>(),
          ),
        );
        return InspectionHistoryBloc(
          getHistories: GetInspectionHistoriesUseCase(repo),
          getSummary: GetInspectionSummaryUseCase(repo),
        )..add(const InspectionHistoryStarted());
      },
      child: const _InspectionHistoryView(),
    );
  }
}

class _InspectionHistoryView extends StatelessWidget {
  const _InspectionHistoryView();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        context
            .read<InspectionHistoryBloc>()
            .add(const InspectionHistoryRefreshed());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InspectionHistoryHeaderSection(),
            const SizedBox(height: 16),
            BlocBuilder<InspectionHistoryBloc, InspectionHistoryState>(
              buildWhen: (prev, curr) => prev.summary != curr.summary,
              builder: (context, state) {
                if (state.summary == null) return const SizedBox();
                return Column(
                  children: [
                    InspectionSummaryCard(summary: state.summary!),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
            const InspectionHistoryListSection(),
          ],
        ),
      ),
    );
  }
}
