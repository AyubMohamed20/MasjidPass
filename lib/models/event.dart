final String tableEvents = 'events';

class EventFields{
  static final String id = '_id';
  static final String organizationId = 'organizationId';
  static final String eventDateTime = 'eventDateTime';
  static final String hall = 'hall';
  static final String capacity = 'capacity';
}

class Event{
  final int? id;
  final int organizationId;
  final DateTime eventDateTime;
  final String hall;
  final int capacity;


  const Event({
    this.id,
    required this.organizationId,
    required this.eventDateTime,
    required this.hall,
    required this.capacity,
  });

  Event copy({
    int? id,
    int? organizationId,
    DateTime? eventDateTime,
    String? hall,
    int? capacity,
  }) =>
      Event(
        id: id ?? this.id,
        organizationId: organizationId ?? this.organizationId,
        eventDateTime: eventDateTime ?? this.eventDateTime,
        hall: hall ?? this.hall,
        capacity: capacity ?? this.capacity,
      );

  ///converts JSON to Event object
  static Event fromJson(Map<String, Object?>json)=> Event(
    id: json[EventFields.id] as int?,
    organizationId: json[EventFields.organizationId] as int,
    eventDateTime: DateTime.parse(json[EventFields.eventDateTime] as String),
    hall: json[EventFields.hall] as String,
    capacity: json[EventFields.capacity] as int,
  );

  /// Convert a Event into JSON. The keys are the columns in the db table
  Map<String, dynamic> toJson() {
    return {
      EventFields.id: id,
      EventFields.organizationId: organizationId,
      EventFields.eventDateTime: eventDateTime.toIso8601String(),
      EventFields.hall: hall,
      EventFields.capacity: capacity,
    };
  }

  //@override
 String toString() {
    return 'Event{id: $id, organizationId: $organizationId, Event Date: $eventDateTime, '
        'Hall: $hall, Capacity:$capacity}\n' ;
 }

}