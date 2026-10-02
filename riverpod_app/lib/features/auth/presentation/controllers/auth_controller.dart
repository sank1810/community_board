import 'dart:async';

import 'package:core/errors.dart';
import 'package:core/usecase.dart';
import 'package:domain/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/auth_providers.dart';

part 'auth_controller.g.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState._({required this.status, this.user});

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated(UserEntity user)
    : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final UserEntity? user;

  @override
  List<Object?> get props => [status, user];
}

@riverpod
class AuthController extends _$AuthController {
  StreamSubscription<UserEntity?>? _authStateSubscription;

  @override
  AuthState build() {
    final repo = ref.watch(authRepositoryProvider);

    _authStateSubscription = repo.onAuthStateChanged.listen((user) {
      state = user == null
          ? const AuthState.unauthenticated()
          : AuthState.authenticated(user);
    });

    ref.onDispose(() {
      _authStateSubscription?.cancel();
      _authStateSubscription = null;
    });

    return const AuthState.unknown();
  }

  Future<Either<Failure, void>> logout() async {
    final usecase = ref.read(logoutUseCaseProvider);
    return await usecase(const NoParams());
  }
}
