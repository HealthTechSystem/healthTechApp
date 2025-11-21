import 'package:flutter/foundation.dart';
import 'package:health_tech_app/src/core/infra/services/router/router_services.dart';
import 'package:health_tech_app/src/core/presentation/state/ui_state.dart';


/// Base class for all ViewModels in the application.
///
/// This abstract class provides common functionality for ViewModels including:
/// - Navigation through [RouterService]
/// - Event emission and consumption using [UiEvent]
/// - Proper disposal pattern to prevent memory leaks
///
/// ## Usage
///
/// Extend this class when creating ViewModels:
///
/// ```dart
/// class MyViewModel extends BaseViewModel {
///   MyViewModel({required super.routerService});
///
///   void doSomething() {
///     // Emit events to notify the UI
///     emit(SuccessEvent('Operation completed'));
///   }
///
///   @override
///   void dispose() {
///     // Clean up resources specific to this ViewModel
///     super.dispose(); // Always call super.dispose()
///   }
/// }
/// ```
///
/// ## Event Handling
///
/// Use the [UiEventBinder] mixin in your UI to handle events:
///
/// ```dart
/// class _MyWidgetState extends State<MyWidget> with UiEventBinder<MyWidget> {
///   late final MyViewModel _viewModel;
///
///   @override
///   void initState() {
///     super.initState();
///     _viewModel = MyViewModel();
///     bindUiEvents(_viewModel, onEvent: _handleCustomEvent);
///   }
///
///   @override
///   void dispose() {
///     unbindUiEvents(_viewModel);
///     super.dispose();
///   }
///
///   void _handleCustomEvent(BuildContext context, UiEvent event) {
///     // Handle custom events here
///   }
/// }
/// ```

abstract class BaseViewModel {
  /// Creates a new BaseViewModel instance.
  ///
  /// [routerService] is required for navigation functionality.
  /// The ViewModel will be ready to emit events and handle navigation.
  BaseViewModel({required this.routerService, bool neverDisposeEventNotifier = false})
    : _neverDisposeEventNotifier = neverDisposeEventNotifier;

  final RouterService routerService;
  final ValueNotifier<UiEvent?> event = ValueNotifier<UiEvent?>(null);
  bool _disposed = false;
  final bool _neverDisposeEventNotifier;

  /// Gets whether this ViewModel has been disposed.
  ///
  /// Returns `true` if [dispose] has been called, `false` otherwise.
  /// Use this to check if the ViewModel is still valid before performing operations.
  bool get isDisposed => _disposed;

  /// Emits a UI event to notify listeners.
  ///
  /// [e] The event to emit. Will be ignored if the ViewModel is disposed.
  ///
  /// Events are used to communicate one-time actions from the ViewModel to the UI,
  /// such as showing snackbars, navigating, or displaying dialogs.
  ///
  /// Example:
  /// ```dart
  /// emit(ErrorEvent('Something went wrong'));
  /// emit(NavigationEvent('/home'));
  /// ```
  @protected
  void emit(UiEvent e) {
    if (_disposed) return;
    event.value = e;
  }

  /// Consumes the current event by setting it to null.
  ///
  /// Call this method after handling an event to prevent it from being
  /// processed multiple times. Will be ignored if the ViewModel is disposed.
  ///
  /// Example:
  /// ```dart
  /// if (event is ErrorEvent) {
  ///   showErrorDialog(event.message);
  ///   viewModel.consumeEvent(); // Clear the event
  /// }
  /// ```
  void consumeEvent() {
    if (_disposed) return;
    event.value = null;
  }

  /// Disposes of this ViewModel and cleans up resources.
  ///
  /// This method:
  /// - Marks the ViewModel as disposed
  /// - Disposes the event ValueNotifier
  /// - Should be called when the ViewModel is no longer needed
  ///
  /// **Important**: Always call `super.dispose()` when overriding this method.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void dispose() {
  ///   myStreamSubscription.cancel();
  ///   super.dispose(); // Always call this
  /// }
  /// ```
  @mustCallSuper
  void dispose() {
    _disposed = true;
    if (!_neverDisposeEventNotifier) {
      event.dispose();
    }
  }
}
