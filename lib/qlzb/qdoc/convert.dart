// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Provides codecs to convert QDoc documents to other formats.
library qdoc.convert;

import 'src/convert/markdown.dart';

export 'src/convert/markdown.dart';

/// Markdown codec for QDoc documents.
const QDocMarkdownCodec qdocMarkdown = QDocMarkdownCodec();
