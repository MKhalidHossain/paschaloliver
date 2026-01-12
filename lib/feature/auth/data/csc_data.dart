import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class CSCity {
  final String id;
  final String name;
  const CSCity({required this.id, required this.name});

  factory CSCity.fromJson(Map<String, dynamic> j) =>
      CSCity(id: "${j['id']}", name: "${j['name']}");
}

class CSState {
  final String id;
  final String name;
  final List<CSCity> cities;
  const CSState({required this.id, required this.name, required this.cities});

  factory CSState.fromJson(Map<String, dynamic> j) => CSState(
    id: "${j['id']}",
    name: "${j['name']}",
    cities: (j['city'] as List? ?? [])
        .map((e) => CSCity.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class CSCountry {
  final String id;
  final String name;
  final String emoji;
  final List<CSState> states;

  const CSCountry({
    required this.id,
    required this.name,
    required this.emoji,
    required this.states,
  });

  factory CSCountry.fromJson(Map<String, dynamic> j) => CSCountry(
    id: "${j['id']}",
    name: "${j['name']}",
    emoji: "${j['emoji'] ?? ''}",
    states: (j['state'] as List? ?? [])
        .map((e) => CSState.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

/// Parses in isolate (fast + smooth UI)
List<CSCountry> _parseCountries(String raw) {
  final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  return list.map(CSCountry.fromJson).toList();
}

class CSCData {
  static List<CSCountry>? _cache;

  static Future<List<CSCountry>> loadCountries() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(
      'packages/country_state_city_picker/lib/assets/country.json',
    );
    _cache = await compute(_parseCountries, raw);
    return _cache!;
  }
}
