import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../localization/localizations.dart';

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
}
