import 'dart:convert';
import 'dart:io';
import 'package:masjid_pass/apis/responses/login_response.dart';
import 'package:masjid_pass/utilities/base_url.dart';
import 'package:http/http.dart' as http;
import 'package:masjid_pass/models/user.dart';

Future<LoginResponse> authenticateUser(String username, String password) async {
  LoginResponse _apiResponse = new LoginResponse();

  try {
    final response = await http.post(Uri.parse(baseUrlTesting + '/api/authenticate'), body: {
      'username': username,
      'password': password,
    });

    switch (response.statusCode) {
      case 200:
    //    _apiResponse.Data = User.fromJson(json.decode(response.body));
        break;
      case 401:
     //   _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
      default:
      //  _apiResponse.ApiError = ApiError.fromJson(json.decode(response.body));
        break;
    }
  } on SocketException {
    //_apiResponse.ApiError = ApiError(error: 'Server error. Please retry');
  }
  return _apiResponse;
}

class ApiError {
  late String _error;

  ApiError({required String error}) {
    this._error = error;
  }

  String get error => _error;

  set error(String error) => _error = error;

  ApiError.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    return data;
  }
}
