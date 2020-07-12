import 'dart:io';
import 'package:agenda_contatos/dao/contact_dao.dart';
import 'package:agenda_contatos/models/contact.dart';
import 'package:agenda_contatos/screens/contact_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

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
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text('Ordenar A-Z'),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text('Ordenar Z-A'),
                value: OrderOptions.orderza,
              )
            ],
            onSelected: _orderList,
          )
        ],
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
          return _contactCard(context, index);
        },
        padding: EdgeInsets.all(10),
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
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
                    fit: BoxFit.cover,
                    image: _searchImage(index),
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
                    contacts[index].name ?? "",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(contacts[index].email),
                  Text(contacts[index].phone),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
//        _showContactPage(contact: contacts[index]);
        _showOptions(context, index);
      },
    );
  }

  _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: (){},
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FlatButton(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Ligar',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    onPressed: () {
                      launch('tel:${contacts[index].phone}');
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Editar',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _showContactPage(contact: contacts[index]);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Excluir',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      clientDao.deleteContact(contacts[index].id);
                      setState(() {
                        contacts.removeAt(index);
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showContactPage({Contact contact}) async {
    final maybeContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactPage(
          contact: contact,
        ),
      ),
    );

    if (maybeContact != null) {
      if (contact != null) {
        await clientDao.updateContact(maybeContact);
      } else {
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

  Object _searchImage(int index) {
    if (contacts[index].img == null || contacts[index].img == 'imgTest') {
      return AssetImage('images/person.png');
    } else {
      return FileImage(File(contacts[index].img));
    }
  }

  void _orderList(OrderOptions result){
    switch(result){

      case OrderOptions.orderaz:
        contacts.sort((a, b){
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b){
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }
}
