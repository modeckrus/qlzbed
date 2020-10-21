// Copyright (c) 2018, the Qlzb project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import '../../qlzb.dart';

import 'common.dart';
import 'theme.dart';

/// Represents regular paragraph line in a Qlzb editor.
class QlzbParagraph extends StatelessWidget {
  QlzbParagraph({Key key, @required this.node, this.blockStyle})
      : super(key: key);

  final LineNode node;
  final TextStyle blockStyle;

  @override
  Widget build(BuildContext context) {
    final theme = QlzbTheme.of(context);
    var style = theme.defaultLineTheme.textStyle;
    if (blockStyle != null) {
      style = style.merge(blockStyle);
    }
    return QlzbLine(
      node: node,
      style: style,
      padding: theme.defaultLineTheme.padding,
    );
  }
}

/// Represents heading-styled line in [QlzbEditor].
class QlzbHeading extends StatelessWidget {
  QlzbHeading({Key key, @required this.node, this.blockStyle})
      : assert(node.style.contains(QDocAttribute.heading)),
        super(key: key);

  final LineNode node;
  final TextStyle blockStyle;

  @override
  Widget build(BuildContext context) {
    final theme = themeOf(node, context);
    var style = theme.textStyle;
    if (blockStyle != null) {
      style = style.merge(blockStyle);
    }
    return QlzbLine(
      node: node,
      style: style,
      padding: theme.padding,
    );
  }

  static LineTheme themeOf(LineNode node, BuildContext context) {
    final theme = QlzbTheme.of(context);
    final style = node.style.get(QDocAttribute.heading);
    if (style == QDocAttribute.heading.level1) {
      return theme.attributeTheme.heading1;
    } else if (style == QDocAttribute.heading.level2) {
      return theme.attributeTheme.heading2;
    } else if (style == QDocAttribute.heading.level3) {
      return theme.attributeTheme.heading3;
    }
    throw UnimplementedError('Unsupported heading style $style');
  }
}
