import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TableHeader extends StatelessWidget {
  final String title;
  final int? flex;

  TableHeader({
    super.key,
    required this.title,
    this.flex,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
