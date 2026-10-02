import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:shared/shared.dart';

import 'package:fleetops_mobile/injection_container.dart';
import '../../data/models/inspection_history_detail_model.dart';
import '../widgets/cards/inspection_detail_vehicle_card.dart';
import '../widgets/cards/inspection_score_card.dart';
import '../widgets/inspection_category_accordion.dart';
import '../widgets/inspection_photo_section.dart';

class InspectionHistoryDetailPage extends StatefulWidget {
  final String inspectionId;

  const InspectionHistoryDetailPage({super.key, required this.inspectionId});

  static const String routeName = '/inspection-history-detail';

  @override
  State<InspectionHistoryDetailPage> createState() =>
      _InspectionHistoryDetailPageState();
}

class _InspectionHistoryDetailPageState
    extends State<InspectionHistoryDetailPage> {
  late Future<InspectionHistoryDetailModel> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchDetail();
  }

  Future<InspectionHistoryDetailModel> _fetchDetail() async {
    final response = await sl<HttpService>().get(
      ApiConfig.driverGetInspectionByIdEndpoint.replaceFirst(
        '{inspectionId}',
        widget.inspectionId,
      ),
    );
    final json = response as Map<String, dynamic>;
    return InspectionHistoryDetailModel.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: CustomSimpleAppBar(title: 'Detail Inspeksi'),
      body: FutureBuilder<InspectionHistoryDetailModel>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat detail inspeksi.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _future = _fetchDetail()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final detail = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InspectionDetailVehicleCard(detail: detail),
                const SizedBox(height: 12),
                InspectionScoreCard(score: detail.completionScore),
                const SizedBox(height: 12),
                ...detail.categories.map(
                  (cat) => InspectionCategoryAccordion(category: cat),
                ),
                if (detail.photoUrls.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  InspectionPhotoSection(photoUrls: detail.photoUrls),
                ],
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
