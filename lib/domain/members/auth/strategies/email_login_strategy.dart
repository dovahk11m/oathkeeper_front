import 'package:dio/dio.dart';

import 'login_strategy.dart';

class EmailLoginStrategy implements LoginStrategy {
  final String email;
  final String password;

  EmailLoginStrategy({required this.email, required this.password});

  @override
  Future<Response> execute(Dio dio) {
    return dio.post(
      '/member/login',
      data: {'email': email, 'password': password},
    );
  }
}
