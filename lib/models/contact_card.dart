import 'dart:io';

import 'package:agenda_contatos/dao/contact_dao.dart';
import 'package:agenda_contatos/models/contact.dart';
import 'package:agenda_contatos/screens/contact_form.dart';
import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  List<Contact> listContacts;

  ContactCard(this.contact, this.listContacts);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: 70.0,
                height: 70.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _searchImage(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    contact.name ?? "",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(contact.email),
                  Text(contact.phone),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
//        _showContactPage(context, this.contact);
        _showOptions(context);
      },
    );
  }

  void _showOptions(BuildContext context) {
    showBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Ligar',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      'Editar',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      'Cancelar',
                      style: TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showContactPage(BuildContext context, Contact contact) async {
    final ContactDao clientDao = ContactDao();

    final maybeContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));

    if (maybeContact != null) {
      if (contact != null) {
        await clientDao.updateContact(maybeContact);
      } else {
        await clientDao.saveContact(maybeContact);
      }
    }
    clientDao.getAll().then((list) {
      listContacts = list;
    });
  }

  Object _searchImage() {
    if (contact.img == null || contact.img == 'imgTest') {
      return AssetImage('images/person.png');
    } else {
      return FileImage(File(contact.img));
    }
  }
}
