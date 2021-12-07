
//addUser();
//addEvent();
//addVisitor();
//updateUser();
//displayUsers();
//displayVisitors();
//displayEvents();
//deleteUser();
//deleteEvent();

// late List<User> users;
// late List<Event> events;
// late List<Visitor> visitors;

// Future deleteUser() async {
//   int i = 16;
//   await MasjidDatabase.instance.delete(i);
// }
//
// Future deleteAll() async {
//   await MasjidDatabase.instance.deleteAll();
// }
//
// Future updateUser() async {
//   int i = 1;
//   int j = 12;
//
//   final updateUser = User(
//       id: i,
//       username: 'changed username',
//       password: 'changed password',
//       organizationId: j);
//
//   await MasjidDatabase.instance.update(updateUser);
// }
//
// Future addUser() async {
//   final testUser =
//       User(username: 'test', password: '1234', organizationId: 11);
//
//   await MasjidDatabase.instance.create(testUser);
// }
//
// Future displayUsers() async {
//   users = await MasjidDatabase.instance.readAllUsers();
//   print(users);
// }
//
// Future displayEvents() async {
//   events = await MasjidDatabase.instance.readAllEvents();
//   print(events);
// }
//
// Future deleteEvent() async {
//   int i = 16;
//   await MasjidDatabase.instance.deleteEvent(1);
// }
//
// Future addEvent() async {
//   final testEvent = Event(
//     organizationId: 1,
//     eventDateTime: DateTime.now(),
//     hall: 'north',
//     capacity: 100,
//   );
//
//   await MasjidDatabase.instance.createEvent(testEvent);
// }
//
// Future addVisitor() async {
//   final testVisitor = Visitor(
//     eventId: 2,
//     visitorId: 1,
//     organization: 'Spiral Forge',
//     door: '',
//     direction: '',
//     scannerVersion: '1.0',
//     deviceId: '',
//     deviceLocation: '',
//     bookingOverride: true,
//     capacityOverride: false,
//   );
//
//   await MasjidDatabase.instance.createVisitor(testVisitor);
// }
//
// Future displayVisitors() async {
//   visitors = await MasjidDatabase.instance.readAllVisitors();
//   print(visitors);
// }
//
