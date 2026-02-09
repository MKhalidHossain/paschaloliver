import 'package:dio/dio.dart';

class CSCity {
  final String id;
  final String name;
  const CSCity({required this.id, required this.name});

  factory CSCity.fromJson(Map<String, dynamic> j) =>
      CSCity(id: "${j['id']}", name: "${j['name']}");
}

List _safeList(dynamic value) {
  if (value is List) return value;
  if (value is Map) return value.values.toList();
  return const [];
}

class CSState {
  final String id;
  final String name;
  final List<CSCity> cities;
  const CSState({required this.id, required this.name, required this.cities});

  factory CSState.fromJson(Map<String, dynamic> j) => CSState(
    id: "${j['id']}",
    name: "${j['name']}",
    cities: _safeList(j['city'])
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
    states: _safeList(j['state'])
        .map((e) => CSState.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  factory CSCountry.fromApi(Map<String, dynamic> j) => CSCountry(
    id: "${j['iso2'] ?? j['iso3'] ?? j['country'] ?? ''}",
    name: "${j['country'] ?? ''}",
    emoji: "",
    states: _safeList(j['cities'])
        .map(
          (c) => CSState(
            id: c.toString(),
            name: c.toString(),
            cities: const [],
          ),
        )
        .toList(),
  );
}

class CSCData {
  static List<CSCountry>? _cache;

  static Future<List<CSCountry>> loadCountries() async {
    if (_cache != null) return _cache!;
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    final res = await dio.get('https://api.evpitch.com/api/v1/countries');
    final body = res.data;
    final dynamic data = body is Map ? body['data'] : body;
    final List list = _safeList(data);
    _cache = list
        .whereType<Map>()
        .map((e) => CSCountry.fromApi(Map<String, dynamic>.from(e)))
        .toList();
    return _cache!;
  }
}
