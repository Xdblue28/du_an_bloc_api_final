//b2 duc data

class AuthModel {
  final String? accessToken;
  AuthModel({required this.accessToken});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final mapData = json['data'] as Map<String, dynamic>;
    return AuthModel(accessToken: mapData['access_token']?.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {'accessToken': accessToken},
    };
  }
}
//