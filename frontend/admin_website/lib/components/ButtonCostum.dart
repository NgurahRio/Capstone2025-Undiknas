import 'package:flutter/material.dart';

class ButtonCostum extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final bool isIcon;

  const ButtonCostum({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.isIcon = false
  });

  @override
  State<ButtonCostum> createState() => _ButtonCostumState();
}

class _ButtonCostumState extends State<ButtonCostum> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      onHover: (value) => setState(() => hover = value),
      style: TextButton.styleFrom(
        minimumSize: Size(widget.width ?? 150, 47),
        backgroundColor: hover
            ? const Color(0xFF6BB5F7)
            : const Color(0xFF8AC4FA),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Wrap(
        spacing: 5,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if(widget.isIcon)
            Icon(Icons.add_circle_outline_outlined),
          Text(
            widget.text,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class ButtonCostum2 extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const ButtonCostum2({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<ButtonCostum2> createState() => _ButtonCostum2State();
}

class _ButtonCostum2State extends State<ButtonCostum2> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.onPressed,
      onHover: (value) => setState(() => hover = value),
      style: TextButton.styleFrom(
        minimumSize: Size(double.infinity, 45),
        backgroundColor: hover
            ? const Color(0xFF6BB5F7)
            : const Color(0xFF8AC4FA),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800
        ),
      ),
    );
  }
}

class ButtonCostum3 extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String text;

  const ButtonCostum3({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  State<ButtonCostum3> createState() => _ButtonCostum3State();
}

class _ButtonCostum3State extends State<ButtonCostum3> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),

      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: hover ? const Color(0xFFB8B8B8) : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.black45,
              width: 0.5,
            ),
          ),
          child: Wrap(
            spacing: 5,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(widget.icon),

              Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

