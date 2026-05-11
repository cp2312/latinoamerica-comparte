import 'package:flutter/material.dart';
import 'package:mobile/screens/models/dashboard_item.dart';

class DashboardAdminCard extends StatelessWidget {
  final DashboardItem item;

  const DashboardAdminCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color:        Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:      Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset:     const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:  MainAxisAlignment.spaceBetween,
          children: [
            Icon(item.icon, size: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize:   18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color:    Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}