final String tableVisitors = 'visitors';


class VisitorFields{
  static final String id = '_id';
  static final String eventId = 'eventId';
  static final String visitorId = 'visitorId';
  static final String organization = 'organization';
  static final String door = 'door';
  static final String direction = 'direction';
  static final String scannerVersion = 'scannerVersion';
  static final String deviceId = 'deviceId';
  static final String deviceLocation = 'deviceLocation';
  static final String bookingOverride = 'bookingOverride';
  static final String capacityOverride = 'capacityOverride';

}

class Visitor{
  final int? id;
  final int eventId;
  final int visitorId;
  final String organization;
  final String door;
  final String direction;
  final String scannerVersion;
  final String deviceId;
  final String deviceLocation;
  final bool bookingOverride;
  final bool capacityOverride;



  const Visitor({
    this.id,
    required this.eventId,
    required this.visitorId,
    required this.organization,
    required this.door,
    required this.direction,
    required this.scannerVersion,
    required this.deviceId,
    required this.deviceLocation,
    required this.bookingOverride,
    required this.capacityOverride,
  });

  Visitor copy({
    int? id,
    int? eventId,
    int? visitorId,
    String? organization,
    String? door,
    String? direction,
    String? scannerVersion,
    String? deviceId,
    String? deviceLocation,
    bool? bookingOverride,
    bool? capacityOverride,
  }) =>
      Visitor(
        id: id ?? this.id,
        eventId: eventId ?? this.eventId,
        visitorId: visitorId ?? this.visitorId,
        organization: organization ?? this.organization,
        door: door ?? this.door,
        direction: direction ?? this.direction,
        scannerVersion: scannerVersion ?? this.scannerVersion,
        deviceId: deviceId ?? this.deviceId,
        deviceLocation: deviceLocation ?? this.deviceLocation,
        bookingOverride: bookingOverride ?? this.bookingOverride,
        capacityOverride: capacityOverride ?? this.capacityOverride,
      );

  ///converts JSON to Visitor object
  static Visitor fromJson(Map<String, Object?>json)=> Visitor(
    id: json[VisitorFields.id] as int?,
    eventId: json[VisitorFields.eventId] as int,
    visitorId: json[VisitorFields.visitorId] as int,
    organization: json[VisitorFields.organization] as String,
    door: json[VisitorFields.door] as String,
    direction: json[VisitorFields.direction] as String,
    scannerVersion: json[VisitorFields.scannerVersion] as String,
    deviceId: json[VisitorFields.deviceId] as String,
    deviceLocation: json[VisitorFields.deviceLocation] as String,
    bookingOverride: json[VisitorFields.bookingOverride] == 1,
    capacityOverride: json[VisitorFields.capacityOverride] == 1,
  );

  /// Convert a Visitor into JSON. The keys are the columns in the db table
  Map<String, dynamic> toJson() => {
      VisitorFields.id: id,
      VisitorFields.eventId: eventId,
      VisitorFields.visitorId: visitorId,
      VisitorFields.organization: organization,
      VisitorFields.door: door,
      VisitorFields.direction: direction,
      VisitorFields.scannerVersion: scannerVersion,
      VisitorFields.deviceId: deviceId,
      VisitorFields.deviceLocation: deviceLocation,
      VisitorFields.bookingOverride: bookingOverride? 1 : 0,
      VisitorFields.capacityOverride: capacityOverride? 1 : 0,

    };

  //@override
  String toString() => 'Visitor{id: $id, eventId: $eventId, visitorID: $visitorId, Organization: $organization, '
        'door: $door, direction:$direction, scannerVersion: $scannerVersion, deviceId: $deviceId,'
        ' deviceLocation: $deviceLocation, bookingOverride: $bookingOverride, capacityOverride: $capacityOverride }\n';


}