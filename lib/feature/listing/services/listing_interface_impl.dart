import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:paschaloliver/core/network/api_service/api_client.dart';

import '../models/listing_create_payload.dart';
import 'listing_interface.dart';

class ListingInterfaceImpl implements ListingInterface {
  ListingInterfaceImpl({required this.apiClient});

  final ApiClient apiClient;

  static const int _maxBytes = 500 * 1024; // 500 KB per image

  Future<File> _maybeCompress(File file) async {
    try {
      final len = await file.length();
      if (len <= _maxBytes) return file;

      const qualities = [80, 70, 60, 50, 40];
      File current = file;

      for (final q in qualities) {
        final targetPath =
            "${Directory.systemTemp.path}/listing_${DateTime.now().millisecondsSinceEpoch}_q$q.jpg";
        final result = await FlutterImageCompress.compressAndGetFile(
          current.path,
          targetPath,
          quality: q,
          minWidth: 1024,
          minHeight: 1024,
          keepExif: false,
        );
        if (result == null) continue;
        current = File(result.path);
        final size = await current.length();
        if (size <= _maxBytes) return current;
      }

      return current;
    } catch (_) {
      return file;
    }
  }

  @override
  Future<void> createListing(ListingCreatePayload payload, List<File> gallery) async {
    final List<MultipartFile> files = [];
    for (final file in gallery) {
      final compressed = await _maybeCompress(file);
      files.add(
        await MultipartFile.fromFile(
          compressed.path,
          filename: compressed.uri.pathSegments.isNotEmpty
              ? compressed.uri.pathSegments.last
              : 'gallery.jpg',
        ),
      );
    }

    final form = FormData.fromMap({
      'data': jsonEncode(payload.toJson()),
      'gallery': files,
    });

    await apiClient.post(
      '/listing',
      data: form,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<bool> hasListing() async {
    final res = await apiClient.get('/listing');
    final body = res.data;
    List list = [];
    if (body is Map) {
      final data = body['data'];
      if (data is List) list = data;
    } else if (body is List) {
      list = body;
    }
    return list.isNotEmpty;
  }
}
