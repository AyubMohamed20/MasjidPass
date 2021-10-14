final String tableEvents = 'events';

class EventFields{
  static final String id = '_id';
  static final String organizationId = 'organizationId';
  static final String eventDateTime = 'eventDateTime';
  static final String hall = 'hall';
  static final String capacity = 'capacity';
  static final String isPrivate = 'isPrivate';
}

class Event{
  final int? id;
  final int organizationId;
  final DateTime eventDateTime;
  final String hall;
  final int capacity;
  final bool isPrivate;


  const Event({
    this.id,
    required this.organizationId,
    required this.eventDateTime,
    required this.hall,
    required this.capacity,
    required this.isPrivate,
  });

  Event copy({
    int? id,
    int? organizationId,
    DateTime? eventDateTime,
    String? hall,
    int? capacity,
    bool? isPrivate,
  }) =>
      Event(
        id: id ?? this.id,
        organizationId: organizationId ?? this.organizationId,
        eventDateTime: eventDateTime ?? this.eventDateTime,
        hall: hall ?? this.hall,
        capacity: capacity ?? this.capacity,
        isPrivate: isPrivate ?? this.isPrivate,
      );

  ///converts JSON to Event object
  static Event fromJson(Map<String, Object?>json)=> Event(
    id: json[EventFields.id] as int?,
    organizationId: json[EventFields.organizationId] as int,
    eventDateTime: DateTime.parse(json[EventFields.eventDateTime] as String),
    hall: json[EventFields.hall] as String,
    capacity: json[EventFields.capacity] as int,
    isPrivate: json[EventFields.isPrivate] == 1,
  );

  /// Convert a Event into JSON. The keys are the columns in the db table
  Map<String, dynamic> toJson() {
    return {
      EventFields.id: id,
      EventFields.organizationId: organizationId,
      EventFields.eventDateTime: eventDateTime.toIso8601String(),
      EventFields.hall: hall,
      EventFields.capacity: capacity,
      EventFields.isPrivate: isPrivate? 1 : 0,
    };
  }


  //@override
 // String toString() {
    //return 'test strinnnnnnng';
    //return 'Event{id: $id, username: $username, password: $password}';
 // }

}