import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    // Create the 'users' table
    await database.execute("""CREATE TABLE users(
      userid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      name TEXT,
      email TEXT,
      phone TEXT,
      username TEXT,
      password TEXT
    )""");

    // Create the 'hairbook' table
    await database.execute("""CREATE TABLE hairbook(
      bookid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      userid INTEGER,
      appointmentdate TEXT,
      appointmenttime TEXT,
      services TEXT,
      FOREIGN KEY (userId) REFERENCES users(userid)
    )""");

    // Create the 'admin' table
    await database.execute("""CREATE TABLE admin(
      adminid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      username TEXT,
      password TEXT
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'kindacode.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<void> insertUser({
    required String name,
    required String email,
    required String phone,
    required String username,
    required String password,
  }) async {
    final database = await SQLHelper.db();
    await database.insert('users', {
      'name': name,
      'email': email,
      'phone': phone,
      'username': username,
      'password': password,
    });
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final database = await SQLHelper.db();
    return await database.query('users');
  }


  static Future<Map<String, dynamic>?> getUserByUsernameAndPassword({
    required String username,
    required String password,
  }) async {
    final database = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await database.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    // If there is a match, return the user; otherwise, return null
    return result.isNotEmpty ? result.first : null;
  }

  static Future<Map<String, dynamic>?> getUserByUserId({
    required int userId
  }) async {
    final database = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await database.query(
      'users',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    // If there is a match, return the user; otherwise, return null
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> modifyUser({
    required int userid,
    required String newName,
    required String newEmail,
    required String newPhone,
    required String newUsername,
    required String newPassword,
  }) async {
    final database = await SQLHelper.db();
    await database.update(
      'users',
      {
        'name': newName,
        'email': newEmail,
        'phone': newPhone,
        'username': newUsername,
        'password': newPassword
      },
      where: 'userid = ?',
      whereArgs: [userid]
    );
  }

  static Future<void> deleteUser({
    required int userid,
  }) async {
    final database = await SQLHelper.db();
    await database.delete(
      'users',
      where: 'userid = ?',
      whereArgs: [userid],
    );
  }

  static Future<void> modifyUserName({
    required int userId,
    required String newName,
  }) async {
    final database = await SQLHelper.db();
    await database.update(
      'users',
      {'name': newName},
      where: 'userid = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> modifyUserEmail({
    required int userId,
    required String newEmail,
  }) async {
    final database = await SQLHelper.db();
    await database.update(
      'users',
      {'email': newEmail},
      where: 'userid = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> modifyUserPhone({
    required int userId,
    required String newPhone,
  }) async {
    final database = await SQLHelper.db();
    await database.update(
      'users',
      {'phone': newPhone},
      where: 'userid = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> modifyUserUsername({
    required int userId,
    required String newUsername,
  }) async {
    final database = await SQLHelper.db();
    await database.update(
      'users',
      {'username': newUsername},
      where: 'userid = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> modifyUserPassword({
    required int userId,
    required String newPassword,
  }) async {
    final database = await SQLHelper.db();
    await database.update(
      'users',
      {'password': newPassword},
      where: 'userid = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> createHairbook({
    required int userId,
    required String appointmentDate,
    required String appointmentTime,
    required String services,
  }) async {
    final database = await SQLHelper.db();
    await database.insert('hairbook', {
      'userId': userId,
      'appointmentdate': appointmentDate,
      'appointmenttime': appointmentTime,
      'services': services,
    });
  }

  static Future<List<Map<String, dynamic>>> getAllHairbooks() async {
    final database = await SQLHelper.db();
    return await database.query('hairbook');
  }

  static Future<void> modifyHairbook({
    required int bookid,
    required String appointmentdate,
    required String appointmenttime,
    required String services,
  }) async {
    final database = await SQLHelper.db();
    await database.update(
      'hairbook',
      {
        'appointmentdate': appointmentdate,
        'appointmenttime': appointmenttime,
        'services': services,
      },
      where: 'bookid = ?',
      whereArgs: [bookid]
    );
  }

  static Future<void> insertAdmin({
    required String username,
    required String password,
  }) async {
    final database = await SQLHelper.db();
    await database.insert('admin', {
      'username': username,
      'password': password,
    });
  }

  static Future<void> deleteHairbook({
    required int bookId,
  }) async {
    final database = await SQLHelper.db();
    await database.delete(
      'hairbook',
      where: 'bookid = ?',
      whereArgs: [bookId],
    );
  }

  static Future<List<Map<String, dynamic>>> getHairbooksByUser({
    required int userId,
  }) async {
    final database = await SQLHelper.db();
    return await database.query(
      'hairbook',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  static Future<void> modifyHairbookAppointmentDate({
    required int bookId,
    required String newAppointmentDate,
  }) async {
    final database = await SQLHelper.db();
    await database.update(
      'hairbook',
      {'appointmentdate': newAppointmentDate},
      where: 'bookid = ?',
      whereArgs: [bookId],
    );
  }

  static Future<void> modifyHairbookAppointmentTime({
    required int bookId,
    required String newAppointmentTime,
  }) async {
    final database = await SQLHelper.db();
    await database.update(
      'hairbook',
      {'appointmenttime': newAppointmentTime},
      where: 'bookid = ?',
      whereArgs: [bookId],
    );
  }

  static Future<void> modifyHairbookServices({
    required int bookId,
    required String newServices,
  }) async {
    final database = await SQLHelper.db();
    await database.update(
      'hairbook',
      {'services': newServices},
      where: 'bookid = ?',
      whereArgs: [bookId],
    );
  }

  static Future<Map<String, dynamic>?> isAdmin({
    required String username,
    required String password,
  }) async {
    final database = await SQLHelper.db();
    final List<Map<String, dynamic>> result = await database.query(
      'admin',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    // Return true if there is a match (user is an admin), otherwise, return false
    return result.isNotEmpty ? result.first : null;
  }
  // Other methods below...
}
