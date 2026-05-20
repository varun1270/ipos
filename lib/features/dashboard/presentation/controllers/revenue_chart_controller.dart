import 'package:flutter/foundation.dart';

import '../../domain/enums/revenue_chart_period.dart';

class RevenueChartController extends ChangeNotifier {
  RevenueChartPeriod selectedPeriod = RevenueChartPeriod.week;

  void setPeriod(RevenueChartPeriod period) {
    if (selectedPeriod == period) return;
    selectedPeriod = period;
    notifyListeners();
  }
}
