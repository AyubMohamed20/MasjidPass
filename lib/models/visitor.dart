final String tableVisitors = 'visitors';

class VisitorFields{
  static final String id = '_id';
  static final String registrationId = 'registrationId';
  static final String firstName = 'organizationId';
  static final String lastName = 'eventDateTime';
  static final String email = 'hall';
  static final String phoneNumber = 'capacity';
  static final String address = 'address';
  static final String isMale = 'isMale';
  static final String registrationTime = 'registrationTime';

}

class Visitor{
  final int? id;
  final int registrationId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;
  final bool isMale;
  final DateTime registrationTime;


  const Visitor({
    this.id,
    required this.registrationId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.isMale,
    required this.registrationTime,
  });

  Visitor copy({
    int? id,
    int? registrationId,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? address,
    bool? isMale,
    DateTime? registrationTime,
  }) =>
      Visitor(
        id: id ?? this.id,
        registrationId: registrationId ?? this.registrationId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address ?? this.address,
        isMale: isMale ?? this.isMale,
        registrationTime: registrationTime ?? this.registrationTime,
      );

  ///converts JSON to Visitor object
  static Visitor fromJson(Map<String, Object?>json)=> Visitor(
    id: json[VisitorFields.id] as int?,
    registrationId: json[VisitorFields.registrationId] as int,
    firstName: json[VisitorFields.firstName] as String,
    lastName: json[VisitorFields.lastName] as String,
    email: json[VisitorFields.email] as String,
    phoneNumber: json[VisitorFields.phoneNumber] as String,
    address: json[VisitorFields.address] as String,
    isMale: json[VisitorFields.isMale] == 1,
    registrationTime: DateTime.parse(json[VisitorFields.registrationTime] as String),
  );

  /// Convert a Visitor into JSON. The keys are the columns in the db table
  Map<String, dynamic> toJson() {
    return {
      VisitorFields.id: id,
      VisitorFields.registrationId: registrationId,
      VisitorFields.firstName: firstName,
      VisitorFields.lastName: lastName,
      VisitorFields.email: email,
      VisitorFields.phoneNumber: phoneNumber,
      VisitorFields.address: address,
      VisitorFields.isMale: isMale? 1 : 0,
      VisitorFields.registrationTime: registrationTime.toIso8601String(),
    };
  }


}