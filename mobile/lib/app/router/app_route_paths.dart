abstract final class AppRoutePaths {
  static const login = '/login';
  static const authBootstrap = '/auth/bootstrap';

  static const home = '/home';
  static const tasks = '/tasks';
  static const inventory = '/inventory';
  static const more = '/more';
  static const notifications = '/notifications';
  static const account = '/account';

  static const inventoryIdParam = 'inventoryId';
  static const inventoryDetail = '$inventory/:$inventoryIdParam';

  static const inventoryControl = '/inventory-control';
  static const inventoryControlModeParam = 'mode';
  static const inventoryControlFlow =
      '$inventoryControl/:$inventoryControlModeParam';

  static const receiptList = '/inbound/receipts';
  static const receiptIdParam = 'receiptId';
  static const receiptDetail = '$receiptList/:$receiptIdParam';
  static const receiptCreate = '$receiptList/new';

  static const shipmentList = '/outbound/shipments';
  static const shipmentIdParam = 'shipmentId';
  static const shipmentDetail = '$shipmentList/:$shipmentIdParam';
  static const shipmentCreate = '$shipmentList/new';

  static const scanBarcode = '/scan/barcode';
  static const scanManual = '/scan/manual';

  static const ocrInbox = '/ocr';
  static const ocrCapture = '/ocr/capture';
  static const ocrIdParam = 'ocrId';
  static const ocrReview = '$ocrInbox/:$ocrIdParam/review';
  static const ocrLink = '$ocrInbox/:$ocrIdParam/link';

  static const reports = '/reports';
  static const permissions = '/account/permissions';
  static const userAdmin = '/admin/users';
  static const roleAdmin = '/admin/roles';

  static String tasksPath({String? type}) {
    if (type == null || type.isEmpty) {
      return tasks;
    }

    return Uri(
      path: tasks,
      queryParameters: <String, String>{'type': type},
    ).toString();
  }

  static String inventoryDetailPath(String inventoryId) =>
      '$inventory/$inventoryId';

  static String inventoryControlFlowPath(String mode) =>
      '$inventoryControl/$mode';

  static String receiptDetailPath(String receiptId) =>
      '$receiptList/$receiptId';

  static String shipmentDetailPath(String shipmentId) =>
      '$shipmentList/$shipmentId';

  static String ocrReviewPath(String ocrId) => '$ocrInbox/$ocrId/review';

  static String ocrLinkPath(String ocrId) => '$ocrInbox/$ocrId/link';
}
