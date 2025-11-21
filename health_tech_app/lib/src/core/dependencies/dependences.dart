import 'package:get_it/get_it.dart';

export 'package:get_it/get_it.dart';

/// Abstract base class for feature dependency injection setup.
///
/// This class provides a structured approach to register dependencies for a feature
/// using the GetIt service locator pattern. It enforces a layered architecture
/// by separating dependency registration into three distinct layers.
///
/// ## Usage for Junior, Mid-Level and Seniors Developers
///
/// To implement feature dependencies:
///
/// 1. **Extend this class** for each feature module:
/// ```dart
/// class AuthFeatureDependencies extends FeatureDependencies {
///   AuthFeatureDependencies(GetIt i) : super(i);
///
///   @override
///   void infra(GetIt i) {
///     // Register data sources, repositories implementations
///     i.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
///   }
///
///   @override
///   void useCases(GetIt i) {
///     // Register business logic/use cases
///     i.registerFactory<LoginUseCase>(() => LoginUseCase(i()));
///   }
///
///   @override
///   void presentation(GetIt i) {
///     // Register controllers, view models, blocs
///     i.registerFactory<LoginController>(() => LoginController(i()));
///   }
/// }
/// ```
///
/// ## Architecture Layers
///
/// - **infra**: Infrastructure layer (data sources, repositories, external services)
/// - **useCases**: Business logic layer (use cases, domain services)
/// - **presentation**: Presentation layer (controllers, view models, UI components)
///
/// The constructor automatically calls [registerDependencies] which orchestrates
/// the registration in the correct order: infra → useCases → presentation.
///
/// ## Best Practices
///
/// - Keep dependencies organized by layer
/// - Use appropriate GetIt registration methods (`registerSingleton`, `registerFactory`, etc.)
/// - Ensure proper dependency resolution order (lower layers first)
/// - Consider using interfaces/abstractions for better testability
abstract class FeatureDependencies {  
  FeatureDependencies(GetIt i) {
    registerDependencies(i);
  }
  void infra(GetIt i);
  void useCases(GetIt i);
  void presentation(GetIt i);

  void registerDependencies(GetIt i) {
    infra(i);
    useCases(i);
    presentation(i);
  }
}
