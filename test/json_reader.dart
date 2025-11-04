import 'dart:io';

String readJson(String name) {
  final dir = Directory.current.path;
  return File('$dir/test/$name').readAsStringSync();
}
