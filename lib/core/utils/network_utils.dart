import 'dart:convert' as convert;

// ignore: library_prefixes
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import '/core/exceptions/auth_exception.dart';
import '/core/exceptions/network_exception.dart';
import '/core/exceptions/server_exception.dart';
import '/core/exceptions/token_expired_exception.dart';
import '/core/exceptions/unauthorized_exception.dart';
import '/core/services/key_storage/key_storage_service.dart';
import '../../locator.dart';

void checkForNetworkExceptions(Response response) {
  if (response.statusCode == 401) {
    locator<KeyStorageService>().removeEveryThing();

    throw UnauthorizedException('Unauthorized user Error');
  }

  if (response.statusCode == 403) {
    locator<KeyStorageService>().removeEveryThing();

    throw UnauthorizedException('UnauthorizedAccess user Error');
  }

  if (response.statusCode == 500) {
    print('Server Error');
    throw ServerException('Server Error');
  }

  if (response.statusCode != 200) {
    throw NetworkException('Failed to connect to internet');
  }
}

Future<void> AuthCheck(jsonData) async {
  if (jsonData is Map<String, dynamic>) {
    if (jsonData.containsKey('code')) {
      if (jsonData['code'] == 3009) {
        throw AuthException('Token not provided');
      }
    }

    if (jsonData.containsKey('code')) {
      if (jsonData['code'] == 3010) {
        throw TokenExpiredException('Token expired');
      }
    }
    if (jsonData.containsKey('code')) {
      if (jsonData['code'] == 3011) {
        throw TokenExpiredException('Token invalid');
      }
    }
  }
}

void showLoadingProgress(received, total) {
  if (total != -1) {
    debugPrint('${(received / total * 100).toStringAsFixed(0)}%');
  }
}

dynamic decodeResponseBodyToJson(String body) {
  try {
    final data = convert.jsonDecode(body);
    return data;
  } on FormatException catch (e) {
    debugPrint('Network Utils: Failed to decode response body ${e.message}');
    throw NetworkException(e.message);
  }
}
