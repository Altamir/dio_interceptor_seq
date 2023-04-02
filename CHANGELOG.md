## 0.0.2

* Fixed a log error when status code is 302.
* Fixed parameter ```correlationalSeqID```, in template.

## 0.0.1

* Initial release: This version introduces the SeqLoggingInterceptor for the Dio HTTP client, which logs request, response, and error information to a Seq server. It includes features such as adding a correlational ID to each request, calculating the elapsed time for requests, and handling invalid parameters. The interceptor is easily customizable and can be integrated into any project using the Dio client. Additionally, this release includes tests to ensure the interceptor's functionality and reliability.
