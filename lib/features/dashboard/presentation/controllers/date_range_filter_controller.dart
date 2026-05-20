import 'package:flutter/foundation.dart';

import '../../domain/enums/date_range_filter.dart';

class DateRangeFilterController extends ChangeNotifier {
  DateRangeFilter selected = DateRangeFilter.today;

  void setFilter(DateRangeFilter filter) {
    if (selected == filter) return;
    selected = filter;
    notifyListeners();
  }
}
