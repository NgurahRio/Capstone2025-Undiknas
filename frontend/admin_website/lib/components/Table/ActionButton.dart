import 'package:flutter/material.dart';

class Actionbutton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDelete;

  const Actionbutton({
    super.key,
    required this.label,
    required this.onTap,
    this.isDelete = false,
  });

  @override
  State<Actionbutton> createState() => _ActionbuttonState();
}

class _ActionbuttonState extends State<Actionbutton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13, bottom: 13, right: 6),
      child: InkWell(
        onTap: widget.onTap,
        onHover: (value) => setState(() => hover = value),
        borderRadius: BorderRadius.circular(4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          decoration: BoxDecoration(
            color: hover
                ? widget.isDelete 
                  ? const Color(0xFFFFE5E5)
                  : const Color(0xFFB8B8B8)
                : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color:Colors.black45,
              width: 0.3,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              color: widget.isDelete
                  ? Colors.red
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
