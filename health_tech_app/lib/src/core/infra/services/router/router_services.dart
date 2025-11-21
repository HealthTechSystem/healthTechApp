import 'package:go_router/go_router.dart';

/// Abstract service interface for navigation and routing operations.
///
/// This service provides a unified interface for managing application navigation,
/// including programmatic navigation, route information access, and router instance
/// retrieval. Implementations should handle the underlying routing mechanism
/// while exposing these standardized methods.
///
/// Example usage:
/// ```dart
/// class MyRouterService implements RouterService {
///   @override
///   String get location => '/current/path';
///
///   @override
///   void go(String path) {
///     // Navigate to path, replacing current route
///   }
///
///   @override
///   void push(String path) {
///     // Push new route onto navigation stack
///   }
///
///   @override
///   void pop() {
///     // Remove current route from stack
///   }
///
///   @override
///   GoRouter call() {
///     // Return router instance
///   }
/// }
/// ```

abstract class RouterService {
  String get location;
  void go(String path);
  void push(String path);
  void pop();

  GoRouter call();
}

/// Implementation of [RouterService] that wraps a [GoRouter] instance.
///
/// This service provides a convenient abstraction layer over GoRouter functionality,
/// making it easier to manage navigation throughout the application.
///
/// Example usage:
/// ```dart
/// final routerService = RouterServiceImpl(myGoRouter);
///
/// // Navigate to a new route
/// routerService.go('/home');
///
/// // Push a new route onto the stack
/// routerService.push('/details');
///
/// // Go back to previous route
/// routerService.pop();
///
/// // Get current location
/// final currentPath = routerService.location;
///
/// // Access the underlying GoRouter instance
/// final goRouter = routerService();
/// ```
///
/// This implementation is particularly useful for dependency injection scenarios
/// where you want to abstract the routing logic behind an interface.

class RouterServiceImpl implements RouterService {
  RouterServiceImpl(this.router);

  final GoRouter router;

  /// Gets the current location URI as a string.
  ///
  /// Returns the complete URI of the current route including path, query parameters,
  /// and fragments.
  @override
  String get location => router.routeInformationProvider.value.uri.toString();

  /// Navigates to the specified path, replacing the current route.
  ///
  /// This method performs a "go" navigation which replaces the current route
  /// in the navigation stack with the new path.
  ///
  /// Example:
  /// ```dart
  /// routerService.go('/dashboard');
  /// ```
  ///
  /// [path] The destination path to navigate to
  @override
  void go(String path) => router.go(path);

  /// Pushes a new route onto the navigation stack.
  ///
  /// This method adds a new route on top of the current route stack,
  /// allowing users to navigate back to the previous route.
  ///
  /// Example:
  /// ```dart
  /// routerService.push('/user/profile');
  /// ```
  ///
  /// [path] The destination path to push onto the stack
  @override
  void push(String path) => router.push(path);

  /// Removes the current route from the navigation stack.
  ///
  /// This method pops the topmost route from the navigation stack,
  /// returning to the previous route. If there's no previous route,
  /// this method may close the app or show an error.
  @override
  void pop() => router.pop();

  /// Provides direct access to the underlying GoRouter instance.
  ///
  /// This method returns the GoRouter instance for advanced usage
  /// or when you need access to router methods not exposed by this service.
  ///
  /// Returns the [GoRouter] instance used by this service
  @override
  GoRouter call() => router;
}
