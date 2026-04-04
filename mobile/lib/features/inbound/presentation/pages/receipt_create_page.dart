import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ReceiptCreatePage extends StatefulWidget {
  const ReceiptCreatePage({super.key});

  @override
  State<ReceiptCreatePage> createState() => _ReceiptCreatePageState();
}

class _ReceiptCreatePageState extends State<ReceiptCreatePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _ownerController;
  late final TextEditingController _warehouseController;
  late final TextEditingController _purchaseOrderController;
  late final TextEditingController _billOfLadingController;
  late final TextEditingController _vesselController;
  late final TextEditingController _plateNumberController;
  late final TextEditingController _expectedWeightController;
  late final TextEditingController _noteController;

  final List<_DraftLine> _lines = <_DraftLine>[];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _ownerController = TextEditingController(text: 'Vinamilk Logistics');
    _warehouseController = TextEditingController(text: 'BDG-WH-02');
    _purchaseOrderController = TextEditingController();
    _billOfLadingController = TextEditingController();
    _vesselController = TextEditingController();
    _plateNumberController = TextEditingController();
    _expectedWeightController = TextEditingController(text: '18.25');
    _noteController = TextEditingController();

    _lines.add(
      _DraftLine(
        skuController: TextEditingController(text: 'SKU-MILK-18L'),
        itemNameController: TextEditingController(
          text: 'Sua tuoi tiet trung 18L',
        ),
        expectedQtyController: TextEditingController(text: '320'),
        receivedQtyController: TextEditingController(text: '0'),
        uomController: TextEditingController(text: 'CAN'),
      ),
    );
  }

  @override
  void dispose() {
    _ownerController.dispose();
    _warehouseController.dispose();
    _purchaseOrderController.dispose();
    _billOfLadingController.dispose();
    _vesselController.dispose();
    _plateNumberController.dispose();
    _expectedWeightController.dispose();
    _noteController.dispose();

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
          key: const Key('receipt_create_back_button'),
          onPressed: _handleBack,
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Quay lai',
        ),
        title: const Text('Tao phieu nhap'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.pagePadding,
          children: [
            const _SectionTitle(title: 'Header chung tu'),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trang thai ban dau: Draft',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _ownerController,
                      decoration: const InputDecoration(
                        labelText: 'Chu hang',
                        hintText: 'Vi du: Vinamilk Logistics',
                      ),
                      validator: _requiredValidator('Chu hang'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _warehouseController,
                      decoration: const InputDecoration(
                        labelText: 'Kho nhap',
                        hintText: 'Vi du: BDG-WH-02',
                      ),
                      validator: _requiredValidator('Kho nhap'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const _SectionTitle(title: 'Metadata chinh'),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _purchaseOrderController,
                      decoration: const InputDecoration(
                        labelText: 'So PO',
                        hintText: 'Vi du: PO-240404-001',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _billOfLadingController,
                      decoration: const InputDecoration(
                        labelText: 'So B/L',
                        hintText: 'Vi du: BL-240404-001',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _plateNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Bien so xe',
                        hintText: 'Vi du: 51D-12345',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _vesselController,
                      decoration: const InputDecoration(
                        labelText: 'Ten tau (neu co)',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const _SectionTitle(title: 'Thong tin khoi luong'),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: TextFormField(
                  controller: _expectedWeightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Khoi luong du kien (kg)',
                    hintText: 'Vi du: 18250.0',
                  ),
                  validator: (value) {
                    final normalized = (value ?? '').trim().replaceAll(
                      ',',
                      '.',
                    );
                    final parsed = double.tryParse(normalized);
                    if (parsed == null || parsed <= 0) {
                      return 'Nhap khoi luong du kien hop le';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const _SectionTitle(title: 'Danh sach hang hoa'),
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
                        key: const Key('receipt_create_add_line_button'),
                        onPressed: _addLine,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Them line hang'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const _SectionTitle(title: 'Ghi chu'),
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: TextFormField(
                  controller: _noteController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Ghi chu xu ly',
                    hintText: 'Nhap huong dan cho doi can va doi kho neu can',
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : _handleBack,
                    child: const Text('Huy'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton.icon(
                    key: const Key('receipt_create_submit_button'),
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_rounded),
                    label: Text(_isSubmitting ? 'Dang tao...' : 'Tao phieu'),
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
        return 'Vui long nhap $label';
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
          expectedQtyController: TextEditingController(),
          receivedQtyController: TextEditingController(text: '0'),
          uomController: TextEditingController(text: 'CAN'),
        ),
      );
    });
  }

  void _removeLine(int index) {
    setState(() {
      final removed = _lines.removeAt(index);
      removed.dispose();
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

    final generatedNo = _generateReceiptNo();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Da tao phieu nhap $generatedNo o trang thai Draft.'),
        ),
      );

    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutePaths.receiptList);
  }

  String _generateReceiptNo() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final serial = (100 + _lines.length).toString();
    return 'RCP-$day$month-${now.year}-$serial';
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutePaths.receiptList);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
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
                  tooltip: 'Xoa line',
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
            decoration: const InputDecoration(labelText: 'Ten hang'),
            validator: validator('Ten hang'),
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
                    labelText: 'So luong du kien',
                  ),
                  validator: validator('so luong du kien'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextFormField(
                  controller: line.receivedQtyController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Da nhan'),
                  validator: validator('so luong da nhan'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            controller: line.uomController,
            decoration: const InputDecoration(labelText: 'Don vi tinh'),
            validator: validator('don vi tinh'),
          ),
        ],
      ),
    );
  }
}

class _DraftLine {
  _DraftLine({
    required this.skuController,
    required this.itemNameController,
    required this.expectedQtyController,
    required this.receivedQtyController,
    required this.uomController,
  });

  final TextEditingController skuController;
  final TextEditingController itemNameController;
  final TextEditingController expectedQtyController;
  final TextEditingController receivedQtyController;
  final TextEditingController uomController;

  void dispose() {
    skuController.dispose();
    itemNameController.dispose();
    expectedQtyController.dispose();
    receivedQtyController.dispose();
    uomController.dispose();
  }
}
