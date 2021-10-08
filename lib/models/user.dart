final String tableUsers = 'users';

class UserFields{
  static final String id = '_id';
  static final String username = 'username';
  static final String password = 'password';
}

class User{
  final int? id;
  final String username;
  final String password;

  const User({
    this.id,
    required this.username,
    required this.password,
  });

  User copy({
    int? id,
    String? username,
    String? password,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        password: password ?? this.password,
      );

  ///converts JSON to User object
  static User fromJson(Map<String, Object?>json)=> User(
    id: json[UserFields.id] as int?,
    username: json[UserFields.username] as String,
    password: json[UserFields.password] as String,
  );

  /// Convert a User into JSON. The keys are the columns in the db table
  Map<String, dynamic> toJson() {
    return {
      UserFields.id: id,
      UserFields.username: username,
      UserFields.password: password,
    };
  }



  // Implement toString to make it easier to see information about
  // each user when using the print statement.
  @override
  String toString() {
    //return 'test strinnnnnnng';
    return 'User{id: $id, username: $username, password: $password}';
  }

}