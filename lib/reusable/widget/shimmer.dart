import 'package:flutter/material.dart';

class CuContainerShimmer extends StatelessWidget {
  final double height;
  final double width;

  const CuContainerShimmer(
      {super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height, // Adjust the height as needed
      color: Colors.grey.shade50,
    );
  }
}
