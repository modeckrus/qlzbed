// Copyright (c) 2018, the Qlzb project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';

import '../../qlzb.dart';
import 'common.dart';
import 'theme.dart';

/// Represents a code snippet in Qlzb editor.
class QlzbCode extends StatelessWidget {
  const QlzbCode({Key key, @required this.node}) : super(key: key);

  /// Document node represented by this widget.
  final BlockNode node;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final zefyrTheme = QlzbTheme.of(context);

    final items = <Widget>[];
    for (var line in node.children) {
      items.add(_buildLine(line, zefyrTheme.attributeTheme.code.textStyle));
    }

    // TODO: move background color and decoration to BlockTheme
    final color = theme.primaryColorBrightness == Brightness.light
        ? Colors.grey.shade200
        : Colors.grey.shade800;
    return Padding(
      padding: zefyrTheme.attributeTheme.code.padding,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: items,
        ),
      ),
    );
  }

  Widget _buildLine(Node node, TextStyle style) {
    LineNode line = node;
    return QlzbLine(node: line, style: style);
  }
}
