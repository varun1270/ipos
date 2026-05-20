import 'package:flutter/foundation.dart';

import '../../data/mock/dashboard_mock_data.dart';

class ShopSelectorController extends ChangeNotifier {
  String selectedShopId = 'all';

  List<Map<String, String>> get shops => DashboardMockData.shops;

  String get selectedShopName {
    return shops.firstWhere(
      (shop) => shop['id'] == selectedShopId,
      orElse: () => shops.first,
    )['name']!;
  }

  void setShop(String shopId) {
    if (selectedShopId == shopId) return;
    selectedShopId = shopId;
    notifyListeners();
  }
}
