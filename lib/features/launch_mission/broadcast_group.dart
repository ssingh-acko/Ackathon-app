import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BroadcastGroupCard extends StatelessWidget {
  final List<BroadcastGroupItem> groups;

  const BroadcastGroupCard({
    super.key,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : const Color(0xFFE5E5E5),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Broadcast Group",
            style: GoogleFonts.publicSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Notify nearby citizens to gather support for your mission. "
                "This group is populated based on the issue location.",
            style: GoogleFonts.publicSans(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontSize: 14,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 20),

          ...groups.map((item) => _buildRow(item, isDark)).toList(),
        ],
      ),
    );
  }

  Widget _buildRow(BroadcastGroupItem item, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(
            item.icon,
            color: const Color(0xFF6F42C1),
            size: 26,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.publicSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: GoogleFonts.publicSans(
                    fontSize: 13,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BroadcastGroupItem {
  final IconData icon;
  final String title;
  final String subtitle;

  BroadcastGroupItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

final dummyBroadcastGroups = [
  BroadcastGroupItem(
    icon: Icons.group,
    title: "All users from the commune",
    subtitle: "Community members",
  ),
  BroadcastGroupItem(
    icon: Icons.directions_car,
    title: "Commuters through this location",
    subtitle: "Daily travelers",
  ),
  BroadcastGroupItem(
    icon: Icons.store_mall_directory,
    title: "Nearby shop owners",
    subtitle: "Local business network",
  ),
];
