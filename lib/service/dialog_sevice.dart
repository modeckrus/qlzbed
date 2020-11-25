import 'package:flutter/material.dart';

import '../localization/localizations.dart';
import 'firebase_service.dart';

typedef Future<void> VoidAsyncCallBack();

class DialogService {
  static showErrorDialog(BuildContext context, String error) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error),
                Text(error),
                RaisedButton(
                  child: Text(AppLocalizations.of(context).ok),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  static showMoreDialog(BuildContext context, DocumentReference docref) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(),
              ],
            ),
          );
        });
  }

  static Future<void> showLoadingDialog(
      BuildContext context, String text, VoidAsyncCallBack function) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator(), Text(text ?? '')],
            ),
          );
        }).then((value) => {Navigator.pop(context)});
    function().then((_) {
      Navigator.pop(context);
    });
  }
}
