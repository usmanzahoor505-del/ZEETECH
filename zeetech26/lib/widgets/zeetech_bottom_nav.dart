import 'package:flutter/material.dart';
import '../theme/theme.dart';

class ZeetechBottomNav extends StatelessWidget {
  final String activeTab;
  final ValueChanged<String> onTabChange;

  const ZeetechBottomNav({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  static const List<Map<String, dynamic>> navItems = [
    {'id': 'home', 'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
    {'id': 'orders', 'icon': Icons.receipt_long_outlined, 'activeIcon': Icons.receipt_long, 'label': 'Orders'},
    {'id': 'about', 'icon': Icons.info_outline_rounded, 'activeIcon': Icons.info_rounded, 'label': 'About'},
    {'id': 'contact', 'icon': Icons.phone_outlined, 'activeIcon': Icons.phone, 'label': 'Contact'},
    {'id': 'account', 'icon': Icons.account_circle_outlined, 'activeIcon': Icons.account_circle, 'label': 'Profile'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480), // Mimic max-w-md
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: navItems.map((item) {
              final String id = item['id'];
              final bool isActive = activeTab == id;
              final IconData icon = isActive ? item['activeIcon'] : item['icon'];
              final String label = item['label'];

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTabChange(id),
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Active tab background overlay
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        alignment: Alignment.center,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary.withOpacity(0.08)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const SizedBox(
                            width: 50,
                            height: 35,
                          ),
                        ),
                      ),
                      
                      // Icon and label column
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            color: isActive ? AppColors.primary : Colors.grey.shade400,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                              color: isActive ? AppColors.primary : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      
                      // Active indicator line at the top of the button
                      if (isActive)
                        Positioned(
                          top: 0,
                          child: Container(
                            width: 32,
                            height: 3,
                            decoration: BoxDecoration(
                              gradient: AppGradients.primary,
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
