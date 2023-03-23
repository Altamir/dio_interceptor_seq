# Dio Seq Logging Interceptor

An interceptor for the DIO client that sends request, response, and error logs to Seq.

## Installation

Add the dependency to your pubspec.yaml:

```yaml
dependencies:
  dio_seq_logging_interceptor: ^1.0.0
```
## Usage

To start using the ```SeqLoggingInterceptor```, follow the steps below:

1. Import the package in the file where you are configuring the DIO client:

    ```dart
    import 'package:dio_seq_logging_interceptor/dio_seq_logging_interceptor.dart';
    ```

2. Create an instance of the interceptor, providing the Seq server URL and, optionally, the API key:
    ```dart
    final seqLoggingInterceptor = SeqLoggingInterceptor(
    'https://your-seq-server-url',
    apiKey: 'your-seq-api-key',
    );
    ```
3. Add the interceptor to your DIO client instance:

    ```dart
    final dio = Dio();
    dio.interceptors.add(seqLoggingInterceptor);
    ```

Now, all requests, responses, and errors processed by the DIO client will be logged in Seq.

## Configuration

You can customize the header name used for the correlation ID when creating an instance of the ```SeqLoggingInterceptor```. By default, the header name is ```'X-Request-Seq-Id'```.

```dart
final seqLoggingInterceptor = SeqLoggingInterceptor(
  'https://your-seq-server-url',
  apiKey: 'your-seq-api-key',
  correlationalHeaderName: 'X-Custom-Correlation-ID',
);
```
## Contributions

Contributions are welcome! If you encounter any issues or have suggestions for improvements, feel free to open an issue or a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.