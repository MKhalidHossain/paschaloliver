import 'dart:io';

import '../models/listing_create_payload.dart';

abstract class ListingInterface {
  Future<void> createListing(ListingCreatePayload payload, List<File> gallery);
  Future<bool> hasListing();
}
