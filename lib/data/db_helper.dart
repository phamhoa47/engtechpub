import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:appta/features/vocabulary/models/vocabulary_item.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'vocabulary.db');

    return await openDatabase(
      path,
      version: 2, // 🆕 tăng version khi thay đổi cấu trúc
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE vocabulary(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word TEXT,
            pronunciation TEXT,
            meaning TEXT,
            example TEXT,
            exampleVi TEXT,
            imageUrl TEXT, -- 🆕 lưu link ảnh thay vì iconCode
            topic TEXT,
            isFavorite INTEGER,
            isLearned INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Nếu từ version cũ nâng cấp, thêm cột imageUrl
          await db.execute('ALTER TABLE vocabulary ADD COLUMN imageUrl TEXT');
        }
      },
    );
  }

  /// Thêm 1 từ vựng
  Future<int> insertVocabulary(VocabularyItem item) async {
    final db = await database;
    return await db.insert('vocabulary', item.toMap());
  }

  /// Thêm nhiều từ vựng cùng lúc (dùng khi import JSON)
  Future<void> insertBulk(List<VocabularyItem> items) async {
    final db = await database;
    Batch batch = db.batch();
    for (var item in items) {
      batch.insert('vocabulary', item.toMap());
    }
    await batch.commit(noResult: true);
  }

  /// Lấy toàn bộ từ vựng
  Future<List<VocabularyItem>> getAllVocabulary() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('vocabulary');
    return List.generate(maps.length, (i) => VocabularyItem.fromMap(maps[i]));
  }

  /// Cập nhật từ vựng
  Future<int> updateVocabulary(VocabularyItem item) async {
    final db = await database;
    return await db.update(
      'vocabulary',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  /// Xóa từ vựng theo ID
  Future<int> deleteVocabulary(int id) async {
    final db = await database;
    return await db.delete('vocabulary', where: 'id = ?', whereArgs: [id]);
  }

  /// Xóa toàn bộ dữ liệu (dùng khi reset)
  Future<int> deleteAll() async {
    final db = await database;
    return await db.delete('vocabulary');
  }
}
