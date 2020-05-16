import 'package:chat/models/chat_model.dart';
import 'package:chat/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    return await openDatabase(join(await getDatabasesPath(), 'chat.db'),
        onCreate: (db, version) async {
      await db.execute('''CREATE TABLE `users` (
	`userId` INT(11) NOT NULL,
  'socketId' VARCHAR(150)  NULL, 
	`name` VARCHAR(50) NOT NULL,
	`avatarUrl` VARCHAR(200)  NULL,
	`userType` VARCHAR(200) NOT NULL DEFAULT 'customer',
	`isCurrentUser` TINYINT(4) NOT NULL DEFAULT '0',
	PRIMARY KEY (`userId`)
);''');

      await db.execute('''insert into "users" ("userId","name","userType","isCurrentUser") values("2","user2","customer",0) ''');
      await db.execute('''insert into "users" ("userId","name","userType","isCurrentUser") values("1","user1","customer",0) ''');

      await db.execute('''CREATE TABLE "chat" (
	"messageId"	INTEGER NOT NULL,
	"senderId"	INT(11) DEFAULT NULL,
	"receiverId"	INT(11) DEFAULT NULL,
	"text"	TEXT NOT NULL,
	"sendingTime"	VARCHAR(50) DEFAULT NULL,
	"receiveTime"	VARCHAR(50) DEFAULT NULL,
	"isSent"	TINYINT(1) DEFAULT 0,
	"isReceived"	TINYINT(1) DEFAULT 0,
	"mediaUrl"	VARCHAR(100) NOT NULL DEFAULT '0',
	PRIMARY KEY("messageId" AUTOINCREMENT)
);''');
    }, version: 1);
  }

  Future<int> addUser(UserModel newUser) async {
    final db = await database;
    await db.rawQuery('delete from users where userId ='+newUser.userId.toString() +' OR isCurrentUser=1' );
    final res = await db.insert('users', newUser.toMap());
    return res;
  }

  Future<UserModel> getCurrentUser() async {
    final db = await database;
    List<Map> res =
        await db.rawQuery('select * from users where isCurrentUser=1');
    return UserModel.fromJson(res[0]);
  }

  Future<List<Map>> getFriends() async {
    final db = await database;
    List<Map> res = await db.rawQuery('select * from users where isCurrentUser !=1 ');
    return res;
  }

  Future<List<Map>> getChats(String receiverId) async {
    final db = await database;
    List<Map> res =
        await db.rawQuery('select * from chat where receiverId = ' + receiverId);
    return res;
  }

  Future<int> addChat(ChatModel chat) async {
    final db = await database;
    final res = await db.insert('chat', chat.toMap());
    return res;
  }

  Future<List<Map>> deleteChat(String messageId) async {
    final db = await database;
    List<Map> res= await db.rawQuery('delet from chat from where messageId = ' + messageId);
    return res;
  }
}
