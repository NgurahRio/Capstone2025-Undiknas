import 'package:admin_website/components/CurrencyFormat.dart';
import 'package:admin_website/layout/responsive.dart';
import 'package:flutter/material.dart';

class TextFieldCostum extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final double? width;

  const TextFieldCostum({
    super.key,
    required this.controller,
    required this.text,
    this.width
  });

  @override
  State<TextFieldCostum> createState() => _TextFieldCostumState();
}

class _TextFieldCostumState extends State<TextFieldCostum> {

  int getWordCount(String text) {
    if (text.trim().isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).length;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      child: TextField(
        controller: widget.controller,
        onChanged: (value) {
          final words = getWordCount(value);
          if (words > 100) {
            final trimmed = value.trim().split(RegExp(r'\s+')).take(100).join(" ");
            widget.controller.text = trimmed;
            widget.controller.selection = TextSelection.fromPosition(
              TextPosition(offset: trimmed.length),
            );
          }
          setState(() {});
        },
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: widget.text,
          hintStyle: const TextStyle(
            color: Color(0xFFB6B6B6),
            fontSize: 13,
            fontWeight: FontWeight.w500
          ),
          filled: true,
          fillColor: Colors.transparent,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.black54,
              width: 0.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.black54,
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.black54,
              width: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TextFieldLogin extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  bool isPassword = false;
  bool obscurePass = true;

  TextFieldLogin({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.obscurePass = true,
  });

  @override
  State<TextFieldLogin> createState() => _TextFieldLoginState();
}

class _TextFieldLoginState extends State<TextFieldLogin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword ? widget.obscurePass : false,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.w500
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 230, 230, 230),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1,
            ),
          ),
          suffixIcon: widget.isPassword 
            ? IconButton(
                icon: Icon(
                  widget.obscurePass
                    ? Icons.visibility
                    : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    widget.obscurePass = !widget.obscurePass;
                  });
                },
              )
            : null,
        ),
      ),
    );
  }
}

class SearchFieldCostum extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  SearchFieldCostum({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<SearchFieldCostum> createState() => _SearchFieldCostumState();
}

class _SearchFieldCostumState extends State<SearchFieldCostum> {

  @override
  Widget build(BuildContext context) {

    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    final double width = isDesktop
      ? 300 
      : isTablet
        ? 250
        : MediaQuery.of(context).size.width * 0.45;
    
    return SizedBox(
      width: width,
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 182, 182, 182),
            fontSize: 13,
            fontWeight: FontWeight.w500
          ),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.black54,
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.black54,
              width: 0.5,
            ),
          ),
          suffixIcon: const Icon(Icons.search, color: Colors.black54, size: 25,)
        ),
      ),
    );
  }
}

class PriceField extends StatefulWidget {
  final TextEditingController controller;

  const PriceField({super.key, required this.controller});

  @override
  State<PriceField> createState() => _PriceFieldState();
}

class _PriceFieldState extends State<PriceField> {

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      final text = widget.controller.text;

      final clean = text.replaceAll('.', '');

      if (clean.isEmpty) return;

      final formatted = formatRupiah(clean);

      if (formatted != text) {
        widget.controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.black54,
          width: 0.5,
        )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              "IDR.",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          Expanded(
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(
                hintText: "Write price",
                hintStyle: TextStyle(
                  color: Color(0xFFB6B6B6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500
                ),
                filled: true,
                fillColor: Colors.transparent,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none
              ),
            ),
          ),
        ],
      ),
    );
  }
}
