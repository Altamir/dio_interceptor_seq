import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'package:dio_interceptor_seq/src/constants.dart';

/// An interceptor for the DIO client that sends request, response, and error logs to Seq.
class SeqLoggingInterceptor extends Interceptor {
  /// The Seq server URL to send logs to.
  final String seqUrl;

  /// The optional API key for the Seq server.
  final String? apiKey;

  /// The header name used for the correlational ID, which is added to each request.
  /// The correlational ID is a UUID generated in the [onRequest] method. Defaults to 'X-Request-Seq-Id'.
  final String correlationalHeaderName;

  final String? deviceIdentifier;

  /// Creates a new instance of the [SeqLoggingInterceptor].
  ///
  /// [seqUrl] is the URL of the Seq server.
  /// [apiKey] is an optional API key for the Seq server.
  /// [correlationalHeaderName] is the header name used for the correlational ID. Defaults to 'X-Request-Seq-Id'.
  /// [deviceIdentifier] is an optional device identifier to be added to the log.
  SeqLoggingInterceptor(
    this.seqUrl, {
    this.apiKey,
    this.correlationalHeaderName = 'X-Request-Seq-Id',
    this.deviceIdentifier,
  })  : assert(
          correlationalHeaderName.isNotEmpty,
          'The correlationalHeaderName cannot be empty',
        ),
        assert(
          Uri.parse(seqUrl).isAbsolute,
          'The provided seqUrl is not a valid URL',
        );

  Future<void> _sendToSeq(Map<String, dynamic> clefEvent) async {
    final body = json.encode(clefEvent);

    try {
      final headers = {'ContentType': CONTENT_TYPE_CLEF};
      if (apiKey != null) {
        headers[SEQ_API_KEY] = apiKey!;
      }

      final response = await http.post(
        Uri.parse('$seqUrl/api/events/raw?clef'),
        headers: headers,
        body: body,
      );

      if (response.statusCode < 200 || response.statusCode >= 202) {
        if (kDebugMode) {
          print('$ERROR_SEND_TO_SEQ ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('$ERROR_SEND_TO_SEQ $e');
      }
    }
  }

  Map<String, dynamic> _createClefEvent(
    String messageTemplate,
    Map<String, dynamic> properties,
  ) {
    return {
      '@t': DateTime.now().toUtc().toIso8601String(),
      '@mt': messageTemplate,
      '@l': 'Information',
      ...properties,
    };
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final correlationalSeqID = const Uuid().v4();
    options.headers[correlationalHeaderName] = correlationalSeqID;
    options.headers['X-Request-Start-Time'] =
        DateTime.now().millisecondsSinceEpoch;

    final clefEvent = _createClefEvent(TEMPLATE_REQUEST, {
      'event_type': 'REQUEST',
      'method': options.method,
      'path': options.path,
      'correlationalSeqID': correlationalSeqID,
      'data': options.data,
      'queryParams': options.queryParameters,
      'headers': options.headers,
      'deviceIdentifier': deviceIdentifier ?? 'unknown',
    });
    _sendToSeq(clefEvent);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final correlationalSeqID =
        response.requestOptions.headers[correlationalHeaderName];
    final startTime =
        response.requestOptions.headers['X-Request-Start-Time'] as int;
    final elapsedTime = DateTime.now().millisecondsSinceEpoch - startTime;

    final clefEvent = _createClefEvent(TEMPLATE_RESPONSE, {
      'event_type': 'RESPONSE',
      'statusCode': response.statusCode,
      'path': response.requestOptions.path,
      'correlationalSeqID': correlationalSeqID,
      'data': response.data,
      'headers': response.headers.map.map((k, v) => MapEntry(k, v.join(', '))),
      'elapsedTime': elapsedTime,
      'deviceIdentifier': deviceIdentifier ?? 'unknown',
    });
    _sendToSeq(clefEvent);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final correlationalSeqID =
        err.requestOptions.headers[correlationalHeaderName];
    final startTime = err.requestOptions.headers['X-Request-Start-Time'] as int;
    final elapsedTime = DateTime.now().millisecondsSinceEpoch - startTime;

    final clefEvent = _createClefEvent(TEMPLATE_ERRO, {
      'event_type': 'ON_ERROR',
      'statusCode': err.response?.statusCode,
      'path': err.requestOptions.path,
      'correlationalSeqID': correlationalSeqID,
      'message': err.message,
      'errorData': err.response?.data,
      'headers': err.requestOptions.headers,
      'elapsedTime': elapsedTime,
      'deviceIdentifier': deviceIdentifier ?? 'unknown',
    });
    _sendToSeq(clefEvent);
    super.onError(err, handler);
  }
}
