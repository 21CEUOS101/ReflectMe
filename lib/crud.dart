import 'dart:async';
import 'dart:core';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// Exceptions

class DatabaseAlreadyOpenException implements Exception {}
class UnableToGetDocumentsDirectory implements Exception {}
class DatabaseIsNotOpen implements Exception {}
class CouldNotDeleteUser implements Exception{}
class CouldNotDeleteJournal implements Exception{}
class CouldNotUpdateJournal implements Exception{}
class CouldNotFindUser implements Exception{}
class UserAlreadyExists implements Exception {}
class UserNotExists implements Exception {}

// Service Class

class JournalServices {

  Database? db;

  List<Journal> _journals = [];

  late final StreamController<List<Journal>> _journalStreamController;

  Stream<List<Journal>> get allJournals => _journalStreamController.stream;
  Stream<List<Journal>> allJournalsById(int userId) => _journalStreamController.stream.map((List<Journal> journals) => journals.where((journal) => journal.userId == userId).toList());

  static final JournalServices _shared = JournalServices._sharedInstance();
  JournalServices._sharedInstance(){
    _journalStreamController  = StreamController<List<Journal>>.broadcast(
      onListen: () {
        _journalStreamController.sink.add(_journals);
      }
    );

  }
  factory JournalServices() => _shared;

  Future<void> _cacheJournal() async{
    final journals = await getAllJournals();

    _journals = journals.toList();

    _journalStreamController.add(_journals);
  }

  Database getDatabaseOrThrow() {

    Database? _db = db;

    if(_db == null)
      {
        throw DatabaseIsNotOpen();
      }
    else
      {
        return _db;
      }
  }

  Future<Journal> updateJournal({required Journal journal , required String title , required String subTitle , required String content}) async {
    await _ensureDbIsOpen();
    Database _db = getDatabaseOrThrow();
    
    await getJournal(noteId: journal.id);

    final updateCount = await _db.update('Journal', {
      titleColumn : title,
      subColumn : subTitle,
      contentColumn : content,
    } , where: 'NoteId = ?' , whereArgs: [journal.id]);

    if(updateCount == 0)
      {
        throw CouldNotUpdateJournal();
      }
    else{
      _journals = await getAllJournals();
      return await getJournal(noteId: journal.id);
    }
  }

  Future<List<Journal>> getAllJournals() async{
    await _ensureDbIsOpen();
    Database _db = getDatabaseOrThrow();

    final notes = await _db.query('Journal');

    final result = notes.map((journal) => Journal.fromRow(journal));

    return result.toList();
  }

  Future<Iterable<Journal>> getAllJournalsById({required int userId}) async{
    await _ensureDbIsOpen();
    Database _db = getDatabaseOrThrow();

    final notes = await _db.query('Journal' , where: 'UserId = ?' , whereArgs: [userId]);

    final result = notes.map((journal) => Journal.fromRow(journal));

    return result;
  }
  
  Future<Journal> getJournal({required int noteId}) async{
    await _ensureDbIsOpen();
    Database _db = getDatabaseOrThrow();
    
    final notes =  await _db.query('Journal' , limit: 1 , where: 'NoteId = ?' , whereArgs: [noteId]);
    
    return Journal.fromRow(notes.first);
  }

  Future<int> deleteAllNotes() async{
    await _ensureDbIsOpen();
    Database _db = getDatabaseOrThrow();
    final noOfDeletion = await _db.delete('Journal');
    _journals = [];
    _journalStreamController.add(_journals);
    return noOfDeletion;
  }

  Future<void> deleteJournal({required int noteId}) async {
    await _ensureDbIsOpen();
    Database _db = getDatabaseOrThrow();

    final deleteCount = await _db.delete('Journal' , where: 'NoteId = ?' , whereArgs: [noteId]);

    if(deleteCount != 1)
      {
        throw CouldNotDeleteJournal();
      }
    else{
      _journals.removeWhere((element) => element.id == noteId);
      _journalStreamController.add(_journals);
    }

  }

  Future<Journal> createJournal({required int ownerId , required String title , required String subTitle , required String content , required String dateAndtime}) async{
    await _ensureDbIsOpen();
    Database _db = getDatabaseOrThrow();

    final dbUser = await getUser(userId: ownerId);

    if(dbUser == null)
      {
        throw CouldNotFindUser();
      }

    final noteId =  await _db.insert('Journal', {
      uidColumn : ownerId,
      titleColumn : title,
      subColumn : subTitle,
      contentColumn : content,
      dateColumn : dateAndtime,
    });

    final journal = Journal(id: noteId as int, userId: ownerId, title: title, subTitle: subTitle, content: content,dateAndtime: dateAndtime);
    
    _journals.add(journal);

    _journalStreamController.add(_journals);
    
    return journal;
  }

  Future<User> getUser({required int userId}) async{
    await _ensureDbIsOpen();
    Database _db = getDatabaseOrThrow();

    final results = await _db.query('UserInfo' , limit: 1 , where: 'UserId = ?' , whereArgs: [userId]);

    if(results!.isEmpty)
      {
        throw UserNotExists();
      }
    else
      {
        return User.fromRow(results!.first);
      }

  }

  Future<User> getUserByemail({required String email}) async{
    await _ensureDbIsOpen();
    Database _db = getDatabaseOrThrow();

    final results = await _db.query('UserInfo' , limit: 1 , where: 'Email = ?' , whereArgs: [email]);

    if(results!.isEmpty)
    {
      throw UserNotExists();
    }
    else
    {
      return User.fromRow(results!.first);
    }

  }

  Future<User> createUser({required int userId , required String name , required String email , required String password}) async{
    await _ensureDbIsOpen();
    Database _db = getDatabaseOrThrow();

    final results = await _db.query('UserInfo' , limit: 1 , where: 'userId = ? OR email = ?' , whereArgs: [userId , email]);

    if(results!.isNotEmpty)
      {
        throw UserAlreadyExists();
      }
    
    await db?.insert('UserInfo', { uidColumn : userId , nameColumn : name , emailColumn : email , passColumn : password });

    return User(userId: userId, username: name, email: email, password: password);
  }

  Future<void> open() async{
    if(db!=null)
      {
        throw DatabaseAlreadyOpenException();
      }
    try{
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path , dbName);
      print('--------------- $dbPath ---------------------');
      final _db = await openDatabase(dbPath);
      db = _db;

      await db?.execute(createUserTable);

      await db?.execute(createJournalTable);

      await _cacheJournal();

    }on MissingPlatformDirectoryException{
        throw UnableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async{
    final _db = db;

    if(_db == null)
      {
        throw DatabaseIsNotOpen();
      }
    else
      {
        await _db.close();
        db = null;
      }

  }

  Future<void> deleteUser({required int userId}) async{
    await _ensureDbIsOpen();
    Database _db = getDatabaseOrThrow();

    final deleteCount = await _db.delete('UserInfo' , where: 'userId = ?' , whereArgs: [userId]);

    if(deleteCount != 1)
      {
        throw CouldNotDeleteUser();
      }
  }

  Future<void> _ensureDbIsOpen() async{
    try{
      await open();
    }on DatabaseAlreadyOpenException {}
  }
}

// Entity Classes

class User {
  final int userId;
  final String username;
  final String email;
  final String password;

  const User({required this.userId , required this.username , required this.email , required this.password});

  User.fromRow(Map<String, Object?> map) : userId = map[uidColumn] as int , username = map[nameColumn] as String , email = map[emailColumn] as String , password = map[passColumn] as String;

  @override
  String toString() => 'UserId : $userId , UserName : $username , EmailId : $email , Password : $password';

  @override
  bool operator ==(covariant User other) => this.userId == other.userId;
}

class Journal {

  final int id;
  final int userId ;
  final String title;
  final String subTitle;
  final String content;
  final String dateAndtime;

  const Journal({required this.id , required this.userId , required this.title , required this.subTitle , required this.content , required this.dateAndtime});

  Journal.fromRow(Map<String,Object?> map) : id = map[nid] as int , userId = map[uidColumn] as int , title = map[titleColumn] as String  , subTitle = map[subColumn] as String  , content = map[contentColumn] as String  , dateAndtime = map[dateColumn] as String;

  @override
  String toString() {
    return 'NoteId : $id , Title : $title , SubTitle : $subTitle , content : $content' ;
  }

  @override
  bool operator ==(covariant Journal other) => this.id == other.id;

}

// All Constants
const createUserTable = ''' 
       CREATE TABLE IF NOT EXISTS "UserInfo" (
      "UserId"	INTEGER NOT NULL UNIQUE,
      "Name"	TEXT,
      "Email"	TEXT,
      "Password"	TEXT NOT NULL,
      PRIMARY KEY("UserId")
    );
       ''';
const createJournalTable = '''
          CREATE TABLE IF NOT EXISTS "Journal" (
          "NoteId"	INTEGER NOT NULL UNIQUE,
          "UserId"	INTEGER NOT NULL,
          "Title"	TEXT,
          "SubTitle"	TEXT,
          "Content"	TEXT,
          "DateAndTime"	TEXT NOT NULL,
          FOREIGN KEY("UserId") REFERENCES "UserInfo"("UserId"),
          PRIMARY KEY("NoteId" AUTOINCREMENT)
        ); ''';
const dbName = 'ReflectMe';
const String uidColumn = 'UserId';
const String nameColumn = 'Name';
const String emailColumn = 'Email';
const String passColumn = 'Password';
const String nid = 'NoteId';
const String titleColumn = 'Title';
const String subColumn = 'SubTitle';
const String contentColumn = 'Content';
const String dateColumn = 'DateAndTime';