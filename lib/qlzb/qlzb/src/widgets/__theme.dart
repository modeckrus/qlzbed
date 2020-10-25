// Copyright (c) 2018, the Qlzb project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Applies a Qlzb editor theme to descendant widgets.
///
/// Describes colors and typographic styles for an editor.
///
/// Descendant widgets obtain the current theme's [QlzbThemeData] object using
/// [QlzbTheme.of].
///
/// See also:
///
///   * [QlzbThemeData], which describes actual configuration of a theme.
class QlzbTheme extends InheritedWidget {
  final QlzbThemeData data;

  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  QlzbTheme({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(data != null),
        assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(QlzbTheme oldWidget) {
    return data != oldWidget.data;
  }

  /// The data from the closest [QlzbTheme] instance that encloses the given
  /// context.
  ///
  /// Returns `null` if there is no [QlzbTheme] in the given build context
  /// and [nullOk] is set to `true`. If [nullOk] is set to `false` (default)
  /// then this method asserts.
  static QlzbThemeData of(BuildContext context, {bool nullOk = false}) {
    final widget = context.dependOnInheritedWidgetOfExactType<QlzbTheme>();
    if (widget == null && nullOk) return null;
    assert(widget != null,
        '$QlzbTheme.of() called with a context that does not contain a QlzbEditor.');
    return widget.data;
  }
}

/// Holds colors and typography styles for [QlzbEditor].
class QlzbThemeData {
  final TextStyle boldStyle;
  final TextStyle italicStyle;
  final TextStyle linkStyle;
  final StyleTheme paragraphTheme;
  final HeadingTheme headingTheme;
  final FontTheme fontTheme;
  final ColorTheme colorTheme;
  final BlockTheme blockTheme;
  final Color selectionColor;
  final Color cursorColor;

  /// Size of indentation for blocks.
  final double indentSize;
  final QlzbToolbarTheme toolbarTheme;

  factory QlzbThemeData.fallback(BuildContext context) {
    final themeData = Theme.of(context);
    final defaultStyle = DefaultTextStyle.of(context);
    final paragraphStyle = defaultStyle.style.copyWith(
      fontSize: 16.0,
      height: 1.3,
    );
    const padding = EdgeInsets.symmetric(vertical: 8.0);
    final boldStyle = TextStyle(fontWeight: FontWeight.bold);
    final italicStyle = TextStyle(fontStyle: FontStyle.italic);
    final linkStyle = TextStyle(
        color: themeData.accentColor, decoration: TextDecoration.underline);

    return QlzbThemeData(
      boldStyle: boldStyle,
      italicStyle: italicStyle,
      linkStyle: linkStyle,
      paragraphTheme: StyleTheme(textStyle: paragraphStyle, padding: padding),
      headingTheme: HeadingTheme.fallback(context),
      blockTheme: BlockTheme.fallback(context),
      selectionColor: themeData.textSelectionColor,
      cursorColor: themeData.cursorColor,
      indentSize: 16.0,
      toolbarTheme: QlzbToolbarTheme.fallback(context),
      fontTheme: FontTheme.fallback(context),
      colorTheme: ColorTheme.fallback(context),
    );
  }

  const QlzbThemeData(
      {this.boldStyle,
      this.italicStyle,
      this.linkStyle,
      this.paragraphTheme,
      this.headingTheme,
      this.blockTheme,
      this.selectionColor,
      this.cursorColor,
      this.indentSize,
      this.toolbarTheme,
      this.colorTheme,
      this.fontTheme});

  QlzbThemeData copyWith({
    TextStyle textStyle,
    TextStyle boldStyle,
    TextStyle italicStyle,
    TextStyle linkStyle,
    StyleTheme paragraphTheme,
    HeadingTheme headingTheme,
    BlockTheme blockTheme,
    Color selectionColor,
    Color cursorColor,
    double indentSize,
    QlzbToolbarTheme toolbarTheme,
    FontTheme fontTheme,
    ColorTheme colorTheme,
  }) {
    return QlzbThemeData(
        boldStyle: boldStyle ?? this.boldStyle,
        italicStyle: italicStyle ?? this.italicStyle,
        linkStyle: linkStyle ?? this.linkStyle,
        paragraphTheme: paragraphTheme ?? this.paragraphTheme,
        headingTheme: headingTheme ?? this.headingTheme,
        blockTheme: blockTheme ?? this.blockTheme,
        selectionColor: selectionColor ?? this.selectionColor,
        cursorColor: cursorColor ?? this.cursorColor,
        indentSize: indentSize ?? this.indentSize,
        toolbarTheme: toolbarTheme ?? this.toolbarTheme,
        colorTheme: colorTheme ?? this.colorTheme,
        fontTheme: fontTheme ?? this.fontTheme);
  }

  QlzbThemeData merge(QlzbThemeData other) {
    return copyWith(
        boldStyle: other.boldStyle,
        italicStyle: other.italicStyle,
        linkStyle: other.linkStyle,
        paragraphTheme: other.paragraphTheme,
        headingTheme: other.headingTheme,
        blockTheme: other.blockTheme,
        selectionColor: other.selectionColor,
        cursorColor: other.cursorColor,
        indentSize: other.indentSize,
        toolbarTheme: other.toolbarTheme,
        colorTheme: other.colorTheme,
        fontTheme: other.fontTheme);
  }
}

/// Theme for heading-styled lines of text.
class HeadingTheme {
  /// Style theme for level 1 headings.
  final StyleTheme level1;

  /// Style theme for level 2 headings.
  final StyleTheme level2;

  /// Style theme for level 3 headings.
  final StyleTheme level3;

  HeadingTheme({
    @required this.level1,
    @required this.level2,
    @required this.level3,
  });

  /// Creates fallback theme for headings.
  factory HeadingTheme.fallback(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context);
    return HeadingTheme(
      level1: StyleTheme(
        textStyle: defaultStyle.style.copyWith(
          fontSize: 34.0,
          color: defaultStyle.style.color.withOpacity(0.70),
          height: 1.15,
          fontWeight: FontWeight.w300,
        ),
        padding: EdgeInsets.only(top: 16.0, bottom: 0.0),
      ),
      level2: StyleTheme(
        textStyle: TextStyle(
          fontSize: 24.0,
          color: defaultStyle.style.color.withOpacity(0.70),
          height: 1.15,
          fontWeight: FontWeight.normal,
        ),
        padding: EdgeInsets.only(bottom: 0.0, top: 8.0),
      ),
      level3: StyleTheme(
        textStyle: TextStyle(
          fontSize: 20.0,
          color: defaultStyle.style.color.withOpacity(0.70),
          height: 1.25,
          fontWeight: FontWeight.w500,
        ),
        padding: EdgeInsets.only(bottom: 0.0, top: 8.0),
      ),
    );
  }
}

/// Theme for heading-styled lines of text.
class FontTheme {
  /// Style theme for level 1 headings.
  final String font1;

  /// Style theme for level 2 headings.
  final String font2;

  /// Style theme for level 3 headings.
  final String font3;

  final String font4;
  final String font5;
  final String font6;
  final String font7;
  final String font8;
  final String mainFont;

  FontTheme(
      {@required this.font1,
      @required this.font2,
      @required this.font3,
      @required this.font4,
      @required this.font5,
      @required this.font6,
      @required this.font7,
      @required this.font8,
      @required this.mainFont});

  /// Creates fallback theme for headings.
  factory FontTheme.fallback(BuildContext context) {
    // final defaultStyle = DefaultTextStyle.of(context);
    return FontTheme(
      font1: 'Chrysanthi',
      font2: 'Cupola',
      font3: 'Lora',
      font4: 'Jura',
      font5: 'Oswald',
      font6: 'Raleway',
      font7: 'RobotoMono',
      font8: 'SansForgetica',
      mainFont: 'Arial',
    );
  }
  FontTheme merge(FontTheme other) {
    return copyWith(other);
  }

  FontTheme copyWith(FontTheme other) {
    return FontTheme(
        font1: other.font1 ?? font1,
        font2: other.font2 ?? font2,
        font3: other.font3 ?? font3,
        font4: other.font4 ?? font4,
        font5: other.font5 ?? font5,
        font6: other.font6 ?? font6,
        font7: other.font7 ?? font7,
        font8: other.font8 ?? font8,
        mainFont: other.mainFont ?? mainFont);
  }

  @override
  bool operator ==(other) {
    if (other.runtimeType != runtimeType) return false;
    final FontTheme otherTheme = other;
    return (otherTheme.font1 == font1) &&
        (otherTheme.font2 == font2) &&
        (otherTheme.font3 == font3) &&
        (otherTheme.font4 == font4) &&
        (otherTheme.font5 == font5) &&
        (otherTheme.font6 == font6) &&
        (otherTheme.font7 == font7) &&
        (otherTheme.font8 == font8) &&
        (otherTheme.mainFont == mainFont);
  }

  @override
  int get hashCode => hashValues(
      font1, font2, font3, font4, font5, font6, font7, font8, mainFont);
}

class ColorTheme {
  /// Style theme for level 1 headings.
  final Color color1;

  /// Style theme for level 2 headings.
  final Color color2;

  /// Style theme for level 3 headings.
  final Color color3;

  final Color color4;
  final Color color5;
  final Color color6;
  final Color color7;
  final Color color8;
  final Color color9;
  final Color color10;
  final Color color11;
  final Color color12;
  final Color mainColor;

  ColorTheme(
      {@required this.color1,
      @required this.color2,
      @required this.color3,
      @required this.color4,
      @required this.color5,
      @required this.color6,
      @required this.color7,
      @required this.color8,
      @required this.color9,
      @required this.color10,
      @required this.color11,
      @required this.color12,
      @required this.mainColor});

  /// Creates fallback theme for headings.
  factory ColorTheme.fallback(BuildContext context) {
    final defaultStyle = DefaultTextStyle.of(context);
    return ColorTheme(
      color1: Colors.amber,
      color2: Colors.blue,
      color3: Colors.cyan,
      color4: Colors.deepPurple,
      color5: Colors.yellow,
      color6: Colors.purple,
      color7: Colors.pink,
      color8: Colors.teal,
      color9: Colors.lightBlue,
      color10: Colors.orange,
      color11: Colors.green,
      color12: Colors.lightGreen,
      mainColor: defaultStyle.style.color,
    );
  }

  ColorTheme merge(ColorTheme other) {
    return copyWith(other);
  }

  ColorTheme copyWith(ColorTheme other) {
    return ColorTheme(
        color1: other.color1 ?? color1,
        color2: other.color2 ?? color2,
        color3: other.color3 ?? color3,
        color4: other.color4 ?? color4,
        color5: other.color5 ?? color5,
        color6: other.color6 ?? color6,
        color7: other.color7 ?? color7,
        color8: other.color8 ?? color8,
        color9: other.color9 ?? color9,
        color10: other.color10 ?? color10,
        color11: other.color11 ?? color11,
        color12: other.color12 ?? color12,
        mainColor: other.mainColor ?? mainColor);
  }

  @override
  bool operator ==(other) {
    if (other.runtimeType != runtimeType) return false;
    final ColorTheme otherTheme = other;
    return (otherTheme.color1 == color1) &&
        (otherTheme.color2 == color2) &&
        (otherTheme.color3 == color3) &&
        (otherTheme.color4 == color4) &&
        (otherTheme.color5 == color5) &&
        (otherTheme.color6 == color6) &&
        (otherTheme.color7 == color7) &&
        (otherTheme.color8 == color8) &&
        (otherTheme.color9 == color9) &&
        (otherTheme.color10 == color10) &&
        (otherTheme.color11 == color11) &&
        (otherTheme.color12 == color12) &&
        (otherTheme.mainColor == mainColor);
  }

  @override
  int get hashCode => hashValues(color1, color2, color3, color4, color5, color6,
      color7, color8, color9, color10, color11, color12, mainColor);
}

/// Theme for a block of lines in a document.
class BlockTheme {
  /// Style theme for bullet lists.
  final StyleTheme bulletList;

  /// Style theme for number lists.
  final StyleTheme numberList;

  /// Style theme for code snippets.
  final StyleTheme code;

  /// Style theme for quotes.
  final StyleTheme quote;

  BlockTheme({
    @required this.bulletList,
    @required this.numberList,
    @required this.quote,
    @required this.code,
  });

  /// Creates fallback theme for blocks.
  factory BlockTheme.fallback(BuildContext context) {
    final themeData = Theme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context);
    final padding = const EdgeInsets.symmetric(vertical: 8.0);
    String fontFamily;
    switch (themeData.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        fontFamily = 'Menlo';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        fontFamily = 'Roboto Mono';
        break;
    }

    return BlockTheme(
      bulletList: StyleTheme(padding: padding),
      numberList: StyleTheme(padding: padding),
      quote: StyleTheme(
        textStyle: TextStyle(
          color: defaultTextStyle.style.color.withOpacity(0.6),
        ),
        padding: padding,
      ),
      code: StyleTheme(
        textStyle: TextStyle(
          color: defaultTextStyle.style.color.withOpacity(0.8),
          fontFamily: fontFamily,
          fontSize: 14.0,
          height: 1.25,
        ),
        padding: padding,
      ),
    );
  }
}

/// Theme for a specific attribute style.
///
/// Used in [HeadingTheme] and [BlockTheme], as well as in
/// [QlzbThemeData.paragraphTheme].
class StyleTheme {
  /// Text style of this theme.
  final TextStyle textStyle;

  /// Padding to apply around lines of text.
  final EdgeInsets padding;

  /// Creates a new [StyleTheme].
  StyleTheme({
    this.textStyle,
    this.padding,
  });
}

/// Defines styles and colors for [QlzbToolbar].
class QlzbToolbarTheme {
  /// The background color of toolbar.
  final Color color;

  /// Color of buttons in toggled state.
  final Color toggleColor;

  /// Color of button icons.
  final Color iconColor;

  /// Color of button icons in disabled state.
  final Color disabledIconColor;

  /// Creates fallback theme for editor toolbars.
  factory QlzbToolbarTheme.fallback(BuildContext context) {
    final theme = Theme.of(context);
    return QlzbToolbarTheme._(
      color: theme.primaryColorBrightness == Brightness.light
          ? Colors.grey.shade300
          : Colors.grey.shade800,
      toggleColor: theme.primaryColorBrightness == Brightness.light
          ? Colors.grey.shade400
          : Colors.grey.shade900,
      iconColor: theme.primaryIconTheme.color,
      disabledIconColor: theme.disabledColor,
    );
  }

  QlzbToolbarTheme._({
    @required this.color,
    @required this.toggleColor,
    @required this.iconColor,
    @required this.disabledIconColor,
  });

  QlzbToolbarTheme copyWith({
    Color color,
    Color toggleColor,
    Color iconColor,
    Color disabledIconColor,
  }) {
    return QlzbToolbarTheme._(
      color: color ?? this.color,
      toggleColor: toggleColor ?? this.toggleColor,
      iconColor: iconColor ?? this.iconColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
    );
  }
}
