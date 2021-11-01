import 'dart:convert';

import 'package:bytebank/models/transaction.dart';

import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    var response =
        await client.get(Uri.parse(baseUrl)).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((transactionJson) => Transaction.fromJson(transactionJson))
        .toList();
  }

  void save(Transaction transaction) async {
    await client
        .post(Uri.parse(baseUrl),
            headers: {
              "Content-Type": "application/json",
              "password": "1000",
            },
            body: jsonEncode(transaction.toJson()))
        .timeout(Duration(seconds: 5));
  }
}
