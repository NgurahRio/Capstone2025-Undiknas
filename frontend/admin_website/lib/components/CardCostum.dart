import 'package:flutter/material.dart';

class CardCostum extends StatelessWidget {
  final Widget content;

  const CardCostum({
    super.key,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(0, 1)
          )
        ]
      ),
      child: content,
    );
  }
}