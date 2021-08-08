import 'package:sprintf/sprintf.dart';

// Copied from https://stackoverflow.com/questions/51039602/how-to-format-an-interploated-string/64572644#64572644
extension StringFormatExtension on String {
  String format(var arguments) => sprintf(this, arguments);
}
