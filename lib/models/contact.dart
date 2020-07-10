class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map['idColumn'];
    name = map['nameColumn'];
    email = map['emailColumn'];
    phone = map['phoneColumn'];
    img = map['imgColumn'];
  }

  Map toMap() {
    Map<String, dynamic> mapContact = {
      'nameColumn': name,
      'emailColumn': email,
      'phoneColumn': phone,
      'imgColumn': img
    };

    if ('idColumn' == null) {
      mapContact['idColumn'] = id;
    }

    return mapContact;
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)';
  }
}