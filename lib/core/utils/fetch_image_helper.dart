 import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

Future<ImageProvider> fetchImage(String imageUrl, String token) async {
    final response = await Dio().get(
      'https://ms.itmd-b1.com:5123$imageUrl',
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'Authorization': 'Bearer $token'},
      ),
    );
    return MemoryImage(Uint8List.fromList(response.data));
  }