import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dio_interceptor_seq/dio_interceptor_seq.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dio_interceptor_seq_test.mocks.dart';

@GenerateMocks([HttpClientAdapter])
void main() {
  group('SeqLoggingInterceptor', () {
    const seqUrl = 'https://example.com/seq';
    const apiKey = 'testApiKey';
    const correlationalHeaderName = 'X-Request-Seq-Id';
    test('should create an instance with valid parameters', () {
      final interceptor = SeqLoggingInterceptor(
        seqUrl,
        apiKey: apiKey,
        correlationalHeaderName: correlationalHeaderName,
      );

      expect(interceptor, isA<SeqLoggingInterceptor>());
      expect(interceptor.seqUrl, seqUrl);
      expect(interceptor.apiKey, apiKey);
      expect(interceptor.correlationalHeaderName, correlationalHeaderName);
    });

    test('should throw an AssertionError when correlationalHeaderName is empty',
        () {
      expect(
        () => SeqLoggingInterceptor(
          seqUrl,
          apiKey: apiKey,
          correlationalHeaderName: '',
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('SeqLoggingInterceptor', () {
    test('validar se vai chamar o interceptor', () async {
      final Dio dio = Dio();
      final dioAdapterMock = MockHttpClientAdapter();
      dio.httpClientAdapter = dioAdapterMock;
      const seqUrl = 'http://localhost:5341';
      dio.interceptors.add(SeqLoggingInterceptor(seqUrl));
      final responsePayload = jsonEncode({"response_code": "1000"});

      final httpResponse = ResponseBody.fromString(
        responsePayload,
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

      when(dioAdapterMock.fetch(argThat(isA<RequestOptions>()), any, any))
          .thenAnswer((_) => Future.value(httpResponse));

      final response = await dio.post("/any_url", data: {"body": "body"});
      final expected = {"response_code": "1000"};

      expect(response.data, equals(expected));
    });
  });
}
