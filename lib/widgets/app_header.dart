import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final bool showSettingsIcon;

  const AppHeader({
    super.key,
    this.showSettingsIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.menu_book_rounded,
          color: Color(0xFF0796B8),
          size: 24,
        ),
        const SizedBox(width: 8),
        const Text(
          'Learnify',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Color(0xFF0796B8),
          ),
        ),
        const Spacer(),
        if (showSettingsIcon)
          const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFFEAF8FC),
            child: Icon(
              Icons.settings,
              size: 15,
              color: Color(0xFF0796B8),
            ),
          ),
      ],
    );
  }
}