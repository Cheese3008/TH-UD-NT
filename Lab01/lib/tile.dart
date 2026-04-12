import 'package:flutter/material.dart';

enum HitType
{
  miss,
  misplaced,
  hit,
  special,
}

class Tile extends StatelessWidget
{
  final String letter;
  final HitType hitType;

  const Tile({
    super.key,
    required this.letter,
    required this.hitType,
  });

  List<Color> getTileGradient()
  {
    switch (hitType)
    {
      case HitType.miss:
        return const [
          Color(0xFF9CA3AF),
          Color(0xFF6B7280),
        ];
      case HitType.misplaced:
        return const [
          Color(0xFFFFC444),
          Color(0xFFFF8A00),
        ];
      case HitType.hit:
        return const [
          Color(0xFF4ADE80),
          Color(0xFF22C55E),
        ];
      case HitType.special:
        return const [
          Color(0xFF60A5FA),
          Color(0xFF7C3AED),
        ];
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      width: 72,
      height: 72,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: getTileGradient(),
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }
}