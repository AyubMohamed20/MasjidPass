final String tableUsers = 'users';

class UserFields{
  static final String id = '_id';
  static final String username = 'username';
  static final String password = 'password';
  static final String organizationId = 'registrationId';
}

class User{
  final int? id;
  final String username;
  final String password;
  final int organizationId;

  const User({
    this.id,
    required this.username,
    required this.password,
    required this.organizationId,
  });

  User copy({
    int? id,
    String? username,
    String? password,
    int? organizationId,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        password: password ?? this.password,
        organizationId: organizationId ?? this.organizationId,
      );

  ///converts JSON to User object
  static User fromJson(Map<String, Object?>json)=> User(
    id: json[UserFields.id] as int?,
    username: json[UserFields.username] as String,
    password: json[UserFields.password] as String,
    organizationId: json[UserFields.organizationId] as int,
  );

  /// Convert a User into JSON. The keys are the columns in the db table
  Map<String, dynamic> toJson() {
    return {
      UserFields.id: id,
      UserFields.username: username,
      UserFields.password: password,
      UserFields.organizationId: organizationId,
    };
  }



  // Implement toString to make it easier to see information about
  // each user when using the print statement.
  @override
  String toString() {
    return 'User{id: $id, username: $username, password: $password, organizationId: $organizationId}\n';
  }

}