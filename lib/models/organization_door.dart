// To parse this JSON data, do
//
//     final organizationDoor = organizationDoorFromJson(jsonString);

import 'dart:convert';

OrganizationDoor organizationDoorFromJson(String str) => OrganizationDoor.fromJson(json.decode(str));

String organizationDoorToJson(OrganizationDoor data) => json.encode(data.toJson());

class OrganizationDoor {
  OrganizationDoor({
    required this.organizationId,
    required this.doorName,
  });

  int organizationId;
  String doorName;

  factory OrganizationDoor.fromJson(Map<String, dynamic> json) => OrganizationDoor(
    organizationId: json['organizationId'],
    doorName: json['doorName'],
  );

  Map<String, dynamic> toJson() => {
    'organizationId': organizationId,
    'doorName': doorName,
  };
}
