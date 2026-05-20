/// Header date range filter: Today / Week / Month.
enum DateRangeFilter {
  today,
  week,
  month;

  String get label => switch (this) {
    DateRangeFilter.today => 'Today',
    DateRangeFilter.week => 'Week',
    DateRangeFilter.month => 'Month',
  };

  String get comparisonLabel => switch (this) {
    DateRangeFilter.today => 'vs yesterday',
    DateRangeFilter.week => 'vs last week',
    DateRangeFilter.month => 'vs last month',
  };
}
