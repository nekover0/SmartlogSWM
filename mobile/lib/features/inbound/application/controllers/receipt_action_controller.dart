import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/inbound/application/controllers/receipt_detail_controller.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final receiptActionControllerProvider =
    NotifierProviderFamily<ReceiptActionController, ReceiptActionState, String>(
      ReceiptActionController.new,
    );

class ReceiptActionController
    extends FamilyNotifier<ReceiptActionState, String> {
  @override
  ReceiptActionState build(String receiptId) {
    final detailState = ref.watch(receiptDetailControllerProvider(receiptId));
    return ReceiptActionState(
      allActions: detailState.valueOrNull?.availableActions,
    );
  }
}

class ReceiptActionState {
  const ReceiptActionState({List<ActionCapability>? allActions})
    : allActions = allActions ?? const <ActionCapability>[];

  final List<ActionCapability> allActions;

  List<ActionCapability> get orderedActions {
    final actions = List<ActionCapability>.of(allActions, growable: false)
      ..sort(_compareActions);
    return UnmodifiableListView<ActionCapability>(actions);
  }

  List<ActionCapability> get primaryActions {
    final actions = orderedActions.take(2).toList(growable: false);
    return UnmodifiableListView<ActionCapability>(actions);
  }

  List<ActionCapability> get secondaryActions {
    final actions = orderedActions.skip(2).toList(growable: false);
    return UnmodifiableListView<ActionCapability>(actions);
  }

  ActionCapability? get featuredAction {
    final actions = orderedActions;
    if (actions.isEmpty) {
      return null;
    }
    return actions.first;
  }

  bool get hasActions => allActions.isNotEmpty;

  bool get hasEnabledActions => allActions.any((action) => action.enabled);

  static int _compareActions(ActionCapability left, ActionCapability right) {
    final leftPriority = _actionPriority(left.type);
    final rightPriority = _actionPriority(right.type);
    final priorityComparison = leftPriority.compareTo(rightPriority);
    if (priorityComparison != 0) {
      return priorityComparison;
    }

    if (left.enabled != right.enabled) {
      return left.enabled ? -1 : 1;
    }

    return left.label.compareTo(right.label);
  }

  static int _actionPriority(TaskActionType type) {
    return switch (type) {
      TaskActionType.startWeighing => 0,
      TaskActionType.approve => 1,
      TaskActionType.dismiss => 2,
      TaskActionType.reviewOcr => 3,
      TaskActionType.open => 4,
      TaskActionType.acknowledge => 5,
      TaskActionType.custom => 6,
      TaskActionType.startPicking => 7,
      TaskActionType.viewInventory => 8,
    };
  }
}
