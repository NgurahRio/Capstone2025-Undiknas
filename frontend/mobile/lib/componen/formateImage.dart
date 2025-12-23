import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

ImageProvider formatImage(String image) {
  if (image.startsWith('http://') || image.startsWith('https://')) {
    return NetworkImage(image);
  }

  if (image.startsWith('data:image') || image.length > 200 || image.startsWith("iVBOR") ) {
    final base64Str = image.startsWith('data:image')
        ? image.split(',').last
        : image;

    Uint8List bytes = base64Decode(base64Str);
    return MemoryImage(bytes);
  }

  // Asset image
  return AssetImage(image);
}
