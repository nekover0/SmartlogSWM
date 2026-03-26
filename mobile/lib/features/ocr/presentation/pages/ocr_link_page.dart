import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/features/ocr/application/controllers/ocr_inbox_controller.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/contracts/ocr_record_contract.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/repositories/ocr_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/ocr/domain/repositories/ocr_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

class OcrLinkPage extends ConsumerStatefulWidget {
  const OcrLinkPage({super.key, required this.ocrId});

  final String ocrId;

  @override
  ConsumerState<OcrLinkPage> createState() => _OcrLinkPageState();
}

class _OcrLinkPageState extends ConsumerState<OcrLinkPage> {
  OcrRecordEntity? _record;
  Object? _error;
  bool _isLinking = false;
  LinkedTargetType _targetType = LinkedTargetType.receipt;
  String? _selectedTargetNo;

  OcrRepository get _repository => ref.read(ocrRepositoryProvider);

  @override
  void initState() {
    super.initState();
    _loadRecord();
  }

  Future<void> _loadRecord() async {
    setState(() {
      _error = null;
    });

    try {
      final record = await _repository.getRecordById(widget.ocrId);
      if (!mounted) {
        return;
      }

      final defaultType = record.direction == DocumentDirection.inbound
          ? LinkedTargetType.receipt
          : LinkedTargetType.shipment;
      final options = _targetOptions(defaultType);

      setState(() {
        _record = record;
        _targetType = defaultType;
        _selectedTargetNo = options.isEmpty ? null : options.first;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final record = _record;

    if (_error != null && record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Liên kết OCR')),
        body: AppErrorState(
          title: 'Không tải được bản OCR',
          message: '$_error',
          onRetry: _loadRecord,
        ),
      );
    }

    if (record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Liên kết OCR')),
        body: const AppLoadingView(message: 'Đang tải thông tin liên kết...'),
      );
    }

    final options = _targetOptions(_targetType);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('ocr_link_back_button'),
          tooltip: 'Quay lại',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutePaths.ocrInbox);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Liên kết OCR'),
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          _RecordSummaryCard(record: record),
          const SizedBox(height: AppSpacing.md),
          _TargetTypeCard(
            selectedType: _targetType,
            onSelectType: (targetType) {
              final nextOptions = _targetOptions(targetType);
              setState(() {
                _targetType = targetType;
                _selectedTargetNo = nextOptions.isEmpty
                    ? null
                    : nextOptions.first;
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _targetType == LinkedTargetType.receipt
                        ? 'Liên kết vào phiếu nhập'
                        : 'Liên kết vào phiếu xuất',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedTargetNo,
                    items: options
                        .map(
                          (option) => DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (value) {
                      setState(() {
                        _selectedTargetNo = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Chọn chứng từ đích',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLinking
                              ? null
                              : () {
                                  final route =
                                      _targetType == LinkedTargetType.receipt
                                      ? AppRoutePaths.receiptCreate
                                      : AppRoutePaths.shipmentCreate;
                                  context.push(route);
                                },
                          icon: const Icon(Icons.add_box_outlined),
                          label: const Text('Tạo mới từ OCR'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _isLinking || _selectedTargetNo == null
                              ? null
                              : _linkRecord,
                          icon: _isLinking
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.link_rounded),
                          label: Text(
                            _isLinking ? 'Đang liên kết...' : 'Liên kết',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _targetOptions(LinkedTargetType targetType) {
    return switch (targetType) {
      LinkedTargetType.receipt => const <String>[
        'RCP-20260326-001',
        'RCP-20260326-002',
        'RCP-20260326-003',
      ],
      LinkedTargetType.shipment => const <String>[
        'SHP-20260326-011',
        'SHP-20260326-012',
        'SHP-20260326-013',
      ],
      LinkedTargetType.none => const <String>[],
    };
  }

  Future<void> _linkRecord() async {
    final record = _record;
    final targetNo = _selectedTargetNo;
    if (record == null || targetNo == null) {
      return;
    }

    setState(() {
      _isLinking = true;
    });

    try {
      await _repository.linkRecord(
        recordId: record.id,
        targetType: _targetType,
        targetId: targetNo,
        targetNo: targetNo,
      );

      ref.invalidate(ocrInboxControllerProvider);

      if (!mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Liên kết thành công'),
            content: Text('Đã liên kết bản OCR vào $targetNo.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  this.context.go(AppRoutePaths.ocrInbox);
                },
                child: const Text('Về inbox'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  this.context.go(
                    _targetType == LinkedTargetType.receipt
                        ? AppRoutePaths.receiptList
                        : AppRoutePaths.shipmentList,
                  );
                },
                child: const Text('Mở luồng liên quan'),
              ),
            ],
          );
        },
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLinking = false;
        });
      }
    }
  }
}

class _RecordSummaryCard extends StatelessWidget {
  const _RecordSummaryCard({required this.record});

  final OcrRecordEntity record;

  @override
  Widget build(BuildContext context) {
    final extracted = record.extractedFields;

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin OCR đã xác nhận',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(label: 'Số phiếu', value: extracted.documentNo),
            _SummaryRow(label: 'Biển số', value: extracted.vehiclePlate),
            _SummaryRow(label: 'Mã hàng', value: extracted.itemCode),
            _SummaryRow(
              label: 'Khối lượng net',
              value: extracted.netWeightKg?.toStringAsFixed(0),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                record.direction == DocumentDirection.inbound
                    ? 'Đề xuất liên kết Phiếu nhập'
                    : 'Đề xuất liên kết Phiếu xuất',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final normalizedValue = value?.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              normalizedValue == null || normalizedValue.isEmpty
                  ? 'Chưa có'
                  : normalizedValue,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetTypeCard extends StatelessWidget {
  const _TargetTypeCard({
    required this.selectedType,
    required this.onSelectType,
  });

  final LinkedTargetType selectedType;
  final ValueChanged<LinkedTargetType> onSelectType;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loại chứng từ đích',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Phiếu nhập')),
                    selected: selectedType == LinkedTargetType.receipt,
                    onSelected: (_) => onSelectType(LinkedTargetType.receipt),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Phiếu xuất')),
                    selected: selectedType == LinkedTargetType.shipment,
                    onSelected: (_) => onSelectType(LinkedTargetType.shipment),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
