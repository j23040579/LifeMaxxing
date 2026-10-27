// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LibrarySourcesTable extends LibrarySources
    with TableInfo<$LibrarySourcesTable, SourceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibrarySourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _importedAtMeta =
      const VerificationMeta('importedAt');
  @override
  late final GeneratedColumn<DateTime> importedAt = GeneratedColumn<DateTime>(
      'imported_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fingerprintMeta =
      const VerificationMeta('fingerprint');
  @override
  late final GeneratedColumn<String> fingerprint = GeneratedColumn<String>(
      'fingerprint', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chunkCountMeta =
      const VerificationMeta('chunkCount');
  @override
  late final GeneratedColumn<int> chunkCount = GeneratedColumn<int>(
      'chunk_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, author, type, importedAt, fingerprint, chunkCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_sources';
  @override
  VerificationContext validateIntegrity(Insertable<SourceRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('imported_at')) {
      context.handle(
          _importedAtMeta,
          importedAt.isAcceptableOrUnknown(
              data['imported_at']!, _importedAtMeta));
    } else if (isInserting) {
      context.missing(_importedAtMeta);
    }
    if (data.containsKey('fingerprint')) {
      context.handle(
          _fingerprintMeta,
          fingerprint.isAcceptableOrUnknown(
              data['fingerprint']!, _fingerprintMeta));
    } else if (isInserting) {
      context.missing(_fingerprintMeta);
    }
    if (data.containsKey('chunk_count')) {
      context.handle(
          _chunkCountMeta,
          chunkCount.isAcceptableOrUnknown(
              data['chunk_count']!, _chunkCountMeta));
    } else if (isInserting) {
      context.missing(_chunkCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SourceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SourceRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      importedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}imported_at'])!,
      fingerprint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fingerprint'])!,
      chunkCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chunk_count'])!,
    );
  }

  @override
  $LibrarySourcesTable createAlias(String alias) {
    return $LibrarySourcesTable(attachedDatabase, alias);
  }
}

class SourceRow extends DataClass implements Insertable<SourceRow> {
  final String id;
  final String title;
  final String? author;

  /// `SourceType.name` (for example "summary"). Stored as a name, not an
  /// index, so reordering the enum later cannot corrupt saved data.
  final String type;
  final DateTime importedAt;

  /// Normalised-text hash used for duplicate detection.
  final String fingerprint;
  final int chunkCount;
  const SourceRow(
      {required this.id,
      required this.title,
      this.author,
      required this.type,
      required this.importedAt,
      required this.fingerprint,
      required this.chunkCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    map['type'] = Variable<String>(type);
    map['imported_at'] = Variable<DateTime>(importedAt);
    map['fingerprint'] = Variable<String>(fingerprint);
    map['chunk_count'] = Variable<int>(chunkCount);
    return map;
  }

  LibrarySourcesCompanion toCompanion(bool nullToAbsent) {
    return LibrarySourcesCompanion(
      id: Value(id),
      title: Value(title),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      type: Value(type),
      importedAt: Value(importedAt),
      fingerprint: Value(fingerprint),
      chunkCount: Value(chunkCount),
    );
  }

  factory SourceRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SourceRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      type: serializer.fromJson<String>(json['type']),
      importedAt: serializer.fromJson<DateTime>(json['importedAt']),
      fingerprint: serializer.fromJson<String>(json['fingerprint']),
      chunkCount: serializer.fromJson<int>(json['chunkCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'type': serializer.toJson<String>(type),
      'importedAt': serializer.toJson<DateTime>(importedAt),
      'fingerprint': serializer.toJson<String>(fingerprint),
      'chunkCount': serializer.toJson<int>(chunkCount),
    };
  }

  SourceRow copyWith(
          {String? id,
          String? title,
          Value<String?> author = const Value.absent(),
          String? type,
          DateTime? importedAt,
          String? fingerprint,
          int? chunkCount}) =>
      SourceRow(
        id: id ?? this.id,
        title: title ?? this.title,
        author: author.present ? author.value : this.author,
        type: type ?? this.type,
        importedAt: importedAt ?? this.importedAt,
        fingerprint: fingerprint ?? this.fingerprint,
        chunkCount: chunkCount ?? this.chunkCount,
      );
  SourceRow copyWithCompanion(LibrarySourcesCompanion data) {
    return SourceRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      type: data.type.present ? data.type.value : this.type,
      importedAt:
          data.importedAt.present ? data.importedAt.value : this.importedAt,
      fingerprint:
          data.fingerprint.present ? data.fingerprint.value : this.fingerprint,
      chunkCount:
          data.chunkCount.present ? data.chunkCount.value : this.chunkCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SourceRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('type: $type, ')
          ..write('importedAt: $importedAt, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('chunkCount: $chunkCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, author, type, importedAt, fingerprint, chunkCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SourceRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.type == this.type &&
          other.importedAt == this.importedAt &&
          other.fingerprint == this.fingerprint &&
          other.chunkCount == this.chunkCount);
}

class LibrarySourcesCompanion extends UpdateCompanion<SourceRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> author;
  final Value<String> type;
  final Value<DateTime> importedAt;
  final Value<String> fingerprint;
  final Value<int> chunkCount;
  final Value<int> rowid;
  const LibrarySourcesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.type = const Value.absent(),
    this.importedAt = const Value.absent(),
    this.fingerprint = const Value.absent(),
    this.chunkCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibrarySourcesCompanion.insert({
    required String id,
    required String title,
    this.author = const Value.absent(),
    required String type,
    required DateTime importedAt,
    required String fingerprint,
    required int chunkCount,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        type = Value(type),
        importedAt = Value(importedAt),
        fingerprint = Value(fingerprint),
        chunkCount = Value(chunkCount);
  static Insertable<SourceRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? type,
    Expression<DateTime>? importedAt,
    Expression<String>? fingerprint,
    Expression<int>? chunkCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (type != null) 'type': type,
      if (importedAt != null) 'imported_at': importedAt,
      if (fingerprint != null) 'fingerprint': fingerprint,
      if (chunkCount != null) 'chunk_count': chunkCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibrarySourcesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? author,
      Value<String>? type,
      Value<DateTime>? importedAt,
      Value<String>? fingerprint,
      Value<int>? chunkCount,
      Value<int>? rowid}) {
    return LibrarySourcesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      type: type ?? this.type,
      importedAt: importedAt ?? this.importedAt,
      fingerprint: fingerprint ?? this.fingerprint,
      chunkCount: chunkCount ?? this.chunkCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (importedAt.present) {
      map['imported_at'] = Variable<DateTime>(importedAt.value);
    }
    if (fingerprint.present) {
      map['fingerprint'] = Variable<String>(fingerprint.value);
    }
    if (chunkCount.present) {
      map['chunk_count'] = Variable<int>(chunkCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibrarySourcesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('type: $type, ')
          ..write('importedAt: $importedAt, ')
          ..write('fingerprint: $fingerprint, ')
          ..write('chunkCount: $chunkCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LibraryChunksTable extends LibraryChunks
    with TableInfo<$LibraryChunksTable, ChunkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryChunksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES library_sources (id) ON DELETE CASCADE'));
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterMeta =
      const VerificationMeta('chapter');
  @override
  late final GeneratedColumn<String> chapter = GeneratedColumn<String>(
      'chapter', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
      'page', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sourceId, position, content, chapter, page];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_chunks';
  @override
  VerificationContext validateIntegrity(Insertable<ChunkRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(_chapterMeta,
          chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta));
    }
    if (data.containsKey('page')) {
      context.handle(
          _pageMeta, page.isAcceptableOrUnknown(data['page']!, _pageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChunkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChunkRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      chapter: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter']),
      page: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page']),
    );
  }

  @override
  $LibraryChunksTable createAlias(String alias) {
    return $LibraryChunksTable(attachedDatabase, alias);
  }
}

class ChunkRow extends DataClass implements Insertable<ChunkRow> {
  final String id;
  final String sourceId;
  final int position;
  final String content;

  /// Only set when the import carried an explicit chapter. Never guessed.
  final String? chapter;

  /// Only set when the import carried an explicit page. Never guessed.
  final int? page;
  const ChunkRow(
      {required this.id,
      required this.sourceId,
      required this.position,
      required this.content,
      this.chapter,
      this.page});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['position'] = Variable<int>(position);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || chapter != null) {
      map['chapter'] = Variable<String>(chapter);
    }
    if (!nullToAbsent || page != null) {
      map['page'] = Variable<int>(page);
    }
    return map;
  }

  LibraryChunksCompanion toCompanion(bool nullToAbsent) {
    return LibraryChunksCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      position: Value(position),
      content: Value(content),
      chapter: chapter == null && nullToAbsent
          ? const Value.absent()
          : Value(chapter),
      page: page == null && nullToAbsent ? const Value.absent() : Value(page),
    );
  }

  factory ChunkRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChunkRow(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      position: serializer.fromJson<int>(json['position']),
      content: serializer.fromJson<String>(json['content']),
      chapter: serializer.fromJson<String?>(json['chapter']),
      page: serializer.fromJson<int?>(json['page']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'position': serializer.toJson<int>(position),
      'content': serializer.toJson<String>(content),
      'chapter': serializer.toJson<String?>(chapter),
      'page': serializer.toJson<int?>(page),
    };
  }

  ChunkRow copyWith(
          {String? id,
          String? sourceId,
          int? position,
          String? content,
          Value<String?> chapter = const Value.absent(),
          Value<int?> page = const Value.absent()}) =>
      ChunkRow(
        id: id ?? this.id,
        sourceId: sourceId ?? this.sourceId,
        position: position ?? this.position,
        content: content ?? this.content,
        chapter: chapter.present ? chapter.value : this.chapter,
        page: page.present ? page.value : this.page,
      );
  ChunkRow copyWithCompanion(LibraryChunksCompanion data) {
    return ChunkRow(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      position: data.position.present ? data.position.value : this.position,
      content: data.content.present ? data.content.value : this.content,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      page: data.page.present ? data.page.value : this.page,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChunkRow(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('position: $position, ')
          ..write('content: $content, ')
          ..write('chapter: $chapter, ')
          ..write('page: $page')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sourceId, position, content, chapter, page);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChunkRow &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.position == this.position &&
          other.content == this.content &&
          other.chapter == this.chapter &&
          other.page == this.page);
}

class LibraryChunksCompanion extends UpdateCompanion<ChunkRow> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<int> position;
  final Value<String> content;
  final Value<String?> chapter;
  final Value<int?> page;
  final Value<int> rowid;
  const LibraryChunksCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.position = const Value.absent(),
    this.content = const Value.absent(),
    this.chapter = const Value.absent(),
    this.page = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LibraryChunksCompanion.insert({
    required String id,
    required String sourceId,
    required int position,
    required String content,
    this.chapter = const Value.absent(),
    this.page = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sourceId = Value(sourceId),
        position = Value(position),
        content = Value(content);
  static Insertable<ChunkRow> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<int>? position,
    Expression<String>? content,
    Expression<String>? chapter,
    Expression<int>? page,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (position != null) 'position': position,
      if (content != null) 'content': content,
      if (chapter != null) 'chapter': chapter,
      if (page != null) 'page': page,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LibraryChunksCompanion copyWith(
      {Value<String>? id,
      Value<String>? sourceId,
      Value<int>? position,
      Value<String>? content,
      Value<String?>? chapter,
      Value<int?>? page,
      Value<int>? rowid}) {
    return LibraryChunksCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      position: position ?? this.position,
      content: content ?? this.content,
      chapter: chapter ?? this.chapter,
      page: page ?? this.page,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<String>(chapter.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryChunksCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('position: $position, ')
          ..write('content: $content, ')
          ..write('chapter: $chapter, ')
          ..write('page: $page, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LibrarySourcesTable librarySources = $LibrarySourcesTable(this);
  late final $LibraryChunksTable libraryChunks = $LibraryChunksTable(this);
  late final Index idxLibrarySourcesFingerprint = Index(
      'idx_library_sources_fingerprint',
      'CREATE INDEX idx_library_sources_fingerprint ON library_sources (fingerprint)');
  late final Index idxLibraryChunksSource = Index('idx_library_chunks_source',
      'CREATE INDEX idx_library_chunks_source ON library_chunks (source_id)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        librarySources,
        libraryChunks,
        idxLibrarySourcesFingerprint,
        idxLibraryChunksSource
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('library_sources',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('library_chunks', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$LibrarySourcesTableCreateCompanionBuilder = LibrarySourcesCompanion
    Function({
  required String id,
  required String title,
  Value<String?> author,
  required String type,
  required DateTime importedAt,
  required String fingerprint,
  required int chunkCount,
  Value<int> rowid,
});
typedef $$LibrarySourcesTableUpdateCompanionBuilder = LibrarySourcesCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String?> author,
  Value<String> type,
  Value<DateTime> importedAt,
  Value<String> fingerprint,
  Value<int> chunkCount,
  Value<int> rowid,
});

final class $$LibrarySourcesTableReferences
    extends BaseReferences<_$AppDatabase, $LibrarySourcesTable, SourceRow> {
  $$LibrarySourcesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LibraryChunksTable, List<ChunkRow>>
      _libraryChunksRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.libraryChunks,
              aliasName: 'library_sources__id__library_chunks__source_id');

  $$LibraryChunksTableProcessedTableManager get libraryChunksRefs {
    final manager = $$LibraryChunksTableTableManager($_db, $_db.libraryChunks)
        .filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_libraryChunksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$LibrarySourcesTableFilterComposer
    extends Composer<_$AppDatabase, $LibrarySourcesTable> {
  $$LibrarySourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get importedAt => $composableBuilder(
      column: $table.importedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fingerprint => $composableBuilder(
      column: $table.fingerprint, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chunkCount => $composableBuilder(
      column: $table.chunkCount, builder: (column) => ColumnFilters(column));

  Expression<bool> libraryChunksRefs(
      Expression<bool> Function($$LibraryChunksTableFilterComposer f) f) {
    final $$LibraryChunksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.libraryChunks,
        getReferencedColumn: (t) => t.sourceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LibraryChunksTableFilterComposer(
              $db: $db,
              $table: $db.libraryChunks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LibrarySourcesTableOrderingComposer
    extends Composer<_$AppDatabase, $LibrarySourcesTable> {
  $$LibrarySourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get importedAt => $composableBuilder(
      column: $table.importedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fingerprint => $composableBuilder(
      column: $table.fingerprint, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chunkCount => $composableBuilder(
      column: $table.chunkCount, builder: (column) => ColumnOrderings(column));
}

class $$LibrarySourcesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibrarySourcesTable> {
  $$LibrarySourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get importedAt => $composableBuilder(
      column: $table.importedAt, builder: (column) => column);

  GeneratedColumn<String> get fingerprint => $composableBuilder(
      column: $table.fingerprint, builder: (column) => column);

  GeneratedColumn<int> get chunkCount => $composableBuilder(
      column: $table.chunkCount, builder: (column) => column);

  Expression<T> libraryChunksRefs<T extends Object>(
      Expression<T> Function($$LibraryChunksTableAnnotationComposer a) f) {
    final $$LibraryChunksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.libraryChunks,
        getReferencedColumn: (t) => t.sourceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LibraryChunksTableAnnotationComposer(
              $db: $db,
              $table: $db.libraryChunks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$LibrarySourcesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LibrarySourcesTable,
    SourceRow,
    $$LibrarySourcesTableFilterComposer,
    $$LibrarySourcesTableOrderingComposer,
    $$LibrarySourcesTableAnnotationComposer,
    $$LibrarySourcesTableCreateCompanionBuilder,
    $$LibrarySourcesTableUpdateCompanionBuilder,
    (SourceRow, $$LibrarySourcesTableReferences),
    SourceRow,
    PrefetchHooks Function({bool libraryChunksRefs})> {
  $$LibrarySourcesTableTableManager(
      _$AppDatabase db, $LibrarySourcesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibrarySourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibrarySourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibrarySourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> importedAt = const Value.absent(),
            Value<String> fingerprint = const Value.absent(),
            Value<int> chunkCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LibrarySourcesCompanion(
            id: id,
            title: title,
            author: author,
            type: type,
            importedAt: importedAt,
            fingerprint: fingerprint,
            chunkCount: chunkCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> author = const Value.absent(),
            required String type,
            required DateTime importedAt,
            required String fingerprint,
            required int chunkCount,
            Value<int> rowid = const Value.absent(),
          }) =>
              LibrarySourcesCompanion.insert(
            id: id,
            title: title,
            author: author,
            type: type,
            importedAt: importedAt,
            fingerprint: fingerprint,
            chunkCount: chunkCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LibrarySourcesTable, SourceRow>(table),
                    $$LibrarySourcesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({libraryChunksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (libraryChunksRefs) db.libraryChunks
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (libraryChunksRefs)
                    await $_getPrefetchedDataByColumns<
                            SourceRow,
                            $LibrarySourcesTable,
                            ChunkRow,
                            $LibraryChunksTable>(
                        currentTable: table,
                        referencedTable: $$LibrarySourcesTableReferences
                            ._libraryChunksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$LibrarySourcesTableReferences(db, table, p0)
                                .libraryChunksRefs,
                        currentColumn: 'id',
                        referencedColumn: 'source_id',
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$LibrarySourcesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LibrarySourcesTable,
    SourceRow,
    $$LibrarySourcesTableFilterComposer,
    $$LibrarySourcesTableOrderingComposer,
    $$LibrarySourcesTableAnnotationComposer,
    $$LibrarySourcesTableCreateCompanionBuilder,
    $$LibrarySourcesTableUpdateCompanionBuilder,
    (SourceRow, $$LibrarySourcesTableReferences),
    SourceRow,
    PrefetchHooks Function({bool libraryChunksRefs})>;
typedef $$LibraryChunksTableCreateCompanionBuilder = LibraryChunksCompanion
    Function({
  required String id,
  required String sourceId,
  required int position,
  required String content,
  Value<String?> chapter,
  Value<int?> page,
  Value<int> rowid,
});
typedef $$LibraryChunksTableUpdateCompanionBuilder = LibraryChunksCompanion
    Function({
  Value<String> id,
  Value<String> sourceId,
  Value<int> position,
  Value<String> content,
  Value<String?> chapter,
  Value<int?> page,
  Value<int> rowid,
});

final class $$LibraryChunksTableReferences
    extends BaseReferences<_$AppDatabase, $LibraryChunksTable, ChunkRow> {
  $$LibraryChunksTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $LibrarySourcesTable _sourceIdTable(_$AppDatabase db) =>
      db.librarySources
          .createAlias('library_chunks__source_id__library_sources__id');

  $$LibrarySourcesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$LibrarySourcesTableTableManager($_db, $_db.librarySources)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$LibraryChunksTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryChunksTable> {
  $$LibraryChunksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnFilters(column));

  $$LibrarySourcesTableFilterComposer get sourceId {
    final $$LibrarySourcesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceId,
        referencedTable: $db.librarySources,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LibrarySourcesTableFilterComposer(
              $db: $db,
              $table: $db.librarySources,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LibraryChunksTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryChunksTable> {
  $$LibraryChunksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get page => $composableBuilder(
      column: $table.page, builder: (column) => ColumnOrderings(column));

  $$LibrarySourcesTableOrderingComposer get sourceId {
    final $$LibrarySourcesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceId,
        referencedTable: $db.librarySources,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LibrarySourcesTableOrderingComposer(
              $db: $db,
              $table: $db.librarySources,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LibraryChunksTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryChunksTable> {
  $$LibraryChunksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  $$LibrarySourcesTableAnnotationComposer get sourceId {
    final $$LibrarySourcesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceId,
        referencedTable: $db.librarySources,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$LibrarySourcesTableAnnotationComposer(
              $db: $db,
              $table: $db.librarySources,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$LibraryChunksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LibraryChunksTable,
    ChunkRow,
    $$LibraryChunksTableFilterComposer,
    $$LibraryChunksTableOrderingComposer,
    $$LibraryChunksTableAnnotationComposer,
    $$LibraryChunksTableCreateCompanionBuilder,
    $$LibraryChunksTableUpdateCompanionBuilder,
    (ChunkRow, $$LibraryChunksTableReferences),
    ChunkRow,
    PrefetchHooks Function({bool sourceId})> {
  $$LibraryChunksTableTableManager(_$AppDatabase db, $LibraryChunksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryChunksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryChunksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryChunksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sourceId = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> chapter = const Value.absent(),
            Value<int?> page = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LibraryChunksCompanion(
            id: id,
            sourceId: sourceId,
            position: position,
            content: content,
            chapter: chapter,
            page: page,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sourceId,
            required int position,
            required String content,
            Value<String?> chapter = const Value.absent(),
            Value<int?> page = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LibraryChunksCompanion.insert(
            id: id,
            sourceId: sourceId,
            position: position,
            content: content,
            chapter: chapter,
            page: page,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$LibraryChunksTable, ChunkRow>(table),
                    $$LibraryChunksTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sourceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (sourceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sourceId,
                    referencedTable:
                        $$LibraryChunksTableReferences._sourceIdTable(db),
                    referencedColumn:
                        $$LibraryChunksTableReferences._sourceIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$LibraryChunksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LibraryChunksTable,
    ChunkRow,
    $$LibraryChunksTableFilterComposer,
    $$LibraryChunksTableOrderingComposer,
    $$LibraryChunksTableAnnotationComposer,
    $$LibraryChunksTableCreateCompanionBuilder,
    $$LibraryChunksTableUpdateCompanionBuilder,
    (ChunkRow, $$LibraryChunksTableReferences),
    ChunkRow,
    PrefetchHooks Function({bool sourceId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LibrarySourcesTableTableManager get librarySources =>
      $$LibrarySourcesTableTableManager(_db, _db.librarySources);
  $$LibraryChunksTableTableManager get libraryChunks =>
      $$LibraryChunksTableTableManager(_db, _db.libraryChunks);
}
