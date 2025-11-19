import 'dart:convert';
import 'package:flutter/material.dart';

class TableContent extends StatelessWidget {
  final String? title;
  final int? flex;
  final bool isStatus;
  final bool isIcon;
  final Widget? content;

  const TableContent({
    super.key,
    this.title,
    this.flex,
    this.isStatus = false,
    this.isIcon = false,
    this.content,
  });

  bool _isBase64(String data) {
    return data.length > 100;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex ?? 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 3),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (content != null) {
      return content!;
    }

    if (isIcon) {
      return _buildIcon();
    }

    return Text(
      title!,
      style: TextStyle(
        fontSize: 13,
        color: isStatus ? const Color(0xFF8AC4FA) : Colors.black87,
      ),
    );
  }

  Widget _buildIcon() {
    if (_isBase64(title!)) {
      return Image.memory(
        base64Decode(title!),
        height: 20,
        width: 20,
        alignment: Alignment.centerLeft,
      );
    }

    return Image.asset(
      title!,
      height: 20,
      width: 20,
      alignment: Alignment.centerLeft,
    );
  }
}
