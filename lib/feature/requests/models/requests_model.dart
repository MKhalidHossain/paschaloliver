class RequestItem {
  final String name;
  final double price;
  final String date;
  final String time;
  final String service;
  final String email;
  final String phone;
  final String location;
  final String? avatarUrl;
  final String status;

  // details extras
  final double rating;
  final int ratingCount;
  final String duration;
  final String distance;

  const RequestItem({
    required this.name,
    required this.price,
    required this.date,
    required this.time,
    required this.service,
    required this.email,
    required this.phone,
    required this.location,
    this.avatarUrl,
    this.status = "new",
    this.rating = 4.8,
    this.ratingCount = 350,
    this.duration = "15 min",
    this.distance = "1.1 Km",
  });

  factory RequestItem.fromMap(Map<String, dynamic> map) {
    String asString(dynamic v) => v == null ? "" : v.toString();
    double asDouble(dynamic v) {
      if (v is num) return v.toDouble();
      return double.tryParse(asString(v)) ?? 0;
    }

    final client = map["client"];
    final Map<String, dynamic> clientMap =
        client is Map ? Map<String, dynamic>.from(client) : <String, dynamic>{};
    final service = map["service"];
    final Map<String, dynamic> serviceMap =
        service is Map ? Map<String, dynamic>.from(service) : <String, dynamic>{};
    final address = map["address"];
    final Map<String, dynamic> addressMap =
        address is Map ? Map<String, dynamic>.from(address) : <String, dynamic>{};

    String pick(Map<String, dynamic> src, List<String> keys) {
      for (final k in keys) {
        final v = src[k];
        if (v != null && v.toString().trim().isNotEmpty) return v.toString();
      }
      return "";
    }

    String formatDate(String raw) {
      final dt = DateTime.tryParse(raw);
      if (dt == null) return raw;
      final month = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ][dt.month - 1];
      return "${dt.day} $month ${dt.year}";
    }

    final rawDate = pick(map, ["date", "scheduledDate", "bookingDate", "createdAt"]);
    final rawTime = pick(map, ["time", "scheduledTime", "timeSlot"]);

    return RequestItem(
      name: pick(clientMap, ["name", "fullName", "userName"])
          .isNotEmpty
          ? pick(clientMap, ["name", "fullName", "userName"])
          : pick(map, ["name", "customerName", "clientName"]),
      price: asDouble(
        map["price"] ?? map["amount"] ?? map["total"] ?? map["servicePrice"],
      ),
      date: rawDate.isNotEmpty ? formatDate(rawDate) : "",
      time: rawTime,
      service: pick(serviceMap, ["name", "title", "serviceName"])
          .isNotEmpty
          ? pick(serviceMap, ["name", "title", "serviceName"])
          : pick(map, ["service", "serviceType", "category", "title"]),
      email: pick(clientMap, ["email"]).isNotEmpty
          ? pick(clientMap, ["email"])
          : pick(map, ["email"]),
      phone: pick(clientMap, ["phone", "phoneNumber"]).isNotEmpty
          ? pick(clientMap, ["phone", "phoneNumber"])
          : pick(map, ["phone", "phoneNumber"]),
      location: pick(addressMap, ["address", "fullAddress", "location"])
          .isNotEmpty
          ? pick(addressMap, ["address", "fullAddress", "location"])
          : pick(map, ["address", "location", "serviceAddress"]),
      avatarUrl: pick(clientMap, ["avatar", "image", "photo", "profileImage"])
          .isNotEmpty
          ? pick(clientMap, ["avatar", "image", "photo", "profileImage"])
          : pick(map, ["avatar", "image", "photo"]),
      status: pick(map, ["status", "requestStatus", "state"]).toLowerCase(),
    );
  }
}
