// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qlzbed/entities/user.dart';
import 'package:qlzbed/pages/error_page.dart';
import 'package:qlzbed/service/firebase_service.dart';

import '../entities/msize.dart';
import 'my_image.dart';

class AddAvatarWidget extends StatefulWidget {
  final Function onAddImage;
  AddAvatarWidget({Key key, @required this.onAddImage}) : super(key: key);
  final _AddAvatarWidgetState state = _AddAvatarWidgetState();

  @override
  _AddAvatarWidgetState createState() => state;
}

class _AddAvatarWidgetState extends State<AddAvatarWidget> {
  void setImage(imagen) {
    setState(() {
      image = imagen;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final docsnap = await FirebaseService.collection('user')
        .document(GetIt.I.get<User>().uid)
        .get();
    if (docsnap.exists && docsnap.data != null) {
      final avatarPath = docsnap.data['Avatar'];
      setState(() {
        image = avatarPath;
      });
    }
  }

  void getImage(context) async {
    List<MSize> sizes = List();
    sizes.add(MSize(
      height: 100,
      width: 100,
    ));
    sizes.add(MSize(width: 20, height: 20));
    print(sizes);
    final user = GetIt.I.get<User>();
    final resultf = await Navigator.push(
        context,
        MaterialPageRoute(
            // builder: (context) => ImageCapture(
            //   path: 'avatar',
            //   uid: user.uid,
            // ),
            builder: (context) => ErrorPage(error: 'Page not implemented')));
    if (resultf != null) {
      final result = resultf;
      print('Result = ' + result.toString());
      widget.onAddImage(result);
      setState(() {
        image = result;
      });
    } else {}
  }

  String image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getImage(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(75)),
        child: Container(
          color: Colors.black38,
          child: SizedBox(
            height: 150,
            width: 150,
            child: image == null
                ? Container(
                    width: 150,
                    height: 150,
                    child: Icon(
                      Icons.add,
                      size: 75,
                      color: Colors.white54,
                    ))
                : MyImage(
                    path: image,
                    size: MSize(width: 200, height: 200),
                  ),
          ),
        ),
      ),
    );
  }
}
