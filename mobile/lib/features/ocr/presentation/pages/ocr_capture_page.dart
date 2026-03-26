import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/repositories/ocr_repository_impl.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_forbidden_state.dart';

class OcrCapturePage extends ConsumerStatefulWidget {
  const OcrCapturePage({super.key});

  @override
  ConsumerState<OcrCapturePage> createState() => _OcrCapturePageState();
}

class _OcrCapturePageState extends ConsumerState<OcrCapturePage> {
  DocumentDirection _direction = DocumentDirection.inbound;
  bool _cameraDenied = false;
  bool _flashEnabled = false;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    if (_cameraDenied) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            key: const Key('ocr_capture_back_button'),
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
          title: const Text('Chụp OCR'),
        ),
        body: AppForbiddenState(
          title: 'Chưa có quyền camera',
          message:
              'Cần cấp quyền camera để chụp chứng từ. Bạn vẫn có thể chọn ảnh từ thư viện.',
          retryLabel: 'Cấp quyền lại',
          onRetry: () {
            setState(() {
              _cameraDenied = false;
            });
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _isProcessing ? null : () => _capture(fromGallery: true),
          icon: const Icon(Icons.photo_library_outlined),
          label: const Text('Chọn ảnh'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('ocr_capture_back_button'),
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
        title: const Text('Chụp OCR'),
        actions: [
          IconButton(
            tooltip: _flashEnabled ? 'Tắt flash' : 'Bật flash',
            onPressed: () {
              setState(() {
                _flashEnabled = !_flashEnabled;
              });
            },
            icon: Icon(
              _flashEnabled ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            ),
          ),
          IconButton(
            tooltip: 'Giả lập từ chối camera',
            onPressed: () {
              setState(() {
                _cameraDenied = true;
              });
            },
            icon: const Icon(Icons.no_photography_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          _CaptureHintCard(direction: _direction),
          const SizedBox(height: AppSpacing.md),
          _DirectionSelector(
            selectedDirection: _direction,
            onSelect: (direction) {
              setState(() {
                _direction = direction;
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),
          _CameraPreviewMock(flashEnabled: _flashEnabled),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isProcessing
                      ? null
                      : () => _capture(fromGallery: true),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Chọn ảnh'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _isProcessing
                      ? null
                      : () => _capture(fromGallery: false),
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.camera_alt_rounded),
                  label: Text(_isProcessing ? 'Đang OCR...' : 'Chụp và xử lý'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Sau khi chụp sẽ chuyển ngay sang màn review để sửa nhanh các field confidence thấp.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Future<void> _capture({required bool fromGallery}) async {
    setState(() {
      _isProcessing = true;
    });

    final repository = ref.read(ocrRepositoryProvider);
    final captured = await repository.captureRecord(
      direction: _direction,
      fromGallery: fromGallery,
    );

    await Future<void>.delayed(const Duration(milliseconds: 420));

    if (!mounted) {
      return;
    }

    setState(() {
      _isProcessing = false;
    });

    unawaited(context.push(AppRoutePaths.ocrReviewPath(captured.id)));
  }
}

class _CaptureHintCard extends StatelessWidget {
  const _CaptureHintCard({required this.direction});

  final DocumentDirection direction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.tips_and_updates_outlined,
              color: AppColors.brand,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              direction == DocumentDirection.inbound
                  ? 'Canh đầy đủ số phiếu nhập, biển số xe và bảng cân để OCR nhận diện ổn định.'
                  : 'Canh rõ số phiếu xuất, kiện hàng và biển số để giảm thao tác sửa tay.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionSelector extends StatelessWidget {
  const _DirectionSelector({
    required this.selectedDirection,
    required this.onSelect,
  });

  final DocumentDirection selectedDirection;
  final ValueChanged<DocumentDirection> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ChoiceChip(
            label: const Center(child: Text('Chứng từ nhập')),
            selected: selectedDirection == DocumentDirection.inbound,
            onSelected: (_) => onSelect(DocumentDirection.inbound),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ChoiceChip(
            label: const Center(child: Text('Chứng từ xuất')),
            selected: selectedDirection == DocumentDirection.outbound,
            onSelected: (_) => onSelect(DocumentDirection.outbound),
          ),
        ),
      ],
    );
  }
}

class _CameraPreviewMock extends StatelessWidget {
  const _CameraPreviewMock({required this.flashEnabled});

  final bool flashEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF0E1628),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x6620304A), Color(0x990C1422)],
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 250,
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: flashEnabled ? AppColors.warning : AppColors.surface,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.document_scanner_outlined,
                    color: flashEnabled ? AppColors.warning : AppColors.surface,
                    size: 42,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Canh chứng từ vào khung',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.surface),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: AppSpacing.md,
            right: AppSpacing.md,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    flashEnabled
                        ? Icons.flash_on_rounded
                        : Icons.flash_off_rounded,
                    size: 14,
                    color: AppColors.surface,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    flashEnabled ? 'Flash bật' : 'Flash tắt',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.surface),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
