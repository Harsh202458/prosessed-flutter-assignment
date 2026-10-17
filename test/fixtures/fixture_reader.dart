import 'dart:convert';
import 'dart:io';

/// Reads a JSON fixture from `test/fixtures/`.
Map<String, dynamic> fixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync())
        as Map<String, dynamic>;
