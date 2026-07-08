class ServerException implements Exception {
  final String message;
  ServerException({required this.message});

  @override
  String toString() {
    return message;
  }
}

/// Được ném khi API trả về 401 (hết token).
/// ProductCubit sẽ catch exception này và KHÔNG emit gì cả,
/// vì AuthCubit đã gọi forceLogout() và lo toàn bộ việc navigate về Login.
class UnauthorizedException implements Exception {
  const UnauthorizedException();

  @override
  String toString() => 'UnauthorizedException: Phiên đăng nhập đã hết hạn.';
}
