import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  // 🔐 REST API KEY من OneSignal (انت حاطط المفتاح الصحيح)
  static const String _restApiKey =
      "os_v2_app_r3meo25olvfmndynekmkxuqbrmz7xtk2p7wughelyrdn4kxixcict3yg6h73omd5rwvmhnkjwsrglwhbbdfy2cvoh4bfkv6vkxq7fzy";

  // 📌 OneSignal App ID الحقيقي:
  static const String _appId = "8ed8476b-ae5d-4ac6-8f0d-2298abd2018b";

  static Future<void> send({
    required String receiverId,
    required String title,
    required Map<String, String> contents,
    Map<String, dynamic>? data,
  }) async {
    final payload = {
      "app_id": _appId,
      "include_external_user_ids": [receiverId],
      "headings": {
        "en": title,
        "ar": title,
      },
      "contents": contents,
      "data": data,
      "priority": 10,
    };

    await http.post(
      Uri.parse("https://api.onesignal.com/notifications"),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "Basic $_restApiKey",
      },
      body: jsonEncode(payload),
    );
  }
}
