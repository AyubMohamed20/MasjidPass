class LoginResponse {
  LoginResponse({
    this.id,
    this.name,
    this.clientId,
    this.clientSecret,
  });

  int? id;
  String? name;
  String? clientId;
  String? clientSecret;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json['id'],
        name: json['name'],
        clientId: json['clientId'],
        clientSecret: json['clientSecret'],
      );
}
