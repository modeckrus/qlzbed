import 'package:flutter/material.dart';

import '../my_icons.dart';

class MoreButton extends StatefulWidget {
  @override
  _MoreButtonState createState() => _MoreButtonState();
}

class _MoreButtonState extends State<MoreButton> {
  List<DropdownMenuItem> items = <DropdownMenuItem>[
    DropdownMenuItem(
      child: MyIcons.share,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      icon: MyIcons.more,
      items: items,
      onChanged: (value) {},
      onTap: () {},
    );
  }
}
