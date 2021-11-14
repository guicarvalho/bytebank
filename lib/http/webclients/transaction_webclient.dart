import 'dart:convert';

import 'package:bytebank/models/transaction.dart';

import '../webclient.dart';

class TransactionWebClient {
  static final Map<int, String> _statusCodeResponse = {
    400: 'there was an error submitting transaction',
    401: 'authentication failed'
  };

  Future<List<Transaction>> findAll() async {
    var response = await client.get(Uri.parse(baseUrl));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((transactionJson) => Transaction.fromJson(transactionJson))
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    var response = await client.post(Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "password": password,
        },
        body: jsonEncode(transaction.toJson()));

    if (response.statusCode != 200) {
      throw HttpException(_statusCodeResponse[response.statusCode]);
    }

    return Transaction.fromJson(jsonDecode(response.body));
  }
}

class HttpException implements Exception {
  final String? message;
  HttpException(this.message);
}
