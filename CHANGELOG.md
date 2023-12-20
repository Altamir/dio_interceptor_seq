## 2.0.1

* Update http version.

## 2.0.0

* Update SDK version.
* Add Event Type to the request, response and error logs.

## 1.0.0

* Update dio version and flutter version.

## 0.0.3

* Add deviceIdentifier to the request.

## 0.0.2

* Fixed a log error when status code is 302.
* Fixed parameter ```correlationalSeqID```, in template.

## 0.0.1

* Initial release: This version introduces the SeqLoggingInterceptor for the Dio HTTP client, which logs request, response, and error information to a Seq server. It includes features such as adding a correlational ID to each request, calculating the elapsed time for requests, and handling invalid parameters. The interceptor is easily customizable and can be integrated into any project using the Dio client. Additionally, this release includes tests to ensure the interceptor's functionality and reliability.
