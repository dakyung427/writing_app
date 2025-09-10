import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html; // Flutter Web 환경 전용
import 'package:http/http.dart' as http;

class GoogleImageAPI {
  final String apiKey = " "; // 🔑 실제 Google Vision API 키 넣기

  /// 웹에서 이미지 선택 (Uint8List로 반환)
  Future<Uint8List?> pickImageWeb() async {
    final completer = Completer<Uint8List?>();

    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((event) {
          completer.complete(reader.result as Uint8List);
        });
      } else {
        completer.complete(null);
      }
    });

    return completer.future;
  }

  /// Google Vision API 호출해서 텍스트 추출
  Future<String?> extractTextFromBytes(Uint8List bytes) async {
    try {
      final base64Image = base64Encode(bytes);

      final url = Uri.parse(
        "https://vision.googleapis.com/v1/images:annotate?key=$apiKey",
      );

      final body = jsonEncode({
        "requests": [
          {
            "image": {"content": base64Image},
            "features": [
              {"type": "TEXT_DETECTION"} // OCR
            ]
          }
        ]
      });

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final text = jsonData["responses"][0]["fullTextAnnotation"]?["text"];
        return text;
      } else {
        print("❌ API Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }
}