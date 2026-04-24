import 'package:flutter/material.dart';

class DailyAdventureCard extends StatelessWidget {
  const DailyAdventureCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0796B8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'NEW',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Daily Adventure\nVisit the animal farm today!',
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w700,
                color: Color(0xFF102A43),
              ),
            ),
          ),
          Row(
            children: List.generate(
              3,
              (index) => Icon(
                Icons.star_rounded,
                size: 17,
                color: index < 1 ? Colors.amber : Colors.grey.shade300,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.cloud_rounded, color: Color(0xFFE8EEF2), size: 28),
        ],
      ),
    );
  }
}