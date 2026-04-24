import 'package:flutter/material.dart';

class SoundCard extends StatelessWidget {
  final VoidCallback onTap;

  const SoundCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 92,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDCA8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sounds',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF102A43),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Hear the world',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.graphic_eq_rounded, color: Colors.brown, size: 30),
            SizedBox(width: 12),
            Icon(Icons.pets_rounded, color: Colors.brown, size: 28),
          ],
        ),
      ),
    );
  }
}