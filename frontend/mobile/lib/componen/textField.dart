import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FieldTextCustom extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  bool isPassword = false;
  bool obscurePass = true;
  bool obscureConfPass = true;
  bool obscureOldPass = true;


  FieldTextCustom({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.obscurePass = true,
    this.obscureConfPass = true,
    this.obscureOldPass = true,
  });

  @override
  State<FieldTextCustom> createState() => _FieldTextCustomState();
}

class _FieldTextCustomState extends State<FieldTextCustom> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? widget.obscurePass || widget.obscureConfPass : false,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 230, 230, 230),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
          suffixIcon: widget.isPassword 
            ? IconButton(
                icon: Icon(
                  widget.obscurePass || widget.obscureConfPass 
                    ? Icons.visibility
                    : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    widget.obscurePass = !widget.obscurePass;
                    widget.obscureConfPass = !widget.obscureConfPass;
                  });
                },
              )
            : null,
        ),
      ),
    );
  }
}