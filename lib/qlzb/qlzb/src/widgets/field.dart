import 'package:flutter/material.dart';

import 'controller.dart';
import 'editor.dart';
import 'image.dart';
import 'mode.dart';
import 'toolbar.dart';

/// Qlzb editor with material design decorations.
class QlzbField extends StatefulWidget {
  /// Decoration to paint around this editor.
  final InputDecoration decoration;

  /// Height of this editor field.
  final double height;
  final QlzbController controller;
  final FocusNode focusNode;
  final bool autofocus;
  final QlzbMode mode;
  final QlzbToolbarDelegate toolbarDelegate;
  final QlzbImageDelegate imageDelegate;
  final ScrollPhysics physics;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to the brightness of [ThemeData.primaryColorBrightness].
  final Brightness keyboardAppearance;

  const QlzbField({
    Key key,
    this.decoration,
    this.height,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.mode,
    this.toolbarDelegate,
    this.imageDelegate,
    this.physics,
    this.keyboardAppearance,
  }) : super(key: key);

  @override
  _QlzbFieldState createState() => _QlzbFieldState();
}

class _QlzbFieldState extends State<QlzbField> {
  QlzbMode get _effectiveMode => widget.mode ?? QlzbMode.edit;
  @override
  Widget build(BuildContext context) {
    Widget child = QlzbEditor(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      mode: _effectiveMode,
      toolbarDelegate: widget.toolbarDelegate,
      imageDelegate: widget.imageDelegate,
      physics: widget.physics,
      keyboardAppearance: widget.keyboardAppearance,
    );

    if (widget.height != null) {
      child = ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: widget.height),
        child: child,
      );
    }

    return AnimatedBuilder(
      animation:
          Listenable.merge(<Listenable>[widget.focusNode, widget.controller]),
      builder: (BuildContext context, Widget child) {
        return InputDecorator(
          decoration: _getEffectiveDecoration(),
          isFocused: widget.focusNode.hasFocus,
          isEmpty: widget.controller.document.length == 1,
          child: child,
        );
      },
      child: child,
    );
  }

  InputDecoration _getEffectiveDecoration() {
    final effectiveDecoration = (widget.decoration ?? const InputDecoration())
        .applyDefaults(Theme.of(context).inputDecorationTheme)
        .copyWith(
          enabled: _effectiveMode == QlzbMode.edit,
        );

    return effectiveDecoration;
  }
}
