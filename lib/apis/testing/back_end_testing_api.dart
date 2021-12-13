import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masjid_pass/models/event.dart';
import 'package:masjid_pass/models/organization_door.dart';

const String _url =
    'https://abd6bd3d-6282-47a0-b396-549f1e246f9d.mock.pstmn.io';


// Retrieves Organization Door for API

Future<List<OrganizationDoor>> fetchOrganizationDoor() async {
  final response = await http.get(Uri.parse(_url + '/organizationDoor'));

  if (response.statusCode == 200) {
    return parseOrganizationDoor(response.body);
  } else {
    throw Exception('Unable to fetch Organization Door from the REST API');
  }
}

List<OrganizationDoor> parseOrganizationDoor(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<OrganizationDoor>((json) => OrganizationDoor.fromJson(json)).toList();
}

// Retrieves events for API
Future<List<Event>> fetchEvents() async {
  final response = await http.get(Uri.parse(_url + '/events/today'));

  if (response.statusCode == 200) {
    return parseEvents(response.body);
  } else {
    throw Exception('Unable to fetch events from the REST API');
  }
}

List<Event> parseEvents(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Event>((json) => Event.fromJson(json)).toList();
}
