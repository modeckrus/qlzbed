// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:quill_delta/quill_delta.dart';

import '../qdoc.dart';
import 'heuristics/delete_rules.dart';
import 'heuristics/format_rules.dart';
import 'heuristics/insert_rules.dart';

/// Registry for insert, format and delete heuristic rules used by
/// [QDocDocument] documents.
class QDocHeuristics {
  /// Default set of heuristic rules.
  static const QDocHeuristics fallback = QDocHeuristics(
    formatRules: [
      FormatEmbedsRule(),
      FormatLinkAtCaretPositionRule(),
      ResolveLineFormatRule(),
      ResolveInlineFormatRule(),
      // No need in catch-all rule here since the above rules cover all
      // attributes.
    ],
    insertRules: [
      PreserveBlockStyleOnPasteRule(),
      ForceNewlineForInsertsAroundEmbedRule(),
      PreserveLineStyleOnSplitRule(),
      AutoExitBlockRule(),
      ResetLineFormatOnNewLineRule(),
      AutoFormatLinksRule(),
      PreserveInlineStylesRule(),
      CatchAllInsertRule(),
    ],
    deleteRules: [
      EnsureEmbedLineRule(),
      PreserveLineStyleOnMergeRule(),
      CatchAllDeleteRule(),
    ],
  );

  const QDocHeuristics({
    this.formatRules,
    this.insertRules,
    this.deleteRules,
  });

  /// List of format rules in this registry.
  final List<FormatRule> formatRules;

  /// List of insert rules in this registry.
  final List<InsertRule> insertRules;

  /// List of delete rules in this registry.
  final List<DeleteRule> deleteRules;

  /// Applies heuristic rules to specified insert operation based on current
  /// state of QDoc [document].
  Delta applyInsertRules(QDocDocument document, int index, String insert) {
    final delta = document.toDelta();
    for (var rule in insertRules) {
      final result = rule.apply(delta, index, insert);
      if (result != null) return result..trim();
    }
    throw StateError('Failed to apply insert heuristic rules: none applied.');
  }

  /// Applies heuristic rules to specified format operation based on current
  /// state of QDoc [document].
  Delta applyFormatRules(
      QDocDocument document, int index, int length, QDocAttribute value) {
    final delta = document.toDelta();
    for (var rule in formatRules) {
      final result = rule.apply(delta, index, length, value);
      if (result != null) return result..trim();
    }
    throw StateError('Failed to apply format heuristic rules: none applied.');
  }

  /// Applies heuristic rules to specified delete operation based on current
  /// state of QDoc [document].
  Delta applyDeleteRules(QDocDocument document, int index, int length) {
    final delta = document.toDelta();
    for (var rule in deleteRules) {
      final result = rule.apply(delta, index, length);
      if (result != null) return result..trim();
    }
    throw StateError('Failed to apply delete heuristic rules: none applied.');
  }
}