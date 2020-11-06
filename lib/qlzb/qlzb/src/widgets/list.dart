// Copyright (c) 2018, the Qlzb project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';

import '../../qlzb.dart';
import 'common.dart';
import 'paragraph.dart';
import 'theme.dart';

/// Represents number lists and bullet lists in a Qlzb editor.
class QlzbList extends StatelessWidget {
  const QlzbList({Key key, @required this.node}) : super(key: key);

  final BlockNode node;

  @override
  Widget build(BuildContext context) {
    final theme = QlzbTheme.of(context);
    final items = <Widget>[];
    var index = 1;
    for (var line in node.children) {
      items.add(_buildItem(line, index));
      index++;
    }

    final isNumberList =
        node.style.get(QDocAttribute.block) == QDocAttribute.block.numberList;
    var padding = isNumberList
        ? theme.attributeTheme.numberList.padding
        : theme.attributeTheme.bulletList.padding;
    padding = padding.copyWith(left: theme.indentWidth);

    return Padding(
      padding: padding,
      child: Column(children: items),
    );
  }

  Widget _buildItem(Node node, int index) {
    LineNode line = node;
    return QlzbListItem(index: index, node: line);
  }
}

/// An item in a [QlzbList].
class QlzbListItem extends StatelessWidget {
  QlzbListItem({Key key, this.index, this.node}) : super(key: key);

  final int index;
  final LineNode node;

  @override
  Widget build(BuildContext context) {
    final BlockNode block = node.parent;
    final style = block.style.get(QDocAttribute.block);
    final theme = QlzbTheme.of(context);
    final blockTheme = (style == QDocAttribute.block.bulletList)
        ? theme.attributeTheme.bulletList
        : theme.attributeTheme.numberList;
    final bulletText =
        (style == QDocAttribute.block.bulletList) ? '•' : '$index.';

    TextStyle textStyle;
    Widget content;
    EdgeInsets padding;

    if (node.style.contains(QDocAttribute.heading)) {
      final headingTheme = QlzbHeading.themeOf(node, context);
      textStyle = headingTheme.textStyle;
      padding = headingTheme.padding;
      content = QlzbHeading(node: node);
    } else {
      textStyle = theme.defaultLineTheme.textStyle;
      content = QlzbLine(
        node: node,
        style: textStyle,
        padding: blockTheme.linePadding,
      );
      padding = blockTheme.linePadding;
    }

    Widget bullet =
        SizedBox(width: 24.0, child: Text(bulletText, style: textStyle));
    if (padding != null) {
      bullet = Padding(padding: padding, child: bullet);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[bullet, Expanded(child: content)],
    );
  }
}
