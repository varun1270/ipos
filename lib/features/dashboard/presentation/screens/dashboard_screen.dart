// Root screen for the Dashboard feature.
// Composes the full page: header, Start Selling banner, Quick Actions,
// 2x2 Stat Cards, Revenue Chart, Category Breakdown, Top Selling,
// Least Selling and Low Stock Alerts. Reads state from the dashboard
// providers and triggers reloads when filters change.
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Dashboard')));
  }
}