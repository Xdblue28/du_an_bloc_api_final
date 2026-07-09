import 'package:hive_flutter/hive_flutter.dart';

abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);
  Future<void> deleteToken();
  String getToken();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  //luu token
  //xoa token
  //get toke
  final Box _authBox;
  AuthLocalDatasourceImpl({required this._authBox});

  @override
  Future<void> saveToken(String token) async {
    await _authBox.put('accessToken', token);
  }

  @override
  Future<void> deleteToken() async {
    await _authBox.delete('accessToken');
  }

  @override
  String getToken() {
    return _authBox.get('accessToken');
  }
}
//