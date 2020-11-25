import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../entities/user.dart';
import '../localization/localizations.dart';
import '../service/firebase_service.dart';
import '../settingUser/settinguserbloc/settinguser_bloc.dart';

class SettingsUserWidget extends StatefulWidget {
  SettingsUserWidget({Key key}) : super(key: key);

  @override
  _SettingsUserWidgetState createState() => _SettingsUserWidgetState();
}

class _SettingsUserWidgetState extends State<SettingsUserWidget> {
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

  String get _name => _nameController.text;
  String get _surname => _surnameController.text;
  // String get _email => _emailController.text;
  User _getUser() {
    User user = User(
      name: _name ?? '',
      surname: _surname ?? '',
      uid: GetIt.I.get<User>().uid ?? '',
    );
    return user;
  }

  void getInformation() async {
    final docsnap = await FirebaseService.collection('user')
        .document(GetIt.I.get<User>().uid)
        .get();
    User user = User.fromJson(docsnap.data);
    _nameController.text = user.name ?? '';
    _surnameController.text = user.surname ?? '';
    // _emailController.text = user.uid ?? '';
    if (user.isSetted) {
      print('Setted');
    } else {
      print('not Setted');
    }
  }

  onChange() {
    BlocProvider.of<SettinguserBloc>(context)
        .add(SettinguserChange(_getUser()));
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
                controller: _nameController,
                onChanged: (val) {
                  onChange();
                },
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).name),
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: TextField(
                onChanged: (val) {
                  onChange();
                },
                controller: _surnameController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).surname),
              )),
            ],
          ),
          // TextField(
          //   // controller: _emailController,
          //   onChanged: (val) {
          //     onChange();
          //   },
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
