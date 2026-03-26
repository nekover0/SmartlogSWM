import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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

class OcrReviewPage extends ConsumerStatefulWidget {
  const OcrReviewPage({super.key, required this.ocrId});

  final String ocrId;

  @override
  ConsumerState<OcrReviewPage> createState() => _OcrReviewPageState();
}

class _OcrReviewPageState extends ConsumerState<OcrReviewPage> {
  final TextEditingController _documentNoController = TextEditingController();
  final TextEditingController _vehiclePlateController = TextEditingController();
  final TextEditingController _itemCodeController = TextEditingController();
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _grossWeightController = TextEditingController();
  final TextEditingController _netWeightController = TextEditingController();

  OcrRecordEntity? _record;
  bool _isSaving = false;
  bool _isCompletingProcessing = false;
  Object? _error;

  OcrRepository get _repository => ref.read(ocrRepositoryProvider);

  @override
  void initState() {
    super.initState();
    unawaited(_loadRecord());
  }

  @override
  void dispose() {
    _documentNoController.dispose();
    _vehiclePlateController.dispose();
    _itemCodeController.dispose();
    _itemNameController.dispose();
    _grossWeightController.dispose();
    _netWeightController.dispose();
    super.dispose();
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

      setState(() {
        _record = record;
        _bindControllers(record.extractedFields);
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

  void _bindControllers(OcrExtractedFieldsEntity fields) {
    _documentNoController.text = fields.documentNo ?? '';
    _vehiclePlateController.text = fields.vehiclePlate ?? '';
    _itemCodeController.text = fields.itemCode ?? '';
    _itemNameController.text = fields.itemName ?? '';
    _grossWeightController.text = fields.grossWeightKg?.toString() ?? '';
    _netWeightController.text = fields.netWeightKg?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final record = _record;

    if (_error != null && record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review OCR')),
        body: AppErrorState(
          title: 'Không tải được bản OCR',
          message: '$_error',
          onRetry: _loadRecord,
        ),
      );
    }

    if (record == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Review OCR')),
        body: const AppLoadingView(message: 'Đang tải dữ liệu OCR...'),
      );
    }

    final flagsByField = <String, FieldReviewFlag>{
      for (final flag in record.reviewFlags) flag.fieldName: flag,
    };

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('ocr_review_back_button'),
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
        title: const Text('Review OCR'),
        actions: [
          IconButton(
            tooltip: 'Tải lại',
            onPressed: _loadRecord,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          _RecordHeader(record: record),
          const SizedBox(height: AppSpacing.md),
          if (record.status == OcrRecordStatus.processing)
            _ProcessingCard(
              isCompletingProcessing: _isCompletingProcessing,
              onComplete: _completeProcessing,
            )
          else ...[
            _FieldEditorCard(
              title: 'Số phiếu',
              controller: _documentNoController,
              hint: 'RCP-20260326-001',
              flag: flagsByField['documentNo'],
            ),
            const SizedBox(height: AppSpacing.sm),
            _FieldEditorCard(
              title: 'Biển số xe',
              controller: _vehiclePlateController,
              hint: '51D-123.45',
              flag: flagsByField['vehiclePlate'],
            ),
            const SizedBox(height: AppSpacing.sm),
            _FieldEditorCard(
              title: 'Mã hàng',
              controller: _itemCodeController,
              hint: 'SKU-COIL-01',
              flag: flagsByField['itemCode'],
            ),
            const SizedBox(height: AppSpacing.sm),
            _FieldEditorCard(
              title: 'Tên hàng',
              controller: _itemNameController,
              hint: 'Steel Coil 5T',
              flag: flagsByField['itemName'],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _FieldEditorCard(
                    title: 'Gross (kg)',
                    controller: _grossWeightController,
                    hint: '12450',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    flag: flagsByField['grossWeightKg'],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _FieldEditorCard(
                    title: 'Net (kg)',
                    controller: _netWeightController,
                    hint: '11820',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    flag: flagsByField['netWeightKg'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _ImagePreviewCard(record: record),
            const SizedBox(height: AppSpacing.md),
            _ActionSection(
              isSaving: _isSaving,
              onSaveDraft: () => _saveRecord(OcrRecordStatus.reviewRequired),
              onConfirmAndLink: _confirmAndGoLink,
              onReject: _rejectRecord,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _completeProcessing() async {
    final record = _record;
    if (record == null || _isCompletingProcessing) {
      return;
    }

    setState(() {
      _isCompletingProcessing = true;
    });

    try {
      final updated = await _repository.completeProcessing(record.id);
      if (!mounted) {
        return;
      }

      setState(() {
        _record = updated;
        _bindControllers(updated.extractedFields);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OCR đã trích xuất xong, kiểm tra lại field.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCompletingProcessing = false;
        });
      }
    }
  }

  Future<void> _saveRecord(OcrRecordStatus status) async {
    final record = _record;
    if (record == null || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final extractedFields = OcrExtractedFieldsEntity(
      documentNo: _normalize(_documentNoController.text),
      vehiclePlate: _normalize(_vehiclePlateController.text),
      ownerCode: record.extractedFields.ownerCode,
      ownerName: record.extractedFields.ownerName,
      itemCode: _normalize(_itemCodeController.text),
      itemName: _normalize(_itemNameController.text),
      grossWeightKg: _parseDouble(_grossWeightController.text),
      netWeightKg: _parseDouble(_netWeightController.text),
    );

    final reviewFlags = _buildReviewFlags(extractedFields);

    try {
      final updated = await _repository.saveReview(
        recordId: record.id,
        extractedFields: extractedFields,
        reviewFlags: reviewFlags,
        status: status,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _record = updated;
      });

      ref.invalidate(ocrInboxControllerProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == OcrRecordStatus.confirmed
                ? 'Đã xác nhận dữ liệu OCR.'
                : 'Đã lưu nháp OCR.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _confirmAndGoLink() async {
    await _saveRecord(OcrRecordStatus.confirmed);

    if (!mounted) {
      return;
    }

    final record = _record;
    if (record == null) {
      return;
    }

    unawaited(context.push(AppRoutePaths.ocrLinkPath(record.id)));
  }

  Future<void> _rejectRecord() async {
    final record = _record;
    if (record == null || _isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _repository.rejectRecord(
        recordId: record.id,
        reason: 'Người dùng từ chối do ảnh mờ/thiếu thông tin.',
      );
      ref.invalidate(ocrInboxControllerProvider);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã từ chối bản OCR này.')));
      context.go(AppRoutePaths.ocrInbox);
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  List<FieldReviewFlag> _buildReviewFlags(OcrExtractedFieldsEntity fields) {
    final flags = <FieldReviewFlag>[];

    void addFlagIfNeeded({
      required String fieldName,
      required String? value,
      required double score,
    }) {
      final normalizedValue = value?.trim();
      if (normalizedValue == null || normalizedValue.isEmpty || score < 0.7) {
        flags.add(
          FieldReviewFlag(
            fieldName: fieldName,
            rawValue: value,
            confidenceScore: score,
            level: score < 0.7 ? ConfidenceLevel.low : ConfidenceLevel.medium,
            requiredReview: true,
          ),
        );
      }
    }

    addFlagIfNeeded(
      fieldName: 'documentNo',
      value: fields.documentNo,
      score: fields.documentNo == null ? 0.5 : 0.92,
    );
    addFlagIfNeeded(
      fieldName: 'vehiclePlate',
      value: fields.vehiclePlate,
      score: fields.vehiclePlate == null ? 0.5 : 0.68,
    );
    addFlagIfNeeded(
      fieldName: 'itemCode',
      value: fields.itemCode,
      score: fields.itemCode == null ? 0.58 : 0.82,
    );

    return flags;
  }

  String? _normalize(String text) {
    final value = text.trim();
    if (value.isEmpty) {
      return null;
    }
    return value;
  }

  double? _parseDouble(String text) {
    final normalized = text.trim().replaceAll(',', '');
    if (normalized.isEmpty) {
      return null;
    }

    return double.tryParse(normalized);
  }
}

class _RecordHeader extends StatelessWidget {
  const _RecordHeader({required this.record});

  final OcrRecordEntity record;

  static final DateFormat _dateTimeFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (record.status) {
      OcrRecordStatus.reviewRequired => AppColors.warning,
      OcrRecordStatus.failed => AppColors.danger,
      OcrRecordStatus.linked => AppColors.success,
      OcrRecordStatus.confirmed => AppColors.info,
      OcrRecordStatus.rejected => AppColors.textSecondary,
      OcrRecordStatus.processing => AppColors.info,
      OcrRecordStatus.extracted => AppColors.info,
      OcrRecordStatus.captured => AppColors.info,
      OcrRecordStatus.relinkRequired => AppColors.warning,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        color: AppColors.surface,
      ),
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          _MetaPill(icon: Icons.document_scanner_outlined, text: record.id),
          _MetaPill(
            icon: Icons.swap_horiz_rounded,
            text: record.direction == DocumentDirection.inbound
                ? 'Nhập'
                : 'Xuất',
          ),
          _MetaPill(
            icon: Icons.timelapse_rounded,
            text: _dateTimeFormat.format(record.capturedAt),
          ),
          _MetaPill(
            icon: Icons.verified_outlined,
            text:
                'Confidence ${(record.confidenceScore * 100).toStringAsFixed(0)}%',
            color: statusColor,
          ),
        ],
      ),
    );
  }
}

class _ProcessingCard extends StatelessWidget {
  const _ProcessingCard({
    required this.isCompletingProcessing,
    required this.onComplete,
  });

  final bool isCompletingProcessing;
  final Future<void> Function() onComplete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.md),
            Text(
              'OCR đang xử lý ảnh và trích xuất dữ liệu...',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: isCompletingProcessing ? null : onComplete,
              icon: isCompletingProcessing
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.bolt_rounded),
              label: const Text('Giả lập hoàn tất OCR'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldEditorCard extends StatelessWidget {
  const _FieldEditorCard({
    required this.title,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.flag,
  });

  final String title;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final FieldReviewFlag? flag;

  @override
  Widget build(BuildContext context) {
    final requiresReview = flag?.requiredReview == true;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: requiresReview
              ? AppColors.warning.withValues(alpha: 0.55)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (requiresReview)
                Text(
                  'Low confidence',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.warning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
}

class _ImagePreviewCard extends StatelessWidget {
  const _ImagePreviewCard({required this.record});

  final OcrRecordEntity record;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ảnh gốc',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.background,
                border: Border.all(color: AppColors.border),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.image_search_outlined,
                      size: 36,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      record.sourceImageUrl,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.isSaving,
    required this.onSaveDraft,
    required this.onConfirmAndLink,
    required this.onReject,
  });

  final bool isSaving;
  final Future<void> Function() onSaveDraft;
  final Future<void> Function() onConfirmAndLink;
  final Future<void> Function() onReject;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isSaving ? null : onSaveDraft,
                    child: const Text('Lưu nháp'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: isSaving ? null : onConfirmAndLink,
                    child: Text(isSaving ? 'Đang lưu...' : 'Liên kết chứng từ'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: isSaving ? null : onReject,
              icon: const Icon(Icons.block_rounded),
              label: const Text('Từ chối bản OCR'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.text,
    this.color = AppColors.textSecondary,
  });

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
