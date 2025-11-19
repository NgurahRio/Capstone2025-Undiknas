import 'dart:async';
import 'dart:typed_data';
import 'dart:html' as html;

class WebPickedFile {
  final Uint8List bytes;
  final String name;

  WebPickedFile({
    required this.bytes,
    required this.name,
  });
}

Future<WebPickedFile?> pickImageWeb() async {
  final uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.click();

  final completer = Completer<WebPickedFile?>();

  uploadInput.onChange.listen((event) {
    final file = uploadInput.files?.first;
    if (file == null) {
      completer.complete(null);
      return;
    }

    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);

    reader.onLoadEnd.listen((event) {
      final bytes = reader.result as Uint8List;
      completer.complete(
        WebPickedFile(bytes: bytes, name: file.name),
      );
    });
  });

  return completer.future;
}
