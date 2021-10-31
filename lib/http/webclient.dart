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

var client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);
var baseUrl = "http://192.168.0.128:8080/transactions";

Future<List<Transaction>> findAll() async {
  var response =
      await client.get(Uri.parse(baseUrl)).timeout(Duration(seconds: 5));
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

void save(Transaction transaction) async {
  var payload = {
    "value": transaction.value,
    "contact": {
      "name": transaction.contact.name,
      "accountNumber": transaction.contact.accountNumber
    }
  };
  await client
      .post(Uri.parse(baseUrl),
          headers: {
            "Content-Type": "application/json",
            "password": "1000",
          },
          body: jsonEncode(payload))
      .timeout(Duration(seconds: 5));
}
