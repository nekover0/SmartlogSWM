import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class InventoryControlFlowPage extends StatefulWidget {
  const InventoryControlFlowPage({super.key, required this.mode});

  final String mode;

  @override
  State<InventoryControlFlowPage> createState() =>
      _InventoryControlFlowPageState();
}

class _InventoryControlFlowPageState extends State<InventoryControlFlowPage> {
  final TextEditingController _objectCodeController = TextEditingController();
  final TextEditingController _manualCodeController = TextEditingController();
  final TextEditingController _countQtyController = TextEditingController();
  final TextEditingController _sourceLocationController = TextEditingController(
    text: 'A1-01-02',
  );
  final TextEditingController _targetLocationController =
      TextEditingController();
  final TextEditingController _adjustQtyController = TextEditingController();

  int _currentStep = 0;
  bool _isSubmitting = false;
  bool _isSuccess = false;
  bool _scanFound = false;
  bool _scanNotFound = false;
  String? _validationMessage;
  String _statusBefore = 'available';
  String _statusAfter = 'hold';
  String _adjustReason = 'stock_take';
  String? _transactionNo;

  late final InventoryControlMode _mode = InventoryControlModeX.fromPath(
    widget.mode,
  );

  @override
  void dispose() {
    _objectCodeController.dispose();
    _manualCodeController.dispose();
    _countQtyController.dispose();
    _sourceLocationController.dispose();
    _targetLocationController.dispose();
    _adjustQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _mode.title;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('inventory_control_flow_back_button'),
          tooltip: 'Quay lại',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutePaths.inventoryControl);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(title),
      ),
      body: _isSuccess
          ? _SuccessView(
              mode: _mode,
              transactionNo:
                  _transactionNo ??
                  'IC-${DateTime.now().millisecondsSinceEpoch}',
              onScanNext: _resetForNext,
              onBackToHub: () => context.go(AppRoutePaths.inventoryControl),
            )
          : ListView(
              padding: AppSpacing.pagePadding,
              children: [
                _FlowHeader(mode: _mode),
                const SizedBox(height: AppSpacing.md),
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(
                      context,
                    ).colorScheme.copyWith(primary: AppColors.brand),
                  ),
                  child: Stepper(
                    physics: const NeverScrollableScrollPhysics(),
                    currentStep: _currentStep,
                    onStepTapped: (step) {
                      if (step <= _currentStep) {
                        setState(() {
                          _currentStep = step;
                        });
                      }
                    },
                    controlsBuilder: (context, details) {
                      return _StepperControls(
                        currentStep: _currentStep,
                        isSubmitting: _isSubmitting,
                        canGoBack: _currentStep > 0,
                        onBack: () {
                          setState(() {
                            _currentStep -= 1;
                          });
                        },
                        onNext: _goNext,
                        onSubmit: _submit,
                      );
                    },
                    steps: [
                      Step(
                        isActive: _currentStep >= 0,
                        state: _stepState(0),
                        title: const Text('Bước 1: Xác định đối tượng'),
                        content: _StepObjectSection(
                          objectCodeController: _objectCodeController,
                          manualCodeController: _manualCodeController,
                          scanFound: _scanFound,
                          scanNotFound: _scanNotFound,
                          onSimulateScanFound: _simulateScanFound,
                          onSimulateScanNotFound: _simulateScanNotFound,
                        ),
                      ),
                      Step(
                        isActive: _currentStep >= 1,
                        state: _stepState(1),
                        title: const Text('Bước 2: Nhập dữ liệu nghiệp vụ'),
                        content: _StepBusinessSection(
                          mode: _mode,
                          countQtyController: _countQtyController,
                          sourceLocationController: _sourceLocationController,
                          targetLocationController: _targetLocationController,
                          adjustQtyController: _adjustQtyController,
                          statusBefore: _statusBefore,
                          statusAfter: _statusAfter,
                          adjustReason: _adjustReason,
                          onStatusBeforeChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _statusBefore = value;
                            });
                          },
                          onStatusAfterChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _statusAfter = value;
                            });
                          },
                          onAdjustReasonChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _adjustReason = value;
                            });
                          },
                        ),
                      ),
                      Step(
                        isActive: _currentStep >= 2,
                        state: _stepState(2),
                        title: const Text('Bước 3: Review và xác nhận'),
                        content: _StepReviewSection(
                          mode: _mode,
                          objectCode: _resolveObjectCode(),
                          countedQty: _countQtyController.text.trim(),
                          sourceLocation: _sourceLocationController.text.trim(),
                          targetLocation: _targetLocationController.text.trim(),
                          statusBefore: _statusBefore,
                          statusAfter: _statusAfter,
                          adjustQty: _adjustQtyController.text.trim(),
                          adjustReason: _adjustReason,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_validationMessage != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _validationMessage!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  StepState _stepState(int step) {
    if (_currentStep > step) {
      return StepState.complete;
    }
    if (_currentStep == step) {
      return StepState.editing;
    }
    return StepState.indexed;
  }

  void _simulateScanFound() {
    setState(() {
      _scanFound = true;
      _scanNotFound = false;
      _validationMessage = null;
      if (_objectCodeController.text.trim().isEmpty) {
        _objectCodeController.text = 'SKU-COIL-01';
      }
    });
  }

  void _simulateScanNotFound() {
    setState(() {
      _scanFound = false;
      _scanNotFound = true;
      _validationMessage = 'Không tìm thấy mã. Hãy nhập tay mã hợp lệ.';
    });
  }

  void _goNext() {
    final isValid = switch (_currentStep) {
      0 => _validateStep1(),
      1 => _validateStep2(),
      _ => true,
    };

    if (!isValid) {
      return;
    }

    setState(() {
      _validationMessage = null;
      _currentStep += 1;
    });
  }

  Future<void> _submit() async {
    if (!_validateStep3()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _validationMessage = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) {
      return;
    }

    final now = DateTime.now();
    setState(() {
      _isSubmitting = false;
      _isSuccess = true;
      _transactionNo =
          'IC-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecond.toString().padLeft(4, '0')}';
    });
  }

  bool _validateStep1() {
    final objectCode = _resolveObjectCode();
    if (objectCode == null || objectCode.isEmpty) {
      setState(() {
        _validationMessage =
            'Vui lòng quét hoặc nhập mã SKU/vị trí trước khi tiếp tục.';
      });
      return false;
    }

    setState(() {
      _scanNotFound = false;
      _scanFound = true;
    });
    return true;
  }

  bool _validateStep2() {
    final message = switch (_mode) {
      InventoryControlMode.count =>
        _countQtyController.text.trim().isEmpty
            ? 'Nhập số lượng đếm thực tế để tiếp tục.'
            : null,
      InventoryControlMode.move =>
        _targetLocationController.text.trim().isEmpty
            ? 'Nhập vị trí đích để tiếp tục.'
            : null,
      InventoryControlMode.status =>
        _statusBefore == _statusAfter
            ? 'Trạng thái mới phải khác trạng thái hiện tại.'
            : null,
      InventoryControlMode.adjust =>
        _adjustQtyController.text.trim().isEmpty
            ? 'Nhập số lượng điều chỉnh để tiếp tục.'
            : null,
    };

    if (message != null) {
      setState(() {
        _validationMessage = message;
      });
      return false;
    }

    return true;
  }

  bool _validateStep3() {
    if (_resolveObjectCode() == null) {
      setState(() {
        _validationMessage = 'Thiếu dữ liệu đối tượng. Hãy quay lại bước 1.';
      });
      return false;
    }

    return true;
  }

  String? _resolveObjectCode() {
    final objectCode = _objectCodeController.text.trim();
    if (objectCode.isNotEmpty) {
      return objectCode;
    }
    final manualCode = _manualCodeController.text.trim();
    if (manualCode.isNotEmpty) {
      return manualCode;
    }
    return null;
  }

  void _resetForNext() {
    setState(() {
      _isSuccess = false;
      _currentStep = 0;
      _validationMessage = null;
      _scanFound = false;
      _scanNotFound = false;
      _transactionNo = null;
      _objectCodeController.clear();
      _manualCodeController.clear();
      _countQtyController.clear();
      _targetLocationController.clear();
      _adjustQtyController.clear();
      _statusBefore = 'available';
      _statusAfter = 'hold';
      _adjustReason = 'stock_take';
    });
  }
}

enum InventoryControlMode { count, move, status, adjust }

extension InventoryControlModeX on InventoryControlMode {
  static InventoryControlMode fromPath(String mode) {
    return switch (mode.toLowerCase()) {
      'count' => InventoryControlMode.count,
      'move' => InventoryControlMode.move,
      'status' => InventoryControlMode.status,
      'adjust' => InventoryControlMode.adjust,
      _ => InventoryControlMode.count,
    };
  }

  String get title {
    return switch (this) {
      InventoryControlMode.count => 'Kiểm kê',
      InventoryControlMode.move => 'Chuyển vị trí',
      InventoryControlMode.status => 'Đổi trạng thái',
      InventoryControlMode.adjust => 'Điều chỉnh',
    };
  }

  String get subtitle {
    return switch (this) {
      InventoryControlMode.count => 'Đếm thực tế và xác nhận chênh lệch',
      InventoryControlMode.move => 'Chuyển SKU giữa các vị trí trong kho',
      InventoryControlMode.status => 'Cập nhật trạng thái hàng hóa',
      InventoryControlMode.adjust => 'Điều chỉnh tồn theo mã lý do',
    };
  }
}

class _FlowHeader extends StatelessWidget {
  const _FlowHeader({required this.mode});

  final InventoryControlMode mode;

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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.route_rounded, color: AppColors.brand),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mode.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mode.subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepObjectSection extends StatelessWidget {
  const _StepObjectSection({
    required this.objectCodeController,
    required this.manualCodeController,
    required this.scanFound,
    required this.scanNotFound,
    required this.onSimulateScanFound,
    required this.onSimulateScanNotFound,
  });

  final TextEditingController objectCodeController;
  final TextEditingController manualCodeController;
  final bool scanFound;
  final bool scanNotFound;
  final VoidCallback onSimulateScanFound;
  final VoidCallback onSimulateScanNotFound;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: objectCodeController,
          decoration: const InputDecoration(
            labelText: 'Quét mã SKU/vị trí',
            hintText: 'SKU-COIL-01',
            prefixIcon: Icon(Icons.qr_code_scanner_rounded),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSimulateScanFound,
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: const Text('Giả lập scan thành công'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSimulateScanNotFound,
                icon: const Icon(Icons.error_outline_rounded),
                label: const Text('Giả lập scan không hợp lệ'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: manualCodeController,
          decoration: const InputDecoration(
            labelText: 'Nhập tay nếu mã lỗi',
            hintText: 'SKU-MANUAL-001',
            prefixIcon: Icon(Icons.keyboard_alt_rounded),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            _StatePill(
              text: 'Scanning',
              color: AppColors.info,
              active: !scanFound && !scanNotFound,
            ),
            _StatePill(
              text: 'Item found',
              color: AppColors.success,
              active: scanFound,
            ),
            _StatePill(
              text: 'Item not found',
              color: AppColors.danger,
              active: scanNotFound,
            ),
          ],
        ),
      ],
    );
  }
}

class _StepBusinessSection extends StatelessWidget {
  const _StepBusinessSection({
    required this.mode,
    required this.countQtyController,
    required this.sourceLocationController,
    required this.targetLocationController,
    required this.adjustQtyController,
    required this.statusBefore,
    required this.statusAfter,
    required this.adjustReason,
    required this.onStatusBeforeChanged,
    required this.onStatusAfterChanged,
    required this.onAdjustReasonChanged,
  });

  final InventoryControlMode mode;
  final TextEditingController countQtyController;
  final TextEditingController sourceLocationController;
  final TextEditingController targetLocationController;
  final TextEditingController adjustQtyController;
  final String statusBefore;
  final String statusAfter;
  final String adjustReason;
  final ValueChanged<String?> onStatusBeforeChanged;
  final ValueChanged<String?> onStatusAfterChanged;
  final ValueChanged<String?> onAdjustReasonChanged;

  @override
  Widget build(BuildContext context) {
    return switch (mode) {
      InventoryControlMode.count => Column(
        children: [
          TextField(
            controller: countQtyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Số lượng đếm thực tế',
              hintText: '118',
            ),
          ),
        ],
      ),
      InventoryControlMode.move => Column(
        children: [
          TextField(
            controller: sourceLocationController,
            decoration: const InputDecoration(
              labelText: 'Vị trí nguồn',
              hintText: 'A1-01-02',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: targetLocationController,
            decoration: const InputDecoration(
              labelText: 'Vị trí đích',
              hintText: 'B2-03-01',
            ),
          ),
        ],
      ),
      InventoryControlMode.status => Column(
        children: [
          DropdownButtonFormField<String>(
            initialValue: statusBefore,
            decoration: const InputDecoration(labelText: 'Trạng thái hiện tại'),
            items: const [
              DropdownMenuItem(value: 'available', child: Text('Available')),
              DropdownMenuItem(value: 'hold', child: Text('Hold')),
              DropdownMenuItem(value: 'damaged', child: Text('Damaged')),
            ],
            onChanged: onStatusBeforeChanged,
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            initialValue: statusAfter,
            decoration: const InputDecoration(labelText: 'Trạng thái mới'),
            items: const [
              DropdownMenuItem(value: 'available', child: Text('Available')),
              DropdownMenuItem(value: 'hold', child: Text('Hold')),
              DropdownMenuItem(value: 'damaged', child: Text('Damaged')),
            ],
            onChanged: onStatusAfterChanged,
          ),
        ],
      ),
      InventoryControlMode.adjust => Column(
        children: [
          TextField(
            controller: adjustQtyController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Số lượng điều chỉnh (+/-)',
              hintText: '-2',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<String>(
            initialValue: adjustReason,
            decoration: const InputDecoration(labelText: 'Mã lý do'),
            items: const [
              DropdownMenuItem(value: 'stock_take', child: Text('Stock take')),
              DropdownMenuItem(value: 'damage', child: Text('Damage')),
              DropdownMenuItem(
                value: 'quality_hold',
                child: Text('Quality hold'),
              ),
            ],
            onChanged: onAdjustReasonChanged,
          ),
        ],
      ),
    };
  }
}

class _StepReviewSection extends StatelessWidget {
  const _StepReviewSection({
    required this.mode,
    required this.objectCode,
    required this.countedQty,
    required this.sourceLocation,
    required this.targetLocation,
    required this.statusBefore,
    required this.statusAfter,
    required this.adjustQty,
    required this.adjustReason,
  });

  final InventoryControlMode mode;
  final String? objectCode;
  final String countedQty;
  final String sourceLocation;
  final String targetLocation;
  final String statusBefore;
  final String statusAfter;
  final String adjustQty;
  final String adjustReason;

  @override
  Widget build(BuildContext context) {
    final now = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ReviewRow(label: 'SKU/Vị trí', value: objectCode ?? 'Chưa có'),
          _ReviewRow(label: 'Loại tác vụ', value: mode.title),
          _ReviewRow(label: 'Người thực hiện', value: 'Current user'),
          _ReviewRow(label: 'Thời gian', value: now),
          const Divider(height: AppSpacing.lg),
          ...switch (mode) {
            InventoryControlMode.count => [
              _ReviewRow(label: 'Tồn hệ thống', value: '120'),
              _ReviewRow(
                label: 'Đếm thực tế',
                value: countedQty.isEmpty ? 'Chưa nhập' : countedQty,
              ),
            ],
            InventoryControlMode.move => [
              _ReviewRow(label: 'Vị trí nguồn', value: sourceLocation),
              _ReviewRow(
                label: 'Vị trí đích',
                value: targetLocation.isEmpty ? 'Chưa nhập' : targetLocation,
              ),
            ],
            InventoryControlMode.status => [
              _ReviewRow(label: 'Trạng thái trước', value: statusBefore),
              _ReviewRow(label: 'Trạng thái sau', value: statusAfter),
            ],
            InventoryControlMode.adjust => [
              _ReviewRow(
                label: 'Số lượng điều chỉnh',
                value: adjustQty.isEmpty ? 'Chưa nhập' : adjustQty,
              ),
              _ReviewRow(label: 'Mã lý do', value: adjustReason),
            ],
          },
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
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

class _StepperControls extends StatelessWidget {
  const _StepperControls({
    required this.currentStep,
    required this.isSubmitting,
    required this.canGoBack,
    required this.onBack,
    required this.onNext,
    required this.onSubmit,
  });

  final int currentStep;
  final bool isSubmitting;
  final bool canGoBack;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep >= 2;

    return Row(
      children: [
        if (canGoBack)
          OutlinedButton(
            onPressed: isSubmitting ? null : onBack,
            child: const Text('Quay lại'),
          ),
        if (canGoBack) const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: FilledButton(
            onPressed: isSubmitting
                ? null
                : isLastStep
                ? onSubmit
                : onNext,
            child: isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isLastStep ? 'Xác nhận giao dịch' : 'Tiếp tục'),
          ),
        ),
      ],
    );
  }
}

class _StatePill extends StatelessWidget {
  const _StatePill({
    required this.text,
    required this.color,
    required this.active,
  });

  final String text;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final tone = active ? color : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: active ? 0.14 : 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: tone,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.mode,
    required this.transactionNo,
    required this.onScanNext,
    required this.onBackToHub,
  });

  final InventoryControlMode mode;
  final String transactionNo;
  final VoidCallback onScanNext;
  final VoidCallback onBackToHub;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 44,
                  color: AppColors.success,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Hoàn tất giao dịch',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Mã giao dịch: $transactionNo',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Tác vụ ${mode.title.toLowerCase()} đã được ghi nhận. Nếu offline, trạng thái sẽ sync khi có mạng.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onBackToHub,
                        child: const Text('Về màn điều phối'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: FilledButton(
                        onPressed: onScanNext,
                        child: const Text('Quét tiếp'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
