import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../features/auth/presentation/pages/login_page.dart';
import '../../../features/auth/presentation/pages/signup_page.dart';
import '../../../features/posts/presentation/pages/post_detail_page.dart';
import '../../../features/posts/presentation/pages/post_form_page.dart';
import '../../../features/posts/presentation/pages/post_page.dart';
import '../../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../../features/profile/presentation/pages/my_profile_page.dart';
import '../../../features/profile/presentation/pages/user_profile_page.dart';
import '../../../features/search/presentation/pages/search_page.dart';
import '../../../features/splash/presentation/pages/spash_page.dart';
import '../../widgets/error_page.dart';
import '../../widgets/scaffold_with_nav_bar.dart';
import 'route_constants.dart';

part 'router_provider.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authRefresh = ValueNotifier<int>(0);
  ref.onDispose(authRefresh.dispose);

  ref.listen<AuthState>(authControllerProvider, (previous, next) {
    authRefresh.value++;
  });

  return GoRouter(
    initialLocation: RoutePaths.splash,
    refreshListenable: authRefresh,
    redirect: (context, state) {
      final authStatus = ref.read(authControllerProvider).status;
      final location = state.matchedLocation;

      final isSplash = location == RoutePaths.splash;
      final isAuthRoute =
          location == RoutePaths.login || location == RoutePaths.signup;

      if (authStatus == AuthStatus.unknown) {
        return isSplash ? null : RoutePaths.splash;
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isSplash || isAuthRoute) return RoutePaths.post;
      } else {
        if (!isAuthRoute) return RoutePaths.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) {
          return const SpashPage();
        },
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: RoutePaths.signup,
        name: RouteNames.signup,
        builder: (context, state) {
          return const SignupPage();
        },
      ),
      GoRoute(
        path: RoutePaths.postCreate,
        name: RouteNames.postCreate,
        builder: (context, state) {
          return const PostFormPage();
        },
      ),
      GoRoute(
        path: RoutePaths.userDetail,
        name: RouteNames.userDetail,
        builder: (context, state) {
          final userId = state.pathParameters['userId']!;
          return UserProfilePage(userId: userId);
        },
      ),
      GoRoute(
        path: RoutePaths.postDetail,
        name: RouteNames.postDetail,
        builder: (context, state) {
          final postId = state.pathParameters['postId']!;
          return PostDetailPage(postId: postId);
        },
        routes: [
          GoRoute(
            path: RoutePaths.postEdit,
            name: RouteNames.postEdit,
            builder: (context, state) {
              final postId = state.pathParameters['postId']!;
              return PostFormPage(postId: postId);
            },
          ),
        ],
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.post,
                name: RouteNames.post,
                builder: (context, state) {
                  return const PostPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.search,
                name: RouteNames.search,
                builder: (context, state) {
                  return const SearchPage();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                name: RouteNames.profile,
                builder: (context, state) {
                  return const MyProfilePage();
                },
                routes: [
                  GoRoute(
                    path: RoutePaths.profileEdit,
                    name: RouteNames.profileEdit,
                    builder: (context, state) {
                      return const EditProfilePage();
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return ErrorPage(error: state.error);
    },
  );
}
