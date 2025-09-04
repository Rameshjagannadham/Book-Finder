import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListTile(
        leading: Container(width: 48, height: 64, color: Colors.white),
        title: Container(
          height: 16,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 8),
        ),
        subtitle: Container(height: 12, color: Colors.white, width: 120),
      ),
    );
  }
}
