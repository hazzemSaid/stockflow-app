import 'package:equatable/equatable.dart';
import '../constants/app_strings.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure([String? message]) : message = message ?? AppStrings.unexpectedError;
  
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}
