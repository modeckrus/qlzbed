// Copyright (c) 2018, the Qlzb project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../qlzb.dart';

import 'code.dart';
import 'common.dart';
import 'image.dart';
import 'list.dart';
import 'paragraph.dart';
import 'quote.dart';
import 'scope.dart';
import 'theme.dart';

/// Non-scrollable read-only view of QDoc rich text documents.
@experimental
class QlzbView extends StatefulWidget {
  final QDocDocument document;
  final QlzbImageDelegate imageDelegate;

  const QlzbView({Key key, @required this.document, this.imageDelegate})
      : super(key: key);

  @override
  QlzbViewState createState() => QlzbViewState();
}

class QlzbViewState extends State<QlzbView> {
  QlzbScope _scope;
  QlzbThemeData _themeData;

  QlzbImageDelegate get imageDelegate => widget.imageDelegate;

  @override
  void initState() {
    super.initState();
    _scope = QlzbScope.view(imageDelegate: widget.imageDelegate);
  }

  @override
  void didUpdateWidget(QlzbView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scope.imageDelegate = widget.imageDelegate;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final parentTheme = QlzbTheme.of(context, nullOk: true);
    final fallbackTheme = QlzbThemeData.fallback(context);
    _themeData = (parentTheme != null)
        ? fallbackTheme.merge(parentTheme)
        : fallbackTheme;
  }

  @override
  void dispose() {
    _scope.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QlzbTheme(
      data: _themeData,
      child: QlzbScopeAccess(
        scope: _scope,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildChildren(context),
        ),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final result = <Widget>[];
    for (var node in widget.document.root.children) {
      result.add(_defaultChildBuilder(context, node));
    }
    return result;
  }

  Widget _defaultChildBuilder(BuildContext context, Node node) {
    if (node is LineNode) {
      if (node.hasEmbed) {
        return QlzbLine(node: node);
      } else if (node.style.contains(QDocAttribute.heading)) {
        return QlzbHeading(node: node);
      }
      return QlzbParagraph(node: node);
    }

    final BlockNode block = node;
    final blockStyle = block.style.get(QDocAttribute.block);
    if (blockStyle == QDocAttribute.block.code) {
      return QlzbCode(node: block);
    } else if (blockStyle == QDocAttribute.block.bulletList) {
      return QlzbList(node: block);
    } else if (blockStyle == QDocAttribute.block.numberList) {
      return QlzbList(node: block);
    } else if (blockStyle == QDocAttribute.block.quote) {
      return QlzbQuote(node: block);
    }

    throw UnimplementedError('Block format $blockStyle.');
  }
}
