import 'package:agenda_contatos/dao/contact_dao.dart';
import 'package:agenda_contatos/models/contact.dart';
import 'package:agenda_contatos/models/contact_card.dart';
import 'package:agenda_contatos/screens/contact_form.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  ContactDao clientDao = ContactDao();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(
          'Contatos',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ContactCard(contacts[index], contacts);
        },
        padding: EdgeInsets.all(10),
      ),
    );
  }

  void _showContactPage({Contact contact}) async {
    final maybeContact = await Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));

    if(maybeContact != null){
      if(contact != null){
        await clientDao.updateContact(maybeContact);
      }
      else{
        await clientDao.saveContact(maybeContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    clientDao.getAll().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }
}
