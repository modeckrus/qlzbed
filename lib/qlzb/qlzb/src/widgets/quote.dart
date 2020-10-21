// Copyright (c) 2018, the Qlzb project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import '../../qlzb.dart';

import 'paragraph.dart';
import 'theme.dart';

/// Represents a quote block in a Qlzb editor.
class QlzbQuote extends StatelessWidget {
  const QlzbQuote({Key key, @required this.node}) : super(key: key);

  final BlockNode node;

  @override
  Widget build(BuildContext context) {
    final theme = QlzbTheme.of(context);
    final style = theme.attributeTheme.quote.textStyle;
    final items = <Widget>[];
    for (var line in node.children) {
      items.add(_buildLine(line, style, theme.indentWidth));
    }

    return Padding(
      padding: theme.attributeTheme.quote.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items,
      ),
    );
  }

  Widget _buildLine(Node node, TextStyle blockStyle, double indentSize) {
    LineNode line = node;

    Widget content;
    if (line.style.contains(QDocAttribute.heading)) {
      content = QlzbHeading(node: line, blockStyle: blockStyle);
    } else {
      content = QlzbParagraph(node: line, blockStyle: blockStyle);
    }

    final row = Row(children: <Widget>[Expanded(child: content)]);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 4.0, color: Colors.grey.shade300),
        ),
      ),
      padding: EdgeInsets.only(left: indentSize),
      child: row,
    );
  }
}
