import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../entities/user.dart';
import '../localization/localizations.dart';

class DisplayUserWidget extends StatefulWidget {
  DisplayUserWidget({Key key}) : super(key: key);

  @override
  _DisplayUserWidgetState createState() => _DisplayUserWidgetState();
}

class _DisplayUserWidgetState extends State<DisplayUserWidget> {
  TextEditingController _nameController;
  TextEditingController _surnameController;
  // TextEditingController _emailController;
  // TextEditingController _numberController;
  // TextEditingController _countryController;
  @override
  void initState() {
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    // _emailController = TextEditingController();
    // _nameController.addListener(() {});
    // _surnameController.addListener(() {
    //   widget.onChange(_getUser());
    // });
    // _markaController.addListener(() {
    //   widget.onChange(_getUser());
    // });
    // _modelController.addListener(() {
    //   widget.onChange(_getUser());
    // });
    // _cityController.addListener(() {
    //   widget.onChange(_getUser());
    // });
    getInformation();
    super.initState();
  }

  // String get _name => _nameController.text;
  // String get _surname => _surnameController.text;
  // String get _marka => _markaController.text;
  // String get _model => _modelController.text;
  // String get _city => _cityController.text;
  // User _getUser() {
  //   User user = User(
  //       name: _name ?? '',
  //       surname: _surname ?? '',
  //       marka: _marka ?? '',
  //       model: _model ?? '',
  //       city: _city ?? '');
  //   return user;
  // }

  void getInformation() async {
    // User user = GetIt.I.get<User>();
    // if (user != null) {
    // } else {
    final docsnap = await Firestore.instance
        .collection('user')
        .document(GetIt.I.get<FirebaseUser>().uid)
        .get();
    User user = User.fromJson(docsnap.data);
    // GetIt.I.registerSingleton(user);
    // }
    _nameController.text = user.name ?? '';
    _surnameController.text = user.surname ?? '';
    // _emailController.text = user.uid ?? '';
    if (user.isSetted) {
      print('Setted');
    } else {
      print('not Setted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                  child: TextField(
                readOnly: true,
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).name),
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextField(
                readOnly: true,
                controller: _surnameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).surname),
              )),
            ],
          ),
          // TextField(
          //   readOnly: true,
          //   controller: _emailController,
          //   decoration:
          //       InputDecoration(labelText: AppLocalizations.of(context).email),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(top: 20),
          //   child: Text(
          //     'Номер телефона',
          //     style: TextStyle(fontSize: 24),
          //   ),
          // ),
          // Row(
          //   mainAxisSize: MainAxisSize.max,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          //       child: SizedBox(
          //           width: 50,
          //           child: TextField(
          //             controller: _countryController,
          //             onChanged: (String number) {
          //               if (number.contains(' ')) {
          //                 _countryController.text =
          //                     _countryController.text.replaceAll(' ', '');
          //               }
          //             },
          //             keyboardType: TextInputType.phone,
          //             maxLength: 4,
          //           )),
          //     ),
          //     Expanded(
          //         child: Padding(
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          //       child: TextField(
          //         controller: _numberController,
          //         onChanged: (String number) {
          //           if (number.contains(' ')) {
          //             _numberController.text =
          //                 _numberController.text.replaceAll(' ', '');
          //           }
          //         },
          //         keyboardType: TextInputType.phone,
          //         maxLength: 10,
          //       ),
          //     )),
          //   ],
          // ),
        ],
      ),
    );
  }
}
