import 'package:agenda_contatos/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTable = 'contactTable';
final String idColumn = 'idColumn';
final String nameColumn = 'nameColumn';
final String emailColumn = 'emailColumn';
final String phoneColumn = 'phoneColumn';
final String imgColumn = 'imgColumn';

class ContactDao {
  static final ContactDao _instance = ContactDao.internal();

  factory ContactDao() => _instance;

  ContactDao.internal();

  Database _db;

  get db async {
    if (_db != null)
      return _db;
    else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contacts.db');

//    print(path);

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute("""
      CREATE TABLE IF NOT EXISTS $contactTable(
        $idColumn INTEGER PRIMARY KEY,
        $nameColumn TEXT,
        $emailColumn TEXT,
        $phoneColumn TEXT,
        $imgColumn TEXT
      )
     """);
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> mapContact = await dbContact.query(contactTable,
        columns: [
          idColumn,
          nameColumn,
          emailColumn,
          phoneColumn,
          imgColumn,
        ],
        where: '$idColumn = ?',
        whereArgs: [id]);
    if (mapContact.length != 0) {
      return Contact.fromMap(mapContact.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact
        .delete(contactTable, where: '$idColumn = ?', whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    print(contact);
    return await dbContact.update(contactTable, contact.toMap(),
        where: '$idColumn = ?', whereArgs: [contact.id]);
  }

  Future<List<Contact>> getAll() async {
    Database dbContact = await db;
    List contactsListMap = await dbContact.rawQuery('SELECT * FROM $contactTable');
    List<Contact> listContacts = List();
    for(Map contact in contactsListMap){
      listContacts.add(Contact.fromMap(contact));
    }
    return listContacts;
  }

  Future<int> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery('SELECT COUNT(*) FROM $contactTable'));
  }

  Future close() async{
    Database dbContact = await db;
    dbContact.close();
  }


}
