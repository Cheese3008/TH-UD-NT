import 'package:flutter/material.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _SkeletonBox(height: 280, borderRadius: BorderRadius.circular(28)),
          const SizedBox(height: 20),
          _SkeletonBox(height: 110, borderRadius: BorderRadius.circular(22)),
          const SizedBox(height: 20),
          _SkeletonBox(height: 220, borderRadius: BorderRadius.circular(22)),
          const SizedBox(height: 24),
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(
            'Đang tải dữ liệu thời tiết...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double height;
  final BorderRadius borderRadius;

  const _SkeletonBox({required this.height, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: borderRadius,
      ),
    );
  }
}
