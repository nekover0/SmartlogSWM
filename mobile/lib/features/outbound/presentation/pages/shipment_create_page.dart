import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ShipmentCreatePage extends StatefulWidget {
  const ShipmentCreatePage({super.key});

  @override
  State<ShipmentCreatePage> createState() => _ShipmentCreatePageState();
}

class _ShipmentCreatePageState extends State<ShipmentCreatePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _ownerController;
  late final TextEditingController _warehouseController;
  late final TextEditingController _salesOrderController;
  late final TextEditingController _billOfLadingController;
  late final TextEditingController _plateNumberController;
  late final TextEditingController _vesselController;
  late final TextEditingController _expectedWeightController;

  final List<_DraftLine> _lines = <_DraftLine>[];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _ownerController = TextEditingController(text: 'Vietnam Steel Corp');
    _warehouseController = TextEditingController(text: 'HUB-NORTH-01');
    _salesOrderController = TextEditingController();
    _billOfLadingController = TextEditingController();
    _plateNumberController = TextEditingController();
    _vesselController = TextEditingController();
    _expectedWeightController = TextEditingController(text: '12.50');

    _lines.add(
      _DraftLine(
        skuController: TextEditingController(text: 'STL-H-001'),
        itemNameController: TextEditingController(text: 'Thép cuộn mạ kẽm Ø12'),
        sourceLocationController: TextEditingController(text: 'A-02-01'),
        expectedQtyController: TextEditingController(text: '2.0'),
        shippedQtyController: TextEditingController(text: '0.0'),
        uomController: TextEditingController(text: 'cuộn'),
      ),
    );
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _warehouseController.dispose();
    _salesOrderController.dispose();
    _billOfLadingController.dispose();
    _plateNumberController.dispose();
    _vesselController.dispose();
    _expectedWeightController.dispose();

    for (final line in _lines) {
      line.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: AppBar(
        leading: IconButton(
          key: const Key('shipment_create_back_button'),
          onPressed: _handleBack,
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Quay lại',
        ),
        title: const Text('Tạo phiếu xuất'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.pagePadding,
          children: [
            const _SectionTitle(title: 'Header chứng từ'),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã phiếu sẽ được sinh sau khi tạo',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _StatusPreviewTag(
                      label: 'Tạo mới',
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _ownerController,
                      decoration: const InputDecoration(
                        labelText: 'Chủ hàng',
                        hintText: 'Ví dụ: Vietnam Steel Corp',
                      ),
                      validator: _requiredValidator('Chủ hàng'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const _SectionTitle(title: 'Metadata chính'),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _salesOrderController,
                      decoration: const InputDecoration(
                        labelText: 'Số SO',
                        hintText: 'Ví dụ: SO-112345',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _billOfLadingController,
                      decoration: const InputDecoration(
                        labelText: 'Số B/L',
                        hintText: 'Ví dụ: BL-9920',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _warehouseController,
                      decoration: const InputDecoration(
                        labelText: 'Kho xuất',
                        hintText: 'Ví dụ: HUB-NORTH-01',
                      ),
                      validator: _requiredValidator('Kho xuất'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _plateNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Biển số xe',
                        hintText: 'Ví dụ: 29C-123.45',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _vesselController,
                      decoration: const InputDecoration(
                        labelText: 'Tên tàu (nếu có)',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const _SectionTitle(title: 'Thông tin khối lượng'),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: TextFormField(
                  controller: _expectedWeightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Khối lượng dự kiến (T)',
                    hintText: 'Ví dụ: 12.50',
                  ),
                  validator: (value) {
                    final normalized = (value ?? '').trim().replaceAll(
                      ',',
                      '.',
                    );
                    final parsed = double.tryParse(normalized);
                    if (parsed == null || parsed <= 0) {
                      return 'Nhập khối lượng dự kiến hợp lệ';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const _SectionTitle(title: 'Danh sách hàng hóa'),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  children: [
                    for (var index = 0; index < _lines.length; index++) ...[
                      _DraftLineEditor(
                        line: _lines[index],
                        index: index,
                        onRemove: _lines.length == 1
                            ? null
                            : () => _removeLine(index),
                        validator: _requiredValidator,
                      ),
                      if (index < _lines.length - 1)
                        const SizedBox(height: AppSpacing.sm),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        key: const Key('shipment_create_add_line_button'),
                        onPressed: _addLine,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Thêm line hàng'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : _handleBack,
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton.icon(
                    key: const Key('shipment_create_submit_button'),
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_rounded),
                    label: Text(_isSubmitting ? 'Đang tạo...' : 'Tạo phiếu'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  FormFieldValidator<String> _requiredValidator(String label) {
    return (value) {
      if ((value ?? '').trim().isEmpty) {
        return 'Vui lòng nhập $label';
      }
      return null;
    };
  }

  void _addLine() {
    setState(() {
      _lines.add(
        _DraftLine(
          skuController: TextEditingController(),
          itemNameController: TextEditingController(),
          sourceLocationController: TextEditingController(),
          expectedQtyController: TextEditingController(),
          shippedQtyController: TextEditingController(text: '0.0'),
          uomController: TextEditingController(text: 'cuộn'),
        ),
      );
    });
  }

  void _removeLine(int index) {
    setState(() {
      final line = _lines.removeAt(index);
      line.dispose();
    });
  }

  Future<void> _handleSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 450));

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    final generatedNo = _generateShipmentNo();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Đã tạo phiếu xuất $generatedNo ở trạng thái Tạo mới.'),
        ),
      );

    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutePaths.shipmentList);
  }

  String _generateShipmentNo() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final serial = (100 + _lines.length).toString();
    return 'SHP-$day$month-${now.year}-$serial';
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutePaths.shipmentList);
  }
}

class _DraftLineEditor extends StatelessWidget {
  const _DraftLineEditor({
    required this.line,
    required this.index,
    required this.validator,
    this.onRemove,
  });

  final _DraftLine line;
  final int index;
  final VoidCallback? onRemove;
  final FormFieldValidator<String> Function(String label) validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Line ${index + 1}',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              if (onRemove != null)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline_rounded),
                  tooltip: 'Xóa line',
                ),
            ],
          ),
          TextFormField(
            controller: line.skuController,
            decoration: const InputDecoration(labelText: 'SKU'),
            validator: validator('SKU'),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: line.itemNameController,
            decoration: const InputDecoration(labelText: 'Tên hàng'),
            validator: validator('Tên hàng'),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: line.sourceLocationController,
            decoration: const InputDecoration(labelText: 'Vị trí nguồn'),
            validator: validator('vị trí nguồn'),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: line.expectedQtyController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Số lượng cần xuất',
                  ),
                  validator: validator('số lượng cần xuất'),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: TextFormField(
                  controller: line.shippedQtyController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Đã xuất'),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: TextFormField(
                  controller: line.uomController,
                  decoration: const InputDecoration(labelText: 'ĐVT'),
                  validator: validator('đơn vị tính'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _StatusPreviewTag extends StatelessWidget {
  const _StatusPreviewTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DraftLine {
  const _DraftLine({
    required this.skuController,
    required this.itemNameController,
    required this.sourceLocationController,
    required this.expectedQtyController,
    required this.shippedQtyController,
    required this.uomController,
  });

  final TextEditingController skuController;
  final TextEditingController itemNameController;
  final TextEditingController sourceLocationController;
  final TextEditingController expectedQtyController;
  final TextEditingController shippedQtyController;
  final TextEditingController uomController;

  void dispose() {
    skuController.dispose();
    itemNameController.dispose();
    sourceLocationController.dispose();
    expectedQtyController.dispose();
    shippedQtyController.dispose();
    uomController.dispose();
  }
}
