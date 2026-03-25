import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class InventoryListPage extends StatefulWidget {
  const InventoryListPage({super.key});

  @override
  State<InventoryListPage> createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  _InventoryFilter _activeFilter = _InventoryFilter.all;

  List<_InventoryItem> get _filteredItems {
    return switch (_activeFilter) {
      _InventoryFilter.lowStock =>
        _inventoryItems
            .where((item) => item.health == _InventoryHealth.low)
            .toList(growable: false),
      _ => _inventoryItems,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _filteredItems;
    final bottomSafeInset = MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _InventoryStickyHeaderDelegate(
                child: Container(
                  color: const Color(0xFFF4FAFF),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      const _SearchBar(),
                      const SizedBox(height: AppSpacing.sm),
                      _FilterRow(
                        activeFilter: _activeFilter,
                        onFilterSelected: (_InventoryFilter filter) {
                          setState(() {
                            _activeFilter = filter;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                144 + bottomSafeInset,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tồn kho hiện tại (142)',
                          key: const Key('inventory_list_header_total'),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          visualDensity: VisualDensity.compact,
                        ),
                        iconAlignment: IconAlignment.end,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                        ),
                        label: const Text('Sắp xếp: SKU'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _InventoryCard(
                        key: Key('inventory_card_${item.id}'),
                        item: item,
                        onTap: () {
                          context.go(
                            AppRoutePaths.inventoryDetailPath(item.id),
                          );
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
        Positioned(
          right: AppSpacing.xs,
          bottom: AppSpacing.xxl,
          child: FilledButton.icon(
            key: const Key('inventory_add_new_button'),
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brand,
              foregroundColor: AppColors.surface,
              minimumSize: const Size(148, 56),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.add_rounded, size: 22),
            label: const Text(
              'Thêm mới',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

class _InventoryStickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _InventoryStickyHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get maxExtent => 120;

  @override
  double get minExtent => 120;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAFF),
        boxShadow: [
          if (overlapsContent)
            const BoxShadow(
              color: Color(0x10000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _InventoryStickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              'SKU, tên hàng, lô, vị trí...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          IconButton(
            onPressed: () {},
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.qr_code_scanner_rounded),
            color: AppColors.textSecondary,
          ),
          IconButton(
            key: const Key('inventory_filter_button'),
            onPressed: () {},
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.tune_rounded),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.activeFilter,
    required this.onFilterSelected,
  });

  final _InventoryFilter activeFilter;
  final ValueChanged<_InventoryFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _InventoryFilter.values.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(width: AppSpacing.xs),
        itemBuilder: (BuildContext context, int index) {
          final filter = _InventoryFilter.values[index];
          return _FilterChipButton(
            key: Key('inventory_filter_${filter.name}'),
            label: filter.label,
            selected: activeFilter == filter,
            onTap: () => onFilterSelected(filter),
          );
        },
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.brand : AppColors.surface,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? AppColors.brand : AppColors.border,
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: selected ? AppColors.surface : AppColors.brand,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({super.key, required this.item, required this.onTap});

  final _InventoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final statusTone = item.health.tone;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(10),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'SKU: ${item.skuCode}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.brand,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusTone.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.health.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusTone.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                item.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vị trí',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.location,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Số lượng',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${item.quantity.toString().padLeft(2, '0')} ',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: item.health == _InventoryHealth.low
                                    ? AppColors.warning
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: item.uom,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppColors.brand,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryItem {
  const _InventoryItem({
    required this.id,
    required this.skuCode,
    required this.name,
    required this.location,
    required this.quantity,
    required this.uom,
    required this.health,
  });

  final String id;
  final String skuCode;
  final String name;
  final String location;
  final int quantity;
  final String uom;
  final _InventoryHealth health;
}

enum _InventoryFilter {
  all('Tất cả'),
  warehouse('Kho'),
  status('Trạng thái'),
  category('Danh mục'),
  lowStock('Tồn thấp');

  const _InventoryFilter(this.label);

  final String label;
}

enum _InventoryHealth {
  low('Tồn thấp'),
  stable('Ổn định');

  const _InventoryHealth(this.label);

  final String label;

  _StatusTone get tone {
    return switch (this) {
      _InventoryHealth.low => const _StatusTone(
        background: Color(0xFFFCEBEC),
        foreground: Color(0xFFC53030),
      ),
      _InventoryHealth.stable => const _StatusTone(
        background: Color(0xFFE7F6EC),
        foreground: Color(0xFF1F7A4D),
      ),
    };
  }
}

class _StatusTone {
  const _StatusTone({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

const List<_InventoryItem> _inventoryItems = <_InventoryItem>[
  _InventoryItem(
    id: 'inv-smt-9022-x',
    skuCode: 'SMT-9022-X',
    name: 'Cảm biến nhiệt Thermal GX-90',
    location: 'Aisle 4, Bin B-12',
    quantity: 12,
    uom: 'PCS',
    health: _InventoryHealth.low,
  ),
  _InventoryItem(
    id: 'inv-net-4402-b',
    skuCode: 'NET-4402-B',
    name: 'Industrial Hub Switch 24-Port',
    location: 'Zone C, Shelf 09',
    quantity: 450,
    uom: 'PCS',
    health: _InventoryHealth.stable,
  ),
  _InventoryItem(
    id: 'inv-cbl-50-fbr',
    skuCode: 'CBL-50-FBR',
    name: 'Cáp Quang Fiber Optic (50m)',
    location: 'Bulk Storage, Row 2',
    quantity: 5,
    uom: 'ROLL',
    health: _InventoryHealth.low,
  ),
  _InventoryItem(
    id: 'inv-pwr-mod-88',
    skuCode: 'PWR-MOD-88',
    name: 'Lithium Power Module 12V',
    location: 'Aisle 2, Bin A-04',
    quantity: 84,
    uom: 'UNIT',
    health: _InventoryHealth.stable,
  ),
];
