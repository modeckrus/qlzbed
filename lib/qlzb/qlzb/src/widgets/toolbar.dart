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

  @override
  Widget buildButton(BuildContext context, QlzbToolbarAction action,
      {VoidCallback onPressed}) {
    final theme = Theme.of(context);
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
