/// A chunk before it gets an id and a source.
class ChunkDraft {
  const ChunkDraft({
    required this.position,
    required this.text,
    this.chapter,
  });

  final int position;
  final String text;
  final String? chapter;
}

/// Splits imported text into passages of roughly [targetChars].
///
/// Chapter labels come only from explicit Markdown headings in the text
/// ("# Title", "## Title"). Page numbers are never produced.
class TextChunker {
  const TextChunker({this.targetChars = 900, this.maxChars = 1400})
      : assert(targetChars > 0 && maxChars >= targetChars);

  final int targetChars;
  final int maxChars;

  static final RegExp _heading = RegExp(r'^#{1,6}\s+(.+?)\s*#*\s*$');

  List<ChunkDraft> chunk(String raw) {
    final normalized = raw.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    final drafts = <ChunkDraft>[];
    final buffer = StringBuffer();
    String? chapter;

    void emit(String text) {
      final trimmed = text.trim();
      if (trimmed.isEmpty) return;
      drafts.add(
        ChunkDraft(position: drafts.length, text: trimmed, chapter: chapter),
      );
    }

    void flush() {
      if (buffer.isEmpty) return;
      emit(buffer.toString());
      buffer.clear();
    }

    for (final block in normalized.split(RegExp(r'\n\s*\n'))) {
      final lines = block
          .split('\n')
          .map((l) => l.replaceAll(RegExp(r'[ \t]+'), ' ').trim())
          .where((l) => l.isNotEmpty)
          .toList();
      if (lines.isEmpty) continue;

      var bodyLines = lines;
      final match = _heading.firstMatch(lines.first);
      if (match != null) {
        flush(); // close the previous chapter before switching
        chapter = match.group(1);
        bodyLines = lines.sublist(1);
      }
      if (bodyLines.isEmpty) continue;

      final paragraph = bodyLines.join('\n');

      if (paragraph.length > maxChars) {
        flush();
        for (final piece in _splitLong(paragraph)) {
          emit(piece);
        }
        continue;
      }

      if (buffer.isNotEmpty &&
          buffer.length + 2 + paragraph.length > targetChars) {
        flush();
      }
      if (buffer.isNotEmpty) buffer.write('\n\n');
      buffer.write(paragraph);
    }

    flush();
    return drafts;
  }

  List<String> _splitLong(String paragraph) {
    final pieces = <String>[];
    var current = '';

    for (final sentence in paragraph.split(RegExp(r'(?<=[.!?])\s+'))) {
      if (sentence.length > maxChars) {
        if (current.isNotEmpty) {
          pieces.add(current);
          current = '';
        }
        pieces.addAll(_hardSplit(sentence));
      } else if (current.isNotEmpty &&
          current.length + 1 + sentence.length > targetChars) {
        pieces.add(current);
        current = sentence;
      } else {
        current = current.isEmpty ? sentence : '$current $sentence';
      }
    }
    if (current.isNotEmpty) pieces.add(current);
    return pieces;
  }

  List<String> _hardSplit(String text) {
    final pieces = <String>[];
    var current = '';

    for (final word in text.split(RegExp(r'\s+'))) {
      var w = word;
      while (w.length > maxChars) {
        if (current.isNotEmpty) {
          pieces.add(current);
          current = '';
        }
        pieces.add(w.substring(0, maxChars));
        w = w.substring(maxChars);
      }
      if (current.isEmpty) {
        current = w;
      } else if (current.length + 1 + w.length > maxChars) {
        pieces.add(current);
        current = w;
      } else {
        current = '$current $w';
      }
    }
    if (current.isNotEmpty) pieces.add(current);
    return pieces;
  }
}
