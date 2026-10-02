import 'package:data_supabase/auth.dart';
import 'package:domain/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/supabase_providers.dart';

part 'auth_providers.g.dart';

// -----------------------------------------------------------------------------
// Data Layer Providers
// -----------------------------------------------------------------------------

@riverpod
AuthRemoteDataSource authRemoteDataSouce(Ref ref) {
  return SupabaseAuthRemoteDataSource(
    supabaseClient: ref.watch(supabaseClientProvider),
  );
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    authRemoteDataSource: ref.watch(authRemoteDataSouceProvider),
  );
}

// -----------------------------------------------------------------------------
// Domain Layer Providers
// -----------------------------------------------------------------------------

@riverpod
SignupUseCase signupUseCase(Ref ref) {
  return SignupUseCase(authRepository: ref.watch(authRepositoryProvider));
}

@riverpod
LoginUseCase loginUseCase(Ref ref) {
  return LoginUseCase(authRepository: ref.watch(authRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(authRepository: ref.watch(authRepositoryProvider));
}
