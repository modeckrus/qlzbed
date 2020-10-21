// Copyright (c) 2018, the Qlzb project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../qlzb.dart';
import 'scope.dart';
import 'theme.dart';
import 'toolbar.dart';

/// A button used in [QlzbToolbar].
///
/// Create an instance of this widget with [QlzbButton.icon] or
/// [QlzbButton.text] constructors.
///
/// Toolbar buttons are normally created by a [QlzbToolbarDelegate].
class QlzbButton extends StatelessWidget {
  /// Creates a toolbar button with an icon.
  QlzbButton.icon({
    @required this.action,
    @required IconData icon,
    double iconSize,
    this.onPressed,
  })  : assert(action != null),
        assert(icon != null),
        _icon = icon,
        _iconSize = iconSize,
        _text = null,
        _textStyle = null,
        super();

  /// Creates a toolbar button containing text.
  ///
  /// Note that [QlzbButton] has fixed width and does not expand to accommodate
  /// long texts.
  QlzbButton.text({
    @required this.action,
    @required String text,
    TextStyle style,
    this.onPressed,
  })  : assert(action != null),
        assert(text != null),
        _icon = null,
        _iconSize = null,
        _text = text,
        _textStyle = style,
        super();

  /// Toolbar action associated with this button.
  final QlzbToolbarAction action;
  final IconData _icon;
  final double _iconSize;
  final String _text;
  final TextStyle _textStyle;

  /// Callback to trigger when this button is tapped.
  final VoidCallback onPressed;

  bool get isAttributeAction {
    return kQlzbToolbarAttributeActions.keys.contains(action);
  }

  @override
  Widget build(BuildContext context) {
    final toolbar = QlzbToolbar.of(context);
    final editor = toolbar.editor;
    final toolbarTheme = QlzbTheme.of(context).toolbarTheme;
    final pressedHandler = _getPressedHandler(editor, toolbar);
    final iconColor = (pressedHandler == null)
        ? toolbarTheme.disabledIconColor
        : toolbarTheme.iconColor;
    if (_icon != null) {
      return RawQlzbButton.icon(
        action: action,
        icon: _icon,
        size: _iconSize,
        iconColor: iconColor,
        color: _getColor(editor, toolbarTheme),
        onPressed: _getPressedHandler(editor, toolbar),
      );
    } else {
      assert(_text != null);
      var style = _textStyle ?? TextStyle();
      style = style.copyWith(color: iconColor);
      return RawQlzbButton(
        action: action,
        child: Text(_text, style: style),
        color: _getColor(editor, toolbarTheme),
        onPressed: _getPressedHandler(editor, toolbar),
      );
    }
  }

  Color _getColor(QlzbScope editor, ToolbarTheme theme) {
    if (isAttributeAction) {
      final attribute = kQlzbToolbarAttributeActions[action];
      final isToggled = (attribute is QDocAttribute)
          ? editor.selectionStyle.containsSame(attribute)
          : editor.selectionStyle.contains(attribute);
      return isToggled ? theme.toggleColor : null;
    }
    return null;
  }

  VoidCallback _getPressedHandler(QlzbScope editor, QlzbToolbarState toolbar) {
    if (onPressed != null) {
      return onPressed;
    } else if (isAttributeAction) {
      final attribute = kQlzbToolbarAttributeActions[action];
      if (attribute is QDocAttribute) {
        return () => _toggleAttribute(attribute, editor);
      }
    } else if (action == QlzbToolbarAction.close) {
      return () => toolbar.closeOverlay();
    } else if (action == QlzbToolbarAction.hideKeyboard) {
      return () => editor.hideKeyboard();
    }

    return null;
  }

  void _toggleAttribute(QDocAttribute attribute, QlzbScope editor) {
    final isToggled = editor.selectionStyle.containsSame(attribute);
    if (isToggled) {
      editor.formatSelection(attribute.unset);
    } else {
      editor.formatSelection(attribute);
    }
  }
}

/// Raw button widget used by [QlzbToolbar].
///
/// See also:
///
///   * [QlzbButton], which wraps this widget and implements most of the
///     action-specific logic.
class RawQlzbButton extends StatelessWidget {
  const RawQlzbButton({
    Key key,
    @required this.action,
    @required this.child,
    @required this.color,
    @required this.onPressed,
  }) : super(key: key);

  /// Creates a [RawQlzbButton] containing an icon.
  RawQlzbButton.icon({
    @required this.action,
    @required IconData icon,
    double size,
    Color iconColor,
    @required this.color,
    @required this.onPressed,
  })  : child = Icon(icon, size: size, color: iconColor),
        super();

  /// Toolbar action associated with this button.
  final QlzbToolbarAction action;

  /// Child widget to show inside this button. Usually an icon.
  final Widget child;

  /// Background color of this button.
  final Color color;

  /// Callback to trigger when this button is pressed.
  final VoidCallback onPressed;

  /// Returns `true` if this button is currently toggled on.
  bool get isToggled => color != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = theme.buttonTheme.constraints.minHeight + 4.0;
    final constraints = theme.buttonTheme.constraints.copyWith(
        minWidth: width, maxHeight: theme.buttonTheme.constraints.minHeight);
    final radius = BorderRadius.all(Radius.circular(3.0));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 6.0),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(borderRadius: radius),
        elevation: 0.0,
        fillColor: color,
        constraints: constraints,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

/// Controls heading styles.
///
/// When pressed, this button displays overlay toolbar with three
/// buttons for each heading level.
class HeadingButton extends StatefulWidget {
  const HeadingButton({Key key}) : super(key: key);

  @override
  _HeadingButtonState createState() => _HeadingButtonState();
}

class _HeadingButtonState extends State<HeadingButton> {
  @override
  Widget build(BuildContext context) {
    final toolbar = QlzbToolbar.of(context);
    return toolbar.buildButton(
      context,
      QlzbToolbarAction.heading,
      onPressed: showOverlay,
    );
  }

  void showOverlay() {
    final toolbar = QlzbToolbar.of(context);
    toolbar.showOverlay(buildOverlay);
  }

  Widget buildOverlay(BuildContext context) {
    final toolbar = QlzbToolbar.of(context);
    final buttons = Row(
      children: <Widget>[
        SizedBox(width: 8.0),
        toolbar.buildButton(context, QlzbToolbarAction.headingLevel1),
        toolbar.buildButton(context, QlzbToolbarAction.headingLevel2),
        toolbar.buildButton(context, QlzbToolbarAction.headingLevel3),
      ],
    );
    return QlzbToolbarScaffold(body: buttons);
  }
}

/// Controls image attribute.
///
/// When pressed, this button displays overlay toolbar with three
/// buttons for each heading level.
class ImageButton extends StatefulWidget {
  const ImageButton({Key key}) : super(key: key);

  @override
  _ImageButtonState createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  @override
  Widget build(BuildContext context) {
    final toolbar = QlzbToolbar.of(context);
    return toolbar.buildButton(
      context,
      QlzbToolbarAction.image,
      onPressed: showOverlay,
    );
  }

  void showOverlay() {
    final toolbar = QlzbToolbar.of(context);
    toolbar.showOverlay(buildOverlay);
  }

  Widget buildOverlay(BuildContext context) {
    final toolbar = QlzbToolbar.of(context);
    final buttons = Row(
      children: <Widget>[
        SizedBox(width: 8.0),
        toolbar.buildButton(context, QlzbToolbarAction.cameraImage,
            onPressed: _pickFromCamera),
        toolbar.buildButton(context, QlzbToolbarAction.galleryImage,
            onPressed: _pickFromGallery),
      ],
    );
    return QlzbToolbarScaffold(body: buttons);
  }

  void _pickFromCamera() async {
    final editor = QlzbToolbar.of(context).editor;
    final image =
        await editor.imageDelegate.pickImage(editor.imageDelegate.cameraSource);
    if (image != null) {
      editor.formatSelection(QDocAttribute.embed.image(image));
    }
  }

  void _pickFromGallery() async {
    final editor = QlzbToolbar.of(context).editor;
    final image = await editor.imageDelegate
        .pickImage(editor.imageDelegate.gallerySource);
    if (image != null) {
      editor.formatSelection(QDocAttribute.embed.image(image));
    }
  }
}

class LinkButton extends StatefulWidget {
  const LinkButton({Key key}) : super(key: key);

  @override
  _LinkButtonState createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> {
  final TextEditingController _inputController = TextEditingController();
  Key _inputKey;
  bool _formatError = false;

  bool get isEditing => _inputKey != null;

  @override
  Widget build(BuildContext context) {
    final toolbar = QlzbToolbar.of(context);
    final editor = toolbar.editor;
    final enabled =
        hasLink(editor.selectionStyle) || !editor.selection.isCollapsed;

    return toolbar.buildButton(
      context,
      QlzbToolbarAction.link,
      onPressed: enabled ? showOverlay : null,
    );
  }

  bool hasLink(QDocStyle style) => style.contains(QDocAttribute.link);

  String getLink([String defaultValue]) {
    final editor = QlzbToolbar.of(context).editor;
    final attrs = editor.selectionStyle;
    if (hasLink(attrs)) {
      return attrs.value(QDocAttribute.link);
    }
    return defaultValue;
  }

  void showOverlay() {
    final toolbar = QlzbToolbar.of(context);
    toolbar.showOverlay(buildOverlay).whenComplete(cancelEdit);
  }

  void closeOverlay() {
    final toolbar = QlzbToolbar.of(context);
    toolbar.closeOverlay();
  }

  void edit() {
    final toolbar = QlzbToolbar.of(context);
    setState(() {
      _inputKey = UniqueKey();
      _inputController.text = getLink('https://');
      _inputController.addListener(_handleInputChange);
      toolbar.markNeedsRebuild();
    });
  }

  void doneEdit() {
    final toolbar = QlzbToolbar.of(context);
    setState(() {
      var error = false;
      if (_inputController.text.isNotEmpty) {
        try {
          var uri = Uri.parse(_inputController.text);
          if ((uri.isScheme('https') || uri.isScheme('http')) &&
              uri.host.isNotEmpty) {
            toolbar.editor.formatSelection(
                QDocAttribute.link.fromString(_inputController.text));
          } else {
            error = true;
          }
        } on FormatException {
          error = true;
        }
      }
      if (error) {
        _formatError = error;
        toolbar.markNeedsRebuild();
      } else {
        _inputKey = null;
        _inputController.text = '';
        _inputController.removeListener(_handleInputChange);
        toolbar.markNeedsRebuild();
        toolbar.editor.focus();
      }
    });
  }

  void cancelEdit() {
    if (mounted) {
      final editor = QlzbToolbar.of(context).editor;
      setState(() {
        _inputKey = null;
        _inputController.text = '';
        _inputController.removeListener(_handleInputChange);
        editor.focus();
      });
    }
  }

  void unlink() {
    final editor = QlzbToolbar.of(context).editor;
    editor.formatSelection(QDocAttribute.link.unset);
    closeOverlay();
  }

  void copyToClipboard() {
    var link = getLink();
    assert(link != null);
    Clipboard.setData(ClipboardData(text: link));
  }

  void openInBrowser() async {
    final editor = QlzbToolbar.of(context).editor;
    var link = getLink();
    assert(link != null);
    if (await canLaunch(link)) {
      editor.hideKeyboard();
      await launch(link, forceWebView: true);
    }
  }

  void _handleInputChange() {
    final toolbar = QlzbToolbar.of(context);
    setState(() {
      _formatError = false;
      toolbar.markNeedsRebuild();
    });
  }

  Widget buildOverlay(BuildContext context) {
    final toolbar = QlzbToolbar.of(context);
    final style = toolbar.editor.selectionStyle;

    var value = 'Tap to edit link';
    if (style.contains(QDocAttribute.link)) {
      value = style.value(QDocAttribute.link);
    }
    final clipboardEnabled = value != 'Tap to edit link';
    final body = !isEditing
        ? _LinkView(value: value, onTap: edit)
        : _LinkInput(
            key: _inputKey,
            controller: _inputController,
            formatError: _formatError,
          );
    final items = <Widget>[Expanded(child: body)];
    if (!isEditing) {
      final unlinkHandler = hasLink(style) ? unlink : null;
      final copyHandler = clipboardEnabled ? copyToClipboard : null;
      final openHandler = hasLink(style) ? openInBrowser : null;
      final buttons = <Widget>[
        toolbar.buildButton(context, QlzbToolbarAction.unlink,
            onPressed: unlinkHandler),
        toolbar.buildButton(context, QlzbToolbarAction.clipboardCopy,
            onPressed: copyHandler),
        toolbar.buildButton(
          context,
          QlzbToolbarAction.openInBrowser,
          onPressed: openHandler,
        ),
      ];
      items.addAll(buttons);
    }
    final trailingPressed = isEditing ? doneEdit : closeOverlay;
    final trailingAction =
        isEditing ? QlzbToolbarAction.confirm : QlzbToolbarAction.close;

    return QlzbToolbarScaffold(
      body: Row(children: items),
      trailing: toolbar.buildButton(
        context,
        trailingAction,
        onPressed: trailingPressed,
      ),
    );
  }
}

class _LinkInput extends StatefulWidget {
  final TextEditingController controller;
  final bool formatError;

  const _LinkInput(
      {Key key, @required this.controller, this.formatError = false})
      : super(key: key);

  @override
  _LinkInputState createState() {
    return _LinkInputState();
  }
}

class _LinkInputState extends State<_LinkInput> {
  final FocusNode _focusNode = FocusNode();

  QlzbScope _editor;
  bool _didAutoFocus = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didAutoFocus) {
      FocusScope.of(context).requestFocus(_focusNode);
      _didAutoFocus = true;
    }

    final toolbar = QlzbToolbar.of(context);

    if (_editor != toolbar.editor) {
      _editor?.toolbarFocusNode = null;
      _editor = toolbar.editor;
      _editor.toolbarFocusNode = _focusNode;
    }
  }

  @override
  void dispose() {
    _editor?.toolbarFocusNode = null;
    _focusNode.dispose();
    _editor = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final toolbarTheme = QlzbTheme.of(context).toolbarTheme;
    final color =
        widget.formatError ? Colors.redAccent : toolbarTheme.iconColor;
    final style = theme.textTheme.subtitle1.copyWith(color: color);
    return TextField(
      style: style,
      keyboardType: TextInputType.url,
      focusNode: _focusNode,
      controller: widget.controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'https://',
        filled: true,
        fillColor: toolbarTheme.color,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(10.0),
      ),
    );
  }
}

class _LinkView extends StatelessWidget {
  const _LinkView({Key key, @required this.value, this.onTap})
      : super(key: key);
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final toolbarTheme = QlzbTheme.of(context).toolbarTheme;
    Widget widget = ClipRect(
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            alignment: AlignmentDirectional.centerStart,
            constraints: BoxConstraints(minHeight: QlzbToolbar.kToolbarHeight),
            padding: const EdgeInsets.all(10.0),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.subtitle1
                  .copyWith(color: toolbarTheme.disabledIconColor),
            ),
          )
        ],
      ),
    );
    if (onTap != null) {
      widget = GestureDetector(
        child: widget,
        onTap: onTap,
      );
    }
    return widget;
  }
}
