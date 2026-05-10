import 'package:flutter/material.dart';

class DashboardItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  DashboardItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });
}
