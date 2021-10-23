import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/models/contact.dart';
import 'package:sqflite/sqlite_api.dart';

class ContactDao {
  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _fullName = 'full_name';
  static const String _accountNumber = 'account_number';
  static const String tableSql = 'CREATE TABLE $_tableName ('
      '$_id INTEGER PRIMARY KEY, '
      '$_fullName TEXT, '
      '$_accountNumber TEXT)';

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();
    return db.insert(_tableName, _toMap(contact));
  }

  Map<String, Object> _toMap(Contact contact) =>
      {_fullName: contact.name, _accountNumber: contact.accountNumber};

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Contact> contacts = _toList(result);

    return contacts;
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = [];

    for (Map<String, dynamic> row in result) {
      final contact = Contact(
        row[_id],
        row[_fullName],
        int.tryParse(row[_accountNumber])!,
      );

      contacts.add(contact);
    }

    return contacts;
  }
}
