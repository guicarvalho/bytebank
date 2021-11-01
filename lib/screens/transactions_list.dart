import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionsList extends StatelessWidget {
  final _webClient = TransactionWebClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _webClient.findAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Progress();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final List<Transaction> transactions = snapshot.data ?? [];

            if (transactions.isEmpty) {
              return CenteredMessage("Transactions not found",
                  icon: Icons.warning);
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                final Transaction transaction = transactions[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.monetization_on),
                    title: Text(
                      transaction.value.toString(),
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      transaction.contact.accountNumber.toString(),
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            );
          }

          return CenteredMessage("Unknown error");
        },
      ),
    );
  }
}
