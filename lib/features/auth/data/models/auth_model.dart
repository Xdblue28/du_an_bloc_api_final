//b2 duc data

class AuthModel {
  final String inToken;
  AuthModel({required this.inToken});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final mapData = json['data'] as Map<String, dynamic>;
    return AuthModel(inToken: mapData['access_token']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {'accessToken': inToken},
    };
  }
}
