import 'dart:convert';
import 'dart:developer' as developer;

void logger(dynamic data) {
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String formattedJson = encoder.convert(data);
  developer.log(formattedJson);
}
