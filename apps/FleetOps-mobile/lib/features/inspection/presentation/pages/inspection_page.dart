import 'package:core/core.dart';
import 'package:shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fleetops_mobile/injection_container.dart';

import '../../../navigation/presentation/blocs/bottom_nav_cubit.dart';
import '../../../navigation/presentation/blocs/bottom_nav_state.dart';
import '../../domain/entities/inspection_item_entity.dart';
import '../../domain/repositories/inspection_repository.dart';
import '../blocs/inspection_bloc.dart';
import '../blocs/inspection_event.dart';
import '../blocs/inspection_state.dart';
import '../sections/inspection_category_tabs.dart';
import '../sections/inspection_checklist_container.dart';
import '../sections/inspection_progress_section.dart';
import '../sections/inspection_submit_section.dart';
import '../widgets/buttons/inspection_status_button.dart';
import '../widgets/categories/inspection_categories.dart';
import '../widgets/dialogs/already_inspected_dialog.dart';
import '../widgets/dialogs/continue_update_dialog.dart';
import '../widgets/dialogs/inspection_loading_dialog.dart';
import '../widgets/screens/no_vehicle_selected_screen.dart';
import '../widgets/utils/image_picker_handler.dart';
import '../widgets/utils/inspection_constans.dart';
import '../widgets/utils/inspection_validator.dart';



class InspectionPage extends StatefulWidget {
  final ValueNotifier<bool>? inspectionInProgress;

  const InspectionPage({super.key, this.inspectionInProgress});

  static String routeName = '/inspection';

  @override
  State<InspectionPage> createState() => _InspectionPageState();
}

class _InspectionPageState extends State<InspectionPage> {
  // ── State ──────────────────────────────────────────────────────────────────
  InspectionCategory _selectedCategory = InspectionCategory.eksterior;

  bool _loadingItems = true;
  bool _isSubmitted = false;
  bool _isUpdating = false;
  int? _todayInspectionId;
  final Map<String, InspectionItemEntity> _itemsById = {};
  final Map<String, TextEditingController> _noteControllers = {};
  final Set<String> _expandedItemIds = {};
  final _imagePicker = ImagePicker();

  int get _vehicleId => sl<TokenService>().getActiveVehicleId() ?? 0;
  int get _driverId => sl<TokenService>().getDriverId() ?? 0;

  @override
  void initState() {
    super.initState();
    _loadItemsFromApi();
  }

  Future<void> _loadItemsFromApi() async {
    try {
      final repo = sl<InspectionRepository>();
      final apiItems = await repo.getInspectionItems();
      if (!mounted) return;
      setState(() {
        _itemsById.clear();
        _noteControllers.clear();
        for (final item in apiItems) {
          _itemsById[item.id] = item;
          _noteControllers[item.id] = TextEditingController(
            text: item.note ?? '',
          );
        }
        _loadingItems = false;
      });
      // Hanya tandai inspeksi sedang berjalan jika kendaraan sudah dipilih
      if (sl<TokenService>().getActiveVehicleId() != null) {
        widget.inspectionInProgress?.value = true;
      }
    } catch (_) {
      // fallback ke hardcoded jika API gagal
      if (!mounted) return;
      setState(() {
        for (final category in InspectionCategory.values) {
          for (final name in category.items) {
            final id = '${category.name}:$name';
            final item = InspectionItemEntity(
              id: id,
              name: name,
              category: category.name,
            );
            _itemsById[id] = item;
            _noteControllers[id] = TextEditingController(text: '');
          }
        }
        _loadingItems = false;
      });
    }
  }

  Future<void> _checkAlreadyInspectedToday(InspectionRepository repo) async {
    if (_driverId == 0) return;
    final activeVehicleId = sl<TokenService>().getActiveVehicleId();
    if (activeVehicleId == null) return;
    try {
      final inspections = await repo.getInspectionsByDriver(_driverId);
      if (!mounted) return;
      final today = DateTime.now();
      // Inspeksi dianggap selesai hanya jika ada untuk kendaraan aktif hari ini
      final todayInspection = inspections.where((i) {
        if (i.vehicleId != activeVehicleId) return false;
        final d = (i.createdAt ?? i.inspectionDate).toLocal();
        return d.year == today.year &&
            d.month == today.month &&
            d.day == today.day;
      }).firstOrNull;

      if (todayInspection != null) {
        _todayInspectionId = todayInspection.id;
        widget.inspectionInProgress?.value = false;
        if (!mounted) return;
        _showAlreadyInspectedDialog();
      } else {
        // Reset state jika kendaraan berbeda — belum inspeksi untuk kendaraan ini
        _todayInspectionId = null;
        if (mounted) setState(() => _isSubmitted = false);
      }
    } catch (_) {}
  }

  void _showAlreadyInspectedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlreadyInspectedDialog(
        onUpdatePressed: () {
          Navigator.pop(ctx);
          setState(() {
            _isSubmitted = false;
            _isUpdating = true;
          });
          widget.inspectionInProgress?.value = true;
        },
        onContinuePressed: () {
          Navigator.pop(ctx);
          context.read<BottomNavCubit>().changeTab(1);
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _noteControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // ── Computed ───────────────────────────────────────────────────────────────

  int get _totalItems {
    return _itemsById.length;
  }

  int get _completedItems {
    return InspectionValidator.countCompleted(_itemsById.values.toList());
  }

  bool _itemMatchesCategory(
    InspectionItemEntity item,
    InspectionCategory category,
  ) {
    return item.category.toLowerCase() == category.label.toLowerCase() ||
        item.category.toLowerCase() == category.name.toLowerCase();
  }

  Map<InspectionCategory, int> get _completedPerCategory {
    final result = <InspectionCategory, int>{};
    for (final category in InspectionCategory.values) {
      final count = _itemsById.values.where((item) {
        if (!_itemMatchesCategory(item, category)) return false;
        if (item.status == 'none') return false;
        if (item.status == 'ok') return true;
        if (item.status == 'not_ok') {
          final hasNote = item.note != null && item.note!.trim().isNotEmpty;
          final hasPhoto =
              item.photoPath != null && item.photoPath!.trim().isNotEmpty;
          return hasNote && hasPhoto;
        }
        return false;
      }).length;
      result[category] = count;
    }
    return result;
  }

  List<InspectionItemEntity> _itemsForCategory(InspectionCategory category) {
    return _itemsById.values
        .where((item) => _itemMatchesCategory(item, category))
        .toList();
  }

  String _statusToString(InspectionStatus status) {
    switch (status) {
      case InspectionStatus.ok:
        return 'ok';
      case InspectionStatus.notOk:
        return 'not_ok';
      case InspectionStatus.none:
        return 'none';
    }
  }

  bool _isExpanded(String itemId) {
    final item = _itemsById[itemId];
    if (item == null) {
      return false;
    }
    final hasDetails = (item.note?.trim().isNotEmpty ?? false) ||
        (item.photoPath?.trim().isNotEmpty ?? false);
    return _expandedItemIds.contains(itemId) || hasDetails;
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

  void _handleStatusChanged(String itemId, InspectionStatus status) {
    final item = _itemsById[itemId];
    if (item == null) {
      return;
    }
    setState(() {
      if (status == InspectionStatus.ok) {
        // Saat pindah ke OK: hapus catatan, foto, dan collapse
        _itemsById[itemId] = item.copyWith(
          status: _statusToString(status),
          note: null,
          photoPath: null,
        );
        _noteControllers[itemId]?.clear();
        _expandedItemIds.remove(itemId);
      } else {
        _itemsById[itemId] = item.copyWith(status: _statusToString(status));
        if (status == InspectionStatus.notOk) {
          _expandedItemIds.add(itemId);
        }
      }
    });

    if (status == InspectionStatus.notOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(InspectionStrings.notePhotoRequiredForNotOk),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleNoteChanged(String itemId, String note) {
    final item = _itemsById[itemId];
    if (item == null) {
      return;
    }
    final trimmed = note.trim();
    setState(() {
      _itemsById[itemId] = item.copyWith(
        note: trimmed.isEmpty ? null : trimmed,
      );
    });
  }

  void _handleToggleExpanded(String itemId) {
    setState(() {
      if (_expandedItemIds.contains(itemId)) {
        _expandedItemIds.remove(itemId);
      } else {
        _expandedItemIds.add(itemId);
      }
    });
  }

  Future<void> _handlePhotoTap(String itemId) async {
    final item = _itemsById[itemId];
    if (item == null) return;

    final source = await ImagePickerHandler(
      _imagePicker,
    ).showImageSourceBottomSheet(context);
    if (source == null) return;

    final picked = await ImagePickerHandler(_imagePicker).pickImage(source);
    if (picked == null) return;

    setState(() {
      _itemsById[itemId] = item.copyWith(photoPath: picked.path);
      _expandedItemIds.add(itemId);
    });
  }

  void _handleCategoryChanged(InspectionCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _handleSubmit() {
    // Validasi: item not_ok wajib ada catatan dan foto
    final invalidItems = InspectionValidator.getInvalidItems(
      _itemsById.values.toList(),
    );

    if (invalidItems.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            InspectionStrings.incompleteNotOkItems(invalidItems.length),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    final items = _itemsById.values.toList();
    if (_todayInspectionId != null) {
      // Update inspeksi yang sudah ada
      context.read<InspectionBloc>().add(
            UpdateInspectionEvent(
              inspectionId: _todayInspectionId!,
              vehicleId: _vehicleId,
              driverId: _driverId,
              items: items,
            ),
          );
    } else {
      // Buat inspeksi baru
      context.read<InspectionBloc>().add(
            SubmitInspectionEvent(
              vehicleId: _vehicleId,
              driverId: _driverId,
              items: items,
            ),
          );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_loadingItems) {
      return Scaffold(
        appBar: CustomAppBar(title: 'FleetOps'),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    // Blokir inspeksi jika belum pilih kendaraan
    final activeVehicleId = sl<TokenService>().getActiveVehicleId();
    if (activeVehicleId == null) {
      return NoVehicleSelectedScreen(
        driverId: _driverId,
        onReturnFromProfile: () {
          if (mounted) setState(() {});
        },
      );
    }

    final completedPerCategory = _completedPerCategory;
    final currentItems = _itemsForCategory(_selectedCategory);

    return BlocListener<BottomNavCubit, BottomNavState>(
      listener: (context, state) {
        if (state.index == 2) {
          final vehicleId = sl<TokenService>().getActiveVehicleId();
          if (vehicleId == null) return;
          if (_isUpdating) {
            ContinueUpdateDialog();
          } else {
            final repo = sl<InspectionRepository>();
            _checkAlreadyInspectedToday(repo);
          }
        }
      },
      child: BlocListener<InspectionBloc, InspectionState>(
        listener: (context, state) {
          if (state is InspectionLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const InspectionLoadingDialog(),
            );
          } else if (state is InspectionSuccess) {
            widget.inspectionInProgress?.value = false;
            setState(() {
              _isSubmitted = true;
              _isUpdating = false;
            });
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.success,
                content: Text('Item successfully updated!'),
              ),
            );
          } else if (state is InspectionError) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: CustomAppBar(title: 'FleetOps'),
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    // PROGRESS CARD
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: InspectionProgressSection(
                          totalItems: _totalItems,
                          completedItems: _completedItems,
                          vehicleId: _vehicleId.toString(),
                        ),
                      ),
                    ),

                    // SAFETY REMINDER
                    const SliverPadding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: TripSafetyReminderCard(),
                      ),
                    ),

                    // CATEGORY TABS
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: InspectionCategoryTabs(
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: _handleCategoryChanged,
                          completedPerCategory: completedPerCategory,
                        ),
                      ),
                    ),

                    // CHECKLIST
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      sliver: SliverToBoxAdapter(
                        child: InspectionChecklistContainer(
                          selectedCategory: _selectedCategory,
                          items: currentItems,
                          noteControllers: _noteControllers,
                          isExpanded: _isExpanded,
                          onToggleExpanded: _handleToggleExpanded,
                          onStatusChanged: _handleStatusChanged,
                          onNoteChanged: _handleNoteChanged,
                          onPhotoTap: _handlePhotoTap,
                          completedPerCategory: completedPerCategory,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InspectionSubmitSection(
                totalItems: _totalItems,
                completedItems: _completedItems,
                onSubmit: _handleSubmit,
                isSubmitted: _isSubmitted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
