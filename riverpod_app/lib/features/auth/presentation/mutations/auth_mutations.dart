import 'package:domain/auth.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/presentation_failure_exeption.dart';
import '../providers/auth_providers.dart';

final loginMutation = Mutation<void>();
final signupMutation = Mutation<void>();

Future<void> runLogin({
  required WidgetRef ref,
  required String email,
  required String password,
}) async {
  await loginMutation.run(ref, (tsx) async {
    final useCase = tsx.get(loginUseCaseProvider);
    final result = await useCase(LoginParams(email: email, password: password));

    result.fold(
      (failure) => throw PresentationFailureException(failure),
      (_) => null,
    );
  });
}

//PresentationFailureExeption
Future<void> runSignup({
  required WidgetRef ref,
  required String email,
  required String password,
  required String username,
}) async {
  await signupMutation.run(ref, (tsx) async {
    final usecase = tsx.get(signupUseCaseProvider);
    final result = await usecase(
      SignupParams(email: email, password: password, username: username),
    );
    result.fold(
      (failure) => throw PresentationFailureException(failure),
      (_) => null,
    );
  });
}
