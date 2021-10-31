import 'dart:convert';

import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print(data.toString());
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print(data.toString());
    return data;
  }
}

Future<List<Transaction>> findAll() async {
  var client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  var response =
      await client.get(Uri.parse("http://192.168.0.134:8080/transactions"));
  final List<dynamic> decodedJson = jsonDecode(response.body);
  final List<Transaction> transactions = [];

  for (Map<String, dynamic> transactionJson in decodedJson) {
    var contactJson = Contact(0, transactionJson["contact"]["name"],
        transactionJson["contact"]["accountNumber"]);
    var transaction = Transaction(transactionJson["value"], contactJson);
    transactions.add(transaction);
  }

  return transactions;
}
