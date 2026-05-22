import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

enum ActivityType { pending, published, testimonial }

class ActivityEntry {
  const ActivityEntry({
    required this.text,
    required this.time,
    required this.type,
  });

  final String text;
  final String time;
  final ActivityType type;
}

class ActivityFeed extends StatelessWidget {
  const ActivityFeed({super.key, required this.entries});

  final List<ActivityEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.fieldBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(entries.length, (i) {
          return _ActivityItem(
            entry: entries[i],
            isLast: i == entries.length - 1,
          );
        }),
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.entry, required this.isLast});

  final ActivityEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(color: Color(0xFFEDE7F6), width: 0.5),
              ),
      ),
      child: Row(
        children: [
          _buildIconBox(),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              entry.text,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.fieldText,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            entry.time,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF9575CD),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconBox() {
    final (bg, iconColor, icon) = switch (entry.type) {
      ActivityType.pending => (
        AppColors.activityPend,
        AppColors.activityPendIcon,
        Icons.mail_outline_rounded,
      ),
      ActivityType.published => (
        AppColors.activityPub,
        AppColors.activityPubIcon,
        Icons.article_outlined,
      ),
      ActivityType.testimonial => (
        AppColors.activityTest,
        AppColors.activityTestIcon,
        Icons.star_border_rounded,
      ),
    };

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 16, color: iconColor),
    );
  }
}