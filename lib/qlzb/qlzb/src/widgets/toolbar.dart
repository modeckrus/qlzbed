// Copyright (c) 2018, the Qlzb project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../qlzb.dart';

import 'buttons.dart';
import 'scope.dart';
import 'theme.dart';

/// List of all button actions supported by [QlzbToolbar] buttons.
enum QlzbToolbarAction {
  bold,
  italic,
  link,
  unlink,
  clipboardCopy,
  openInBrowser,
  heading,
  headingLevel1,
  headingLevel2,
  headingLevel3,
  color,
  font,
  mainColor,
  color1,
  color2,
  color3,
  color4,
  color5,
  color6,
  color7,
  color8,
  color9,
  color10,
  color11,
  color12,
  mainFont,
  font1,
  font2,
  font3,
  font4,
  font5,
  font6,
  font7,
  font8,
  bulletList,
  numberList,
  code,
  quote,
  horizontalRule,
  image,
  cameraImage,
  galleryImage,
  hideKeyboard,
  close,
  confirm,
}

final kQlzbToolbarAttributeActions = <QlzbToolbarAction, QDocAttributeKey>{
  QlzbToolbarAction.bold: QDocAttribute.bold,
  QlzbToolbarAction.italic: QDocAttribute.italic,
  QlzbToolbarAction.link: QDocAttribute.link,
  QlzbToolbarAction.heading: QDocAttribute.heading,
  QlzbToolbarAction.headingLevel1: QDocAttribute.heading.level1,
  QlzbToolbarAction.headingLevel2: QDocAttribute.heading.level2,
  QlzbToolbarAction.headingLevel3: QDocAttribute.heading.level3,
  QlzbToolbarAction.color: QDocAttribute.color,
  QlzbToolbarAction.mainColor: QDocAttribute.mainColor,
  QlzbToolbarAction.color1: QDocAttribute.color1,
  QlzbToolbarAction.color2: QDocAttribute.color2,
  QlzbToolbarAction.color3: QDocAttribute.color3,
  QlzbToolbarAction.color4: QDocAttribute.color4,
  QlzbToolbarAction.color5: QDocAttribute.color5,
  QlzbToolbarAction.color6: QDocAttribute.color6,
  QlzbToolbarAction.color7: QDocAttribute.color7,
  QlzbToolbarAction.color8: QDocAttribute.color8,
  QlzbToolbarAction.color9: QDocAttribute.color9,
  QlzbToolbarAction.color10: QDocAttribute.color10,
  QlzbToolbarAction.color11: QDocAttribute.color11,
  QlzbToolbarAction.color12: QDocAttribute.color12,
  QlzbToolbarAction.font: QDocAttribute.font,
  QlzbToolbarAction.mainFont: QDocAttribute.mainFont,
  QlzbToolbarAction.font1: QDocAttribute.font1,
  QlzbToolbarAction.font2: QDocAttribute.font2,
  QlzbToolbarAction.font3: QDocAttribute.font3,
  QlzbToolbarAction.font4: QDocAttribute.font4,
  QlzbToolbarAction.font5: QDocAttribute.font5,
  QlzbToolbarAction.font6: QDocAttribute.font6,
  QlzbToolbarAction.font7: QDocAttribute.font7,
  QlzbToolbarAction.font8: QDocAttribute.font8,
  QlzbToolbarAction.bulletList: QDocAttribute.block.bulletList,
  QlzbToolbarAction.numberList: QDocAttribute.block.numberList,
  QlzbToolbarAction.code: QDocAttribute.block.code,
  QlzbToolbarAction.quote: QDocAttribute.block.quote,
  QlzbToolbarAction.horizontalRule: QDocAttribute.embed.horizontalRule,
};

/// Allows customizing appearance of [QlzbToolbar].
abstract class QlzbToolbarDelegate {
  /// Builds toolbar button for specified [action].
  ///
  /// Returned widget is usually an instance of [QlzbButton].
  Widget buildButton(BuildContext context, QlzbToolbarAction action,
      {VoidCallback onPressed});
}

/// Scaffold for [QlzbToolbar].
class QlzbToolbarScaffold extends StatelessWidget {
  const QlzbToolbarScaffold({
    Key key,
    @required this.body,
    this.trailing,
    this.autoImplyTrailing = true,
  }) : super(key: key);

  final Widget body;
  final Widget trailing;
  final bool autoImplyTrailing;

  @override
  Widget build(BuildContext context) {
    final theme = QlzbTheme.of(context).toolbarTheme;
    final toolbar = QlzbToolbar.of(context);
    final constraints =
        BoxConstraints.tightFor(height: QlzbToolbar.kToolbarHeight);
    final children = <Widget>[
      Expanded(child: body),
    ];

    if (trailing != null) {
      children.add(trailing);
    } else if (autoImplyTrailing) {
      children.add(toolbar.buildButton(context, QlzbToolbarAction.close));
    }
    return Container(
      constraints: constraints,
      child: Material(color: theme.color, child: Row(children: children)),
    );
  }
}

/// Toolbar for [QlzbEditor].
class QlzbToolbar extends StatefulWidget implements PreferredSizeWidget {
  static const kToolbarHeight = 50.0;

  const QlzbToolbar({
    Key key,
    @required this.editor,
    this.autoHide = true,
    this.delegate,
  }) : super(key: key);

  final QlzbToolbarDelegate delegate;
  final QlzbScope editor;

  /// Whether to automatically hide this toolbar when editor loses focus.
  final bool autoHide;

  static QlzbToolbarState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_QlzbToolbarScope>();
    return scope?.toolbar;
  }

  @override
  QlzbToolbarState createState() => QlzbToolbarState();

  @override
  ui.Size get preferredSize => Size.fromHeight(QlzbToolbar.kToolbarHeight);
}

class _QlzbToolbarScope extends InheritedWidget {
  _QlzbToolbarScope({Key key, @required Widget child, @required this.toolbar})
      : super(key: key, child: child);

  final QlzbToolbarState toolbar;

  @override
  bool updateShouldNotify(_QlzbToolbarScope oldWidget) {
    return toolbar != oldWidget.toolbar;
  }
}

class QlzbToolbarState extends State<QlzbToolbar>
    with SingleTickerProviderStateMixin {
  final Key _toolbarKey = UniqueKey();
  final Key _overlayKey = UniqueKey();

  QlzbToolbarDelegate _delegate;
  AnimationController _overlayAnimation;
  WidgetBuilder _overlayBuilder;
  Completer<void> _overlayCompleter;

  TextSelection _selection;

  void markNeedsRebuild() {
    setState(() {
      if (_selection != editor.selection) {
        _selection = editor.selection;
        closeOverlay();
      }
    });
  }

  Widget buildButton(BuildContext context, QlzbToolbarAction action,
      {VoidCallback onPressed}) {
    return _delegate.buildButton(context, action, onPressed: onPressed);
  }

  Future<void> showOverlay(WidgetBuilder builder) async {
    assert(_overlayBuilder == null);
    final completer = Completer<void>();
    setState(() {
      _overlayBuilder = builder;
      _overlayCompleter = completer;
      _overlayAnimation.forward();
    });
    return completer.future;
  }

  void closeOverlay() {
    if (!hasOverlay) return;
    _overlayAnimation.reverse().whenComplete(() {
      setState(() {
        _overlayBuilder = null;
        _overlayCompleter?.complete();
        _overlayCompleter = null;
      });
    });
  }

  bool get hasOverlay => _overlayBuilder != null;

  QlzbScope get editor => widget.editor;

  @override
  void initState() {
    super.initState();
    _delegate = widget.delegate ?? _DefaultQlzbToolbarDelegate();
    _overlayAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    _selection = editor.selection;
  }

  @override
  void didUpdateWidget(QlzbToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delegate != oldWidget.delegate) {
      _delegate = widget.delegate ?? _DefaultQlzbToolbarDelegate();
    }
  }

  @override
  void dispose() {
    _overlayAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layers = <Widget>[];

    // Must set unique key for the toolbar to prevent it from reconstructing
    // new state each time we toggle overlay.
    final toolbar = QlzbToolbarScaffold(
      key: _toolbarKey,
      body: QlzbButtonList(buttons: _buildButtons(context)),
      trailing: buildButton(context, QlzbToolbarAction.hideKeyboard),
    );

    layers.add(toolbar);

    if (hasOverlay) {
      Widget widget = Builder(builder: _overlayBuilder);
      assert(widget != null);
      final overlay = FadeTransition(
        key: _overlayKey,
        opacity: _overlayAnimation,
        child: widget,
      );
      layers.add(overlay);
    }

    final constraints =
        BoxConstraints.tightFor(height: QlzbToolbar.kToolbarHeight);
    return _QlzbToolbarScope(
      toolbar: this,
      child: Container(
        constraints: constraints,
        child: Stack(children: layers),
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    final buttons = <Widget>[
      buildButton(context, QlzbToolbarAction.bold),
      buildButton(context, QlzbToolbarAction.italic),
      ColorButton(),
      FontButton(),
      LinkButton(),
      HeadingButton(),
      buildButton(context, QlzbToolbarAction.bulletList),
      buildButton(context, QlzbToolbarAction.numberList),
      buildButton(context, QlzbToolbarAction.quote),
      buildButton(context, QlzbToolbarAction.code),
      buildButton(context, QlzbToolbarAction.horizontalRule),
      if (editor.imageDelegate != null) ImageButton(),
    ];
    return buttons;
  }
}

/// Scrollable list of toolbar buttons.
class QlzbButtonList extends StatefulWidget {
  const QlzbButtonList({Key key, @required this.buttons}) : super(key: key);
  final List<Widget> buttons;

  @override
  _QlzbButtonListState createState() => _QlzbButtonListState();
}

class _QlzbButtonListState extends State<QlzbButtonList> {
  final ScrollController _controller = ScrollController();
  bool _showLeftArrow = false;
  bool _showRightArrow = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
    // Workaround to allow scroll controller attach to our ListView so that
    // we can detect if overflow arrows need to be shown on init.
    // TODO: find a better way to detect overflow
    Timer.run(_handleScroll);
  }

  @override
  Widget build(BuildContext context) {
    final theme = QlzbTheme.of(context).toolbarTheme;
    final color = theme.iconColor;
    final list = ListView(
      scrollDirection: Axis.horizontal,
      controller: _controller,
      children: widget.buttons,
      physics: ClampingScrollPhysics(),
    );

    final leftArrow = _showLeftArrow
        ? Icon(Icons.arrow_left, size: 18.0, color: color)
        : null;
    final rightArrow = _showRightArrow
        ? Icon(Icons.arrow_right, size: 18.0, color: color)
        : null;
    return Row(
      children: <Widget>[
        SizedBox(
          width: 12.0,
          height: QlzbToolbar.kToolbarHeight,
          child: Container(child: leftArrow, color: theme.color),
        ),
        Expanded(child: ClipRect(child: list)),
        SizedBox(
          width: 12.0,
          height: QlzbToolbar.kToolbarHeight,
          child: Container(child: rightArrow, color: theme.color),
        ),
      ],
    );
  }

  void _handleScroll() {
    setState(() {
      _showLeftArrow =
          _controller.position.minScrollExtent != _controller.position.pixels;
      _showRightArrow =
          _controller.position.maxScrollExtent != _controller.position.pixels;
    });
  }
}

class _DefaultQlzbToolbarDelegate implements QlzbToolbarDelegate {
  static const kDefaultButtonIcons = {
    QlzbToolbarAction.bold: Icons.format_bold,
    QlzbToolbarAction.italic: Icons.format_italic,
    QlzbToolbarAction.link: Icons.link,
    QlzbToolbarAction.unlink: Icons.link_off,
    QlzbToolbarAction.clipboardCopy: Icons.content_copy,
    QlzbToolbarAction.openInBrowser: Icons.open_in_new,
    QlzbToolbarAction.heading: Icons.format_size,
    QlzbToolbarAction.bulletList: Icons.format_list_bulleted,
    QlzbToolbarAction.numberList: Icons.format_list_numbered,
    QlzbToolbarAction.code: Icons.code,
    QlzbToolbarAction.quote: Icons.format_quote,
    QlzbToolbarAction.horizontalRule: Icons.remove,
    QlzbToolbarAction.image: Icons.photo,
    QlzbToolbarAction.cameraImage: Icons.photo_camera,
    QlzbToolbarAction.galleryImage: Icons.photo_library,
    QlzbToolbarAction.hideKeyboard: Icons.keyboard_hide,
    QlzbToolbarAction.close: Icons.close,
    QlzbToolbarAction.confirm: Icons.check,
    QlzbToolbarAction.color: Icons.color_lens,
    QlzbToolbarAction.font: Icons.font_download,
  };

  static const kSpecialIconSizes = {
    QlzbToolbarAction.unlink: 20.0,
    QlzbToolbarAction.clipboardCopy: 20.0,
    QlzbToolbarAction.openInBrowser: 20.0,
    QlzbToolbarAction.close: 20.0,
    QlzbToolbarAction.confirm: 20.0,
  };

  static const kDefaultButtonTexts = {
    QlzbToolbarAction.headingLevel1: 'H1',
    QlzbToolbarAction.headingLevel2: 'H2',
    QlzbToolbarAction.headingLevel3: 'H3',
  };

  static const List<QlzbToolbarAction> colorButtons = [
    QlzbToolbarAction.color1,
    QlzbToolbarAction.color2,
    QlzbToolbarAction.color3,
    QlzbToolbarAction.color4,
    QlzbToolbarAction.color5,
    QlzbToolbarAction.color6,
    QlzbToolbarAction.color7,
    QlzbToolbarAction.color8,
    QlzbToolbarAction.color9,
    QlzbToolbarAction.color10,
    QlzbToolbarAction.color11,
    QlzbToolbarAction.color12,
    QlzbToolbarAction.mainColor,
  ];
  static const List<QlzbToolbarAction> fontButtons = [
    QlzbToolbarAction.font1,
    QlzbToolbarAction.font2,
    QlzbToolbarAction.font3,
    QlzbToolbarAction.font4,
    QlzbToolbarAction.font5,
    QlzbToolbarAction.font6,
    QlzbToolbarAction.font7,
    QlzbToolbarAction.font8,
    QlzbToolbarAction.mainFont,
  ];

  @override
  Widget buildButton(BuildContext context, QlzbToolbarAction action,
      {VoidCallback onPressed}) {
    final theme = Theme.of(context);
    final atr = QlzbTheme.of(context).attributeTheme;
    if (colorButtons.contains(action)) {
      Color color;
      if (action == QlzbToolbarAction.color1) {
        color = atr.colorTheme.color1;
      }
      if (action == QlzbToolbarAction.color2) {
        color = atr.colorTheme.color2;
      }
      if (action == QlzbToolbarAction.color3) {
        color = atr.colorTheme.color3;
      }
      if (action == QlzbToolbarAction.color4) {
        color = atr.colorTheme.color4;
      }
      if (action == QlzbToolbarAction.color5) {
        color = atr.colorTheme.color5;
      }
      if (action == QlzbToolbarAction.color6) {
        color = atr.colorTheme.color6;
      }
      if (action == QlzbToolbarAction.color7) {
        color = atr.colorTheme.color7;
      }
      if (action == QlzbToolbarAction.color8) {
        color = atr.colorTheme.color8;
      }
      if (action == QlzbToolbarAction.color9) {
        color = atr.colorTheme.color9;
      }
      if (action == QlzbToolbarAction.color10) {
        color = atr.colorTheme.color10;
      }
      if (action == QlzbToolbarAction.color11) {
        color = atr.colorTheme.color11;
      }
      if (action == QlzbToolbarAction.color12) {
        color = atr.colorTheme.color12;
      }
      if (action == QlzbToolbarAction.mainColor) {
        color = atr.colorTheme.mainColor;
      }
      return QlzbButton.color(
        action: action,
        color: color,
        onPressed: onPressed,
      );
    }
    if (fontButtons.contains(action)) {
      String font;
      if (action == QlzbToolbarAction.font1) {
        font = atr.fontTheme.font1;
      }
      if (action == QlzbToolbarAction.font2) {
        font = atr.fontTheme.font2;
      }
      if (action == QlzbToolbarAction.font3) {
        font = atr.fontTheme.font3;
      }
      if (action == QlzbToolbarAction.font4) {
        font = atr.fontTheme.font4;
      }
      if (action == QlzbToolbarAction.font5) {
        font = atr.fontTheme.font5;
      }
      if (action == QlzbToolbarAction.font6) {
        font = atr.fontTheme.font6;
      }
      if (action == QlzbToolbarAction.font7) {
        font = atr.fontTheme.font7;
      }
      if (action == QlzbToolbarAction.font8) {
        font = atr.fontTheme.font8;
      }
      if (action == QlzbToolbarAction.mainFont) {
        font = atr.fontTheme.mainFont;
      }
      return QlzbButton.font(
        action: action,
        font: font,
        onPressed: onPressed,
      );
    }
    if (kDefaultButtonIcons.containsKey(action)) {
      final icon = kDefaultButtonIcons[action];
      final size = kSpecialIconSizes[action];
      return QlzbButton.icon(
        action: action,
        icon: icon,
        iconSize: size,
        onPressed: onPressed,
      );
    } else {
      final text = kDefaultButtonTexts[action];
      assert(text != null);
      final style = theme.textTheme.caption
          .copyWith(fontWeight: FontWeight.bold, fontSize: 14.0);
      return QlzbButton.text(
        action: action,
        text: text,
        style: style,
        onPressed: onPressed,
      );
    }
  }
}
