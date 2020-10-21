// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:collection/collection.dart';
import 'package:quiver_hashcode/hashcode.dart';

/// Scope of a style attribute, defines context in which an attribute can be
/// applied.
enum QDocAttributeScope {
  /// Inline-scoped attributes are applicable to all characters within a line.
  ///
  /// Inline attributes cannot be applied to the line itself.
  inline,

  /// Line-scoped attributes are only applicable to a line of text as a whole.
  ///
  /// Line attributes do not have any effect on any character within the line.
  line,
}

/// Interface for objects which provide access to an attribute key.
///
/// Implemented by [QDocAttribute] and [QDocAttributeBuilder].
abstract class QDocAttributeKey<T> {
  /// Unique key of this attribute.
  String get key;
}

/// Builder for style attributes.
///
/// Useful in scenarios when an attribute value is not known upfront, for
/// instance, link attribute.
///
/// See also:
///   * [LinkAttributeBuilder]
///   * [BlockAttributeBuilder]
///   * [HeadingAttributeBuilder]
abstract class QDocAttributeBuilder<T> implements QDocAttributeKey<T> {
  const QDocAttributeBuilder._(this.key, this.scope);

  @override
  final String key;
  final QDocAttributeScope scope;
  QDocAttribute<T> get unset => QDocAttribute<T>._(key, scope, null);
  QDocAttribute<T> withValue(T value) => QDocAttribute<T>._(key, scope, value);
}

/// Style attribute applicable to a segment of a QDoc document.
///
/// All supported attributes are available via static fields on this class.
/// Here is an example of applying styles to a document:
///
///     void makeItPretty(QDoc document) {
///       // Format 5 characters at position 0 as bold
///       document.format(0, 5, QDocAttribute.bold);
///       // Similarly for italic
///       document.format(0, 5, QDocAttribute.italic);
///       // Format first line as a heading (h1)
///       // Note that there is no need to specify character range of the whole
///       // line. Simply set index position to anywhere within the line and
///       // length to 0.
///       document.format(0, 0, QDocAttribute.h1);
///     }
///
/// List of supported attributes:
///
///   * [QDocAttribute.bold]
///   * [QDocAttribute.italic]
///   * [QDocAttribute.link]
///   * [QDocAttribute.heading]
///   * [QDocAttribute.block]
class QDocAttribute<T> implements QDocAttributeBuilder<T> {
  static final Map<String, QDocAttributeBuilder> _registry = {
    QDocAttribute.bold.key: QDocAttribute.bold,
    QDocAttribute.italic.key: QDocAttribute.italic,
    QDocAttribute.link.key: QDocAttribute.link,
    QDocAttribute.heading.key: QDocAttribute.heading,
    QDocAttribute.block.key: QDocAttribute.block,
    QDocAttribute.embed.key: QDocAttribute.embed,
  };

  // Inline attributes

  /// Bold style attribute.
  static const bold = _BoldAttribute();

  /// Italic style attribute.
  static const italic = _ItalicAttribute();

  /// Link style attribute.
  // ignore: const_eval_throws_exception
  static const link = LinkAttributeBuilder._();

  // Line attributes

  /// Heading style attribute.
  // ignore: const_eval_throws_exception
  static const heading = HeadingAttributeBuilder._();

  /// Alias for [QDocAttribute.heading.level1].
  static QDocAttribute<int> get h1 => heading.level1;

  /// Alias for [QDocAttribute.heading.level2].
  static QDocAttribute<int> get h2 => heading.level2;

  /// Alias for [QDocAttribute.heading.level3].
  static QDocAttribute<int> get h3 => heading.level3;

  /// Block attribute
  // ignore: const_eval_throws_exception
  static const block = BlockAttributeBuilder._();

  /// Alias for [QDocAttribute.block.bulletList].
  static QDocAttribute<String> get ul => block.bulletList;

  /// Alias for [QDocAttribute.block.numberList].
  static QDocAttribute<String> get ol => block.numberList;

  /// Alias for [QDocAttribute.block.quote].
  static QDocAttribute<String> get bq => block.quote;

  /// Alias for [QDocAttribute.block.code].
  static QDocAttribute<String> get code => block.code;

  /// Embed style attribute.
  // ignore: const_eval_throws_exception
  static const embed = EmbedAttributeBuilder._();

  static QDocAttribute _fromKeyValue(String key, dynamic value) {
    if (!_registry.containsKey(key)) {
      throw ArgumentError.value(
          key, 'No attribute with key "$key" registered.');
    }
    final builder = _registry[key];
    return builder.withValue(value);
  }

  const QDocAttribute._(this.key, this.scope, this.value);

  /// Unique key of this attribute.
  @override
  final String key;

  /// Scope of this attribute.
  @override
  final QDocAttributeScope scope;

  /// Value of this attribute.
  ///
  /// If value is `null` then this attribute represents a transient action
  /// of removing associated style and is never persisted in a resulting
  /// document.
  ///
  /// See also [unset], [QDocStyle.merge] and [QDocStyle.put]
  /// for details.
  final T value;

  /// Returns special "unset" version of this attribute.
  ///
  /// Unset attribute's [value] is always `null`.
  ///
  /// When composed into a rich text document, unset attributes remove
  /// associated style.
  @override
  QDocAttribute<T> get unset => QDocAttribute<T>._(key, scope, null);

  /// Returns `true` if this attribute is an unset attribute.
  bool get isUnset => value == null;

  /// Returns `true` if this is an inline-scoped attribute.
  bool get isInline => scope == QDocAttributeScope.inline;

  @override
  QDocAttribute<T> withValue(T value) => QDocAttribute<T>._(key, scope, value);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! QDocAttribute<T>) return false;
    QDocAttribute<T> typedOther = other;
    return key == typedOther.key &&
        scope == typedOther.scope &&
        value == typedOther.value;
  }

  @override
  int get hashCode => hash3(key, scope, value);

  @override
  String toString() => '$key: $value';

  Map<String, dynamic> toJson() => <String, dynamic>{key: value};
}

/// Collection of style attributes.
class QDocStyle {
  QDocStyle._(this._data);

  final Map<String, QDocAttribute> _data;

  static QDocStyle fromJson(Map<String, dynamic> data) {
    if (data == null) return QDocStyle();

    final result = data.map((String key, dynamic value) {
      var attr = QDocAttribute._fromKeyValue(key, value);
      return MapEntry<String, QDocAttribute>(key, attr);
    });
    return QDocStyle._(result);
  }

  QDocStyle() : _data = <String, QDocAttribute>{};

  /// Returns `true` if this attribute set is empty.
  bool get isEmpty => _data.isEmpty;

  /// Returns `true` if this attribute set is note empty.
  bool get isNotEmpty => _data.isNotEmpty;

  /// Returns `true` if this style is not empty and contains only inline-scoped
  /// attributes and is not empty.
  bool get isInline => isNotEmpty && values.every((item) => item.isInline);

  /// Checks that this style has only one attribute, and returns that attribute.
  QDocAttribute get single => _data.values.single;

  /// Returns `true` if attribute with [key] is present in this set.
  ///
  /// Only checks for presence of specified [key] regardless of the associated
  /// value.
  ///
  /// To test if this set contains an attribute with specific value consider
  /// using [containsSame].
  bool contains(QDocAttributeKey key) => _data.containsKey(key.key);

  /// Returns `true` if this set contains attribute with the same value as
  /// [attribute].
  bool containsSame(QDocAttribute attribute) {
    assert(attribute != null);
    return get<dynamic>(attribute) == attribute;
  }

  /// Returns value of specified attribute [key] in this set.
  T value<T>(QDocAttributeKey<T> key) => get(key).value;

  /// Returns [QDocAttribute] from this set by specified [key].
  QDocAttribute<T> get<T>(QDocAttributeKey<T> key) =>
      _data[key.key] as QDocAttribute<T>;

  /// Returns collection of all attribute keys in this set.
  Iterable<String> get keys => _data.keys;

  /// Returns collection of all attributes in this set.
  Iterable<QDocAttribute> get values => _data.values;

  /// Puts [attribute] into this attribute set and returns result as a new set.
  QDocStyle put(QDocAttribute attribute) {
    final result = Map<String, QDocAttribute>.from(_data);
    result[attribute.key] = attribute;
    return QDocStyle._(result);
  }

  /// Merges this attribute set with [attribute] and returns result as a new
  /// attribute set.
  ///
  /// Performs compaction if [attribute] is an "unset" value, e.g. removes
  /// corresponding attribute from this set completely.
  ///
  /// See also [put] method which does not perform compaction and allows
  /// constructing styles with "unset" values.
  QDocStyle merge(QDocAttribute attribute) {
    final merged = Map<String, QDocAttribute>.from(_data);
    if (attribute.isUnset) {
      merged.remove(attribute.key);
    } else {
      merged[attribute.key] = attribute;
    }
    return QDocStyle._(merged);
  }

  /// Merges all attributes from [other] into this style and returns result
  /// as a new instance of [QDocStyle].
  QDocStyle mergeAll(QDocStyle other) {
    var result = QDocStyle._(_data);
    for (var value in other.values) {
      result = result.merge(value);
    }
    return result;
  }

  /// Removes [attributes] from this style and returns new instance of
  /// [QDocStyle] containing result.
  QDocStyle removeAll(Iterable<QDocAttribute> attributes) {
    final merged = Map<String, QDocAttribute>.from(_data);
    attributes.map((item) => item.key).forEach(merged.remove);
    return QDocStyle._(merged);
  }

  /// Returns JSON-serializable representation of this style.
  Map<String, dynamic> toJson() => _data.isEmpty
      ? null
      : _data.map<String, dynamic>((String _, QDocAttribute value) =>
          MapEntry<String, dynamic>(value.key, value.value));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! QDocStyle) return false;
    QDocStyle typedOther = other;
    final eq = const MapEquality<String, QDocAttribute>();
    return eq.equals(_data, typedOther._data);
  }

  @override
  int get hashCode {
    final hashes = _data.entries.map((entry) => hash2(entry.key, entry.value));
    return hashObjects(hashes);
  }

  @override
  String toString() => "{${_data.values.join(', ')}}";
}

/// Applies bold style to a text segment.
class _BoldAttribute extends QDocAttribute<bool> {
  const _BoldAttribute() : super._('b', QDocAttributeScope.inline, true);
}

/// Applies italic style to a text segment.
class _ItalicAttribute extends QDocAttribute<bool> {
  const _ItalicAttribute() : super._('i', QDocAttributeScope.inline, true);
}

/// Builder for link attribute values.
///
/// There is no need to use this class directly, consider using
/// [QDocAttribute.link] instead.
class LinkAttributeBuilder extends QDocAttributeBuilder<String> {
  static const _kLink = 'a';
  const LinkAttributeBuilder._() : super._(_kLink, QDocAttributeScope.inline);

  /// Creates a link attribute with specified link [value].
  QDocAttribute<String> fromString(String value) =>
      QDocAttribute<String>._(key, scope, value);
}

/// Builder for heading attribute styles.
///
/// There is no need to use this class directly, consider using
/// [QDocAttribute.heading] instead.
class HeadingAttributeBuilder extends QDocAttributeBuilder<int> {
  static const _kHeading = 'heading';
  const HeadingAttributeBuilder._()
      : super._(_kHeading, QDocAttributeScope.line);

  /// Level 1 heading, equivalent of `H1` in HTML.
  QDocAttribute<int> get level1 => QDocAttribute<int>._(key, scope, 1);

  /// Level 2 heading, equivalent of `H2` in HTML.
  QDocAttribute<int> get level2 => QDocAttribute<int>._(key, scope, 2);

  /// Level 3 heading, equivalent of `H3` in HTML.
  QDocAttribute<int> get level3 => QDocAttribute<int>._(key, scope, 3);
}

/// Builder for block attribute styles (number/bullet lists, code and quote).
///
/// There is no need to use this class directly, consider using
/// [QDocAttribute.block] instead.
class BlockAttributeBuilder extends QDocAttributeBuilder<String> {
  static const _kBlock = 'block';
  const BlockAttributeBuilder._() : super._(_kBlock, QDocAttributeScope.line);

  /// Formats a block of lines as a bullet list.
  QDocAttribute<String> get bulletList =>
      QDocAttribute<String>._(key, scope, 'ul');

  /// Formats a block of lines as a number list.
  QDocAttribute<String> get numberList =>
      QDocAttribute<String>._(key, scope, 'ol');

  /// Formats a block of lines as a code snippet, using monospace font.
  QDocAttribute<String> get code => QDocAttribute<String>._(key, scope, 'code');

  /// Formats a block of lines as a quote.
  QDocAttribute<String> get quote =>
      QDocAttribute<String>._(key, scope, 'quote');
}

class EmbedAttributeBuilder extends QDocAttributeBuilder<Map<String, dynamic>> {
  const EmbedAttributeBuilder._()
      : super._(EmbedAttribute._kEmbed, QDocAttributeScope.inline);

  QDocAttribute<Map<String, dynamic>> get horizontalRule =>
      EmbedAttribute.horizontalRule();

  QDocAttribute<Map<String, dynamic>> image(String source) =>
      EmbedAttribute.image(source);

  @override
  QDocAttribute<Map<String, dynamic>> get unset => EmbedAttribute._(null);

  @override
  QDocAttribute<Map<String, dynamic>> withValue(Map<String, dynamic> value) =>
      EmbedAttribute._(value);
}

/// Type of embedded content.
enum EmbedType { horizontalRule, image }

class EmbedAttribute extends QDocAttribute<Map<String, dynamic>> {
  static const _kValueEquality = MapEquality<String, dynamic>();
  static const _kEmbed = 'embed';
  static const _kHorizontalRuleEmbed = 'hr';
  static const _kImageEmbed = 'image';

  EmbedAttribute._(Map<String, dynamic> value)
      : super._(_kEmbed, QDocAttributeScope.inline, value);

  EmbedAttribute.horizontalRule()
      : this._(<String, dynamic>{'type': _kHorizontalRuleEmbed});

  EmbedAttribute.image(String source)
      : this._(<String, dynamic>{'type': _kImageEmbed, 'source': source});

  /// Type of this embed.
  EmbedType get type {
    if (value['type'] == _kHorizontalRuleEmbed) return EmbedType.horizontalRule;
    if (value['type'] == _kImageEmbed) return EmbedType.image;
    assert(false, 'Unknown embed attribute value $value.');
    return null;
  }

  @override
  QDocAttribute<Map<String, dynamic>> get unset => EmbedAttribute._(null);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! EmbedAttribute) return false;
    EmbedAttribute typedOther = other;
    return key == typedOther.key &&
        scope == typedOther.scope &&
        _kValueEquality.equals(value, typedOther.value);
  }

  @override
  int get hashCode {
    final objects = [key, scope];
    if (value != null) {
      final valueHashes =
          value.entries.map((entry) => hash2(entry.key, entry.value));
      objects.addAll(valueHashes);
    } else {
      objects.add(value);
    }
    return hashObjects(objects);
  }
}
