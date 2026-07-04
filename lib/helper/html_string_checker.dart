import 'package:html/parser.dart' as html_parser;

bool isHtmlResponse(String? text) {
  if (text == null || text.isEmpty) return false;

  final normalized = text.trimLeft().toLowerCase();
  return normalized.startsWith('<!doctype') ||
      normalized.startsWith('<html') ||
      (normalized.startsWith('<') && normalized.contains('</'));
}

bool isHtmlContentEmpty(String? htmlText) {
  if (htmlText == null) return true;

  final document = html_parser.parse(htmlText);

  // Extract visible text only
  final String parsedText = document.body?.text ?? '';

  // Remove spaces, new lines, non-breaking spaces
  final cleanedText = parsedText
      .replaceAll('\u00A0', '') // &nbsp;
      .replaceAll('\n', '')
      .trim();

  return cleanedText.isEmpty;
}