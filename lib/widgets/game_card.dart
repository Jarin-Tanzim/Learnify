import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final int stars;

  const GameCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, color: iconColor, size: 21),
          ),
          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: Color(0xFF102A43),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: List.generate(
                    3,
                    (index) => Icon(
                      Icons.star_rounded,
                      size: 14,
                      color:
                          index < stars ? Colors.amber : Colors.grey.shade300,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF0796B8),
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}