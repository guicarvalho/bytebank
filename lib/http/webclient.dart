import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';

var client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);
var baseUrl = "http://192.168.0.134:8080/transactions";
