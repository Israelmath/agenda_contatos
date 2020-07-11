import 'dart:io';
import 'package:agenda_contatos/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();

  Contact _editedContact;
  bool _userEdited = false;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nomeController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? 'Novo contato'),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          backgroundColor: Colors.red,
          child: Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _searchImage(),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 18.0, right: 18.0),
                child: TextField(
                  focusNode: _nameFocus,
                  controller: _nomeController,
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedContact.name = text;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 8.0, left: 18.0, right: 18.0),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.email = text;
                  },
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 18.0, right: 18.0, bottom: 8.0),
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.phone = text;
                  },
                  decoration: InputDecoration(
                    labelText: 'Phone',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (contextDialog) {
            return AlertDialog(
              title: Text('Descartar alterações?'),
              content: Text('Se sair, as alterações serão perdidas.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(contextDialog);
                  },
                  child: Text('Cancelar'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(contextDialog);
                    Navigator.pop(context);
                  },
                  child: Text('Confirmar'),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  Object _searchImage() {
    if (_editedContact.img == null || _editedContact.img == 'imgTest') {
      return AssetImage('images/person.png');
    } else {
      return FileImage(File(_editedContact.img));
    }
  }
}
