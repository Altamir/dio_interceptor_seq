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

## Running Seq with Docker

To run a Seq container using Docker, follow these steps:

1. Install Docker if you haven't already.
2. Pull the latest Seq image from Docker Hub:
    ```bash
    docker pull datalust/seq
    ```
3. Create a new directory to store Seq data:
    ```bash
    mkdir seq_data
    ```
4. Run a Seq container, mapping the created data directory to the container's /data folder and forwarding the default Seq port (5341):
    ```bash
    Copy code
    docker run -d --name seq -v "$(pwd)/seq_data:/data" -p 5341:80 datalust/seq
    ```
   
    This command will run the Seq container in detached mode (-d), with a custom name (--name seq), map the local seq_data directory to the container's /data folder (-v), and forward the host's port 5341 to the container's port 80 (-p).
5. Open your web browser and navigate to http://localhost:5341. You should see the Seq web interface.
You can now use the Seq instance running in the Docker container to collect and analyze your logs. When configuring your ```SeqLoggingInterceptor```, use the Seq URL http://localhost:5341 to send logs to this instance.

For more information on running Seq with Docker, refer to the [official Seq documentation](https://docs.datalust.co/docs/getting-started-with-docker).

## Contributions

Contributions are welcome! If you encounter any issues or have suggestions for improvements, feel free to open an issue or a pull request.

## License

This project is licensed under the MIT License. See the LICENSE file for details.