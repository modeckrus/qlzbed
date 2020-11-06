// Copyright (c) 2018, the Qlzb project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../qlzb.dart';
import 'editable_box.dart';
import 'horizontal_rule.dart';
import 'image.dart';
import 'rich_text.dart';
import 'scope.dart';
import 'theme.dart';

/// Represents single line of rich text document in Qlzb editor.
class QlzbLine extends StatefulWidget {
  const QlzbLine({Key key, @required this.node, this.style, this.padding})
      : assert(node != null),
        super(key: key);

  /// Line in the document represented by this widget.
  final LineNode node;

  /// Style to apply to this line. Required for lines with text contents,
  /// ignored for lines containing embeds.
  final TextStyle style;

  /// Padding to add around this paragraph.
  final EdgeInsets padding;

  @override
  _QlzbLineState createState() => _QlzbLineState();
}

class _QlzbLineState extends State<QlzbLine> {
  final LayerLink _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    final scope = QlzbScope.of(context);
    if (scope.isEditable) {
      ensureVisible(context, scope);
    }
    final theme = Theme.of(context);

    Widget content;
    if (widget.node.hasEmbed) {
      content = buildEmbed(context, scope);
    } else {
      assert(widget.style != null);
      content = QlzbRichText(
        node: widget.node,
        text: buildText(context),
      );
    }

    if (scope.isEditable) {
      Color cursorColor;
      switch (theme.platform) {
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          cursorColor ??= CupertinoTheme.of(context).primaryColor;
          break;

        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.windows:
        case TargetPlatform.linux:
          cursorColor = theme.cursorColor;
          break;
      }

      content = EditableBox(
        child: content,
        node: widget.node,
        layerLink: _link,
        renderContext: scope.renderContext,
        showCursor: scope.showCursor,
        selection: scope.selection,
        selectionColor: theme.textSelectionColor,
        cursorColor: cursorColor,
      );
      content = CompositedTransformTarget(link: _link, child: content);
    }

    if (widget.padding != null) {
      return Padding(padding: widget.padding, child: content);
    }
    return content;
  }

  void ensureVisible(BuildContext context, QlzbScope scope) {
    if (scope.selection.isCollapsed &&
        widget.node.containsOffset(scope.selection.extentOffset)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        bringIntoView(context);
      });
    }
  }

  void bringIntoView(BuildContext context) {
    final scrollable = Scrollable.of(context);
    final object = context.findRenderObject();
    assert(object.attached);
    final viewport = RenderAbstractViewport.of(object);
    assert(viewport != null);

    final offset = scrollable.position.pixels;
    var target = viewport.getOffsetToReveal(object, 0.0).offset;
    if (target - offset < 0.0) {
      scrollable.position.jumpTo(target);
      return;
    }
    target = viewport.getOffsetToReveal(object, 1.0).offset;
    if (target - offset > 0.0) {
      scrollable.position.jumpTo(target);
    }
  }

  TextSpan buildText(BuildContext context) {
    final theme = QlzbTheme.of(context);
    final children = widget.node.children
        .map((node) => _segmentToTextSpan(node, theme))
        .toList(growable: false);
    return TextSpan(style: widget.style, children: children);
  }

  TextSpan _segmentToTextSpan(Node node, QlzbThemeData theme) {
    final TextNode segment = node;
    final attrs = segment.style;

    return TextSpan(
      text: segment.value,
      style: _getTextStyle(attrs, theme),
    );
  }

  TextStyle _getTextStyle(QDocStyle style, QlzbThemeData theme) {
    var result = TextStyle();
    if (style.containsSame(QDocAttribute.bold)) {
      result = result.merge(theme.attributeTheme.bold);
    }
    if (style.containsSame(QDocAttribute.italic)) {
      result = result.merge(theme.attributeTheme.italic);
    }
    if (style.contains(QDocAttribute.link)) {
      result = result.merge(theme.attributeTheme.link);
    }
    if (style.containsSame(QDocAttribute.color1)) {
      result = result.copyWith(color: theme.attributeTheme.colorTheme.color1);
    }
    if (style.containsSame(QDocAttribute.color2)) {
      result = result.copyWith(color: theme.attributeTheme.colorTheme.color2);
    }
    if (style.containsSame(QDocAttribute.color3)) {
      result = result.copyWith(color: theme.attributeTheme.colorTheme.color3);
    }
    if (style.containsSame(QDocAttribute.color4)) {
      result = result.copyWith(color: theme.attributeTheme.colorTheme.color4);
    }
    if (style.containsSame(QDocAttribute.color5)) {
      result = result.copyWith(color: theme.attributeTheme.colorTheme.color5);
    }
    if (style.containsSame(QDocAttribute.color6)) {
      result = result.copyWith(color: theme.attributeTheme.colorTheme.color7);
    }
    if (style.containsSame(QDocAttribute.color8)) {
      result = result.copyWith(color: theme.attributeTheme.colorTheme.color9);
    }
    if (style.containsSame(QDocAttribute.color10)) {
      result = result.copyWith(color: theme.attributeTheme.colorTheme.color10);
    }
    if (style.containsSame(QDocAttribute.color11)) {
      result = result.copyWith(color: theme.attributeTheme.colorTheme.color11);
    }
    if (style.containsSame(QDocAttribute.color12)) {
      result = result.copyWith(color: theme.attributeTheme.colorTheme.color12);
    }
    if (style.containsSame(QDocAttribute.mainColor)) {
      result =
          result.copyWith(color: theme.attributeTheme.colorTheme.mainColor);
    }
    if (style.containsSame(QDocAttribute.font1)) {
      result =
          result.copyWith(fontFamily: theme.attributeTheme.fontTheme.font1);
    }
    if (style.containsSame(QDocAttribute.font2)) {
      result =
          result.copyWith(fontFamily: theme.attributeTheme.fontTheme.font2);
    }
    if (style.containsSame(QDocAttribute.font3)) {
      result =
          result.copyWith(fontFamily: theme.attributeTheme.fontTheme.font3);
    }
    if (style.containsSame(QDocAttribute.font4)) {
      result =
          result.copyWith(fontFamily: theme.attributeTheme.fontTheme.font4);
    }
    if (style.containsSame(QDocAttribute.font5)) {
      result =
          result.copyWith(fontFamily: theme.attributeTheme.fontTheme.font5);
    }
    if (style.containsSame(QDocAttribute.font6)) {
      result =
          result.copyWith(fontFamily: theme.attributeTheme.fontTheme.font6);
    }
    if (style.containsSame(QDocAttribute.font7)) {
      result =
          result.copyWith(fontFamily: theme.attributeTheme.fontTheme.font7);
    }
    if (style.containsSame(QDocAttribute.font8)) {
      result =
          result.copyWith(fontFamily: theme.attributeTheme.fontTheme.font8);
    }
    if (style.containsSame(QDocAttribute.mainFont)) {
      result =
          result.copyWith(fontFamily: theme.attributeTheme.fontTheme.mainFont);
    }

    return result;
  }

  Widget buildEmbed(BuildContext context, QlzbScope scope) {
    EmbedNode node = widget.node.children.single;
    EmbedAttribute embed = node.style.get(QDocAttribute.embed);

    if (embed.type == EmbedType.horizontalRule) {
      return QlzbHorizontalRule(node: node);
    } else if (embed.type == EmbedType.image) {
      return QlzbImage(node: node, delegate: scope.imageDelegate);
    } else {
      throw UnimplementedError('Unimplemented embed type ${embed.type}');
    }
  }
}
