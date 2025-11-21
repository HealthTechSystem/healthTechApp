/// A sealed-like state management class that represents different states of a view model operation.
///
/// This class follows a functional programming approach to handle asynchronous operations
/// that can result in success, error, loading, or initial states. It's particularly useful
/// for managing UI states in Flutter applications.
///
/// Type parameters:
/// * [E] - The error type that will be returned on failure
/// * [S] - The success type that will be returned on successful operations
///
/// Example usage:
/// ```dart
/// // Define your state types
/// ViewModelState<String, List<User>> userState = InitialState<String, List<User>>();
///
/// // Check state type
/// if (userState.isLoading) {
///   // Show loading indicator
/// }
///
/// // Use fold to handle all states
/// return userState.fold(
///   onInitial: () => Text('No data loaded yet'),
///   onLoading: () => CircularProgressIndicator(),
///   onSuccess: (users) => ListView.builder(...),
///   onError: (error) => Text('Error: $error'),
/// );
///
/// // Map success data to another type
/// ViewModelState<String, int> userCountState = userState.map((users) => users.length);
/// ```
class ViewModelState<E, S> {
  /// Creates a ViewModelState with optional success and error values.
  ///
  /// This constructor is typically not called directly. Instead, use the
  /// concrete subclasses: [InitialState], [LoadingState], [SuccessState], or [ErrorState].
  ViewModelState(this._success, this._error);

  final S? _success;
  final E? _error;

  /// Returns true if this state represents the initial state before any operation.
  bool get isInitial => this is InitialState<E, S>;

  /// Returns true if this state represents an ongoing loading operation.
  bool get isLoading => this is LoadingState<E, S>;

  /// Returns true if this state represents a successful operation with data.
  bool get isSuccess => this is SuccessState<E, S>;

  /// Returns true if this state represents a failed operation with an error.
  bool get isError => this is ErrorState<E, S>;

  /// Returns the success value if this is a [SuccessState], otherwise returns null.
  ///
  /// This is a safe way to extract success data without casting.
  S? get successOrNull => this is SuccessState<E, S> ? (this as SuccessState<E, S>).success : null;

  /// Returns the error value if this is an [ErrorState], otherwise returns null.
  ///
  /// This is a safe way to extract error data without casting.
  E? get errorOrNull => this is ErrorState<E, S> ? (this as ErrorState<E, S>).error : null;

  /// Maps the success value to another type if this is a [SuccessState].
  ///
  /// Returns the result of [fn] applied to the success value, or null if this
  /// is not a success state.
  ///
  /// Example:
  /// ```dart
  /// ViewModelState<String, List<User>> state = SuccessState([user1, user2]);
  /// int? count = state.mapSuccess((users) => users.length); // Returns 2
  /// ```
  T? mapSuccess<T>(T Function(S) fn) => isSuccess ? fn((this as SuccessState<E, S>).success) : null;

  /// Maps the error value to another type if this is an [ErrorState].
  ///
  /// Returns the result of [fn] applied to the error value, or null if this
  /// is not an error state.
  ///
  /// Example:
  /// ```dart
  /// ViewModelState<Exception, String> state = ErrorState(Exception('Failed'));
  /// String? message = state.mapError((error) => error.toString());
  /// ```
  T? mapError<T>(T Function(E) fn) => isError ? fn((this as ErrorState<E, S>).error) : null;

  /// Transforms the success type of this state while preserving the state type.
  ///
  /// This method applies the [onSuccess] function to the success value if this
  /// is a [SuccessState], and returns a new state with the transformed value.
  /// For other states, it returns the equivalent state with the new type.
  ///
  /// Example:
  /// ```dart
  /// ViewModelState<String, List<User>> userState = SuccessState([user1, user2]);
  /// ViewModelState<String, int> countState = userState.map((users) => users.length);
  /// ```
  ViewModelState<E, T> map<T>(T Function(S) onSuccess) {
    if (this is SuccessState<E, S>) {
      final v = (this as SuccessState<E, S>).success;
      return SuccessState<E, T>(onSuccess(v));
    }
    if (this is LoadingState<E, S>) return LoadingState<E, T>();
    if (this is InitialState<E, S>) return InitialState<E, T>();
    final err = (this as ErrorState<E, S>).error;
    return ErrorState<E, T>(err);
  }

  /// Folds this state into a single value by providing handlers for each possible state.
  ///
  /// This is the recommended way to handle all possible states exhaustively.
  /// Each handler function will be called based on the current state type.
  ///
  /// Parameters:
  /// * [onInitial] - Called when the state is [InitialState]
  /// * [onLoading] - Called when the state is [LoadingState]
  /// * [onSuccess] - Called when the state is [SuccessState], receives the success value
  /// * [onError] - Called when the state is [ErrorState], receives the error value
  ///
  /// Example:
  /// ```dart
  /// Widget buildUI(ViewModelState<String, List<User>> state) {
  ///   return state.fold(
  ///     onInitial: () => Text('Welcome! Tap to load users'),
  ///     onLoading: () => CircularProgressIndicator(),
  ///     onSuccess: (users) => ListView(children: users.map(buildUserTile).toList()),
  ///     onError: (error) => Text('Failed to load users: $error'),
  ///   );
  /// }
  /// ```
  T fold<T>({
    required T Function() onInitial,
    required T Function() onLoading,
    required T Function(S) onSuccess,
    required T Function(E) onError,
  }) {
    if (isInitial) return onInitial();
    if (isLoading) return onLoading();
    if (isSuccess) return onSuccess((this as SuccessState<E, S>).success);
    return onError((this as ErrorState<E, S>).error);
  }
}

/// Represents the initial state before any operation has been performed.
///
/// This state indicates that no data has been loaded and no operation
/// is currently in progress.
///
/// Example:
/// ```dart
/// ViewModelState<String, List<User>> state = InitialState<String, List<User>>();
/// ```
class InitialState<E, S> extends ViewModelState<E, S> {
  InitialState() : super(null, null);
}

/// Represents a loading state where an operation is currently in progress.
///
/// This state indicates that an asynchronous operation is running and
/// the result is not yet available.
///
/// Example:
/// ```dart
/// ViewModelState<String, List<User>> state = LoadingState<String, List<User>>();
/// ```
class LoadingState<E, S> extends ViewModelState<E, S> {
  LoadingState() : super(null, null);
}

/// Represents a successful state containing the result data.
///
/// This state indicates that an operation completed successfully and
/// contains the resulting data.
///
/// Example:
/// ```dart
/// List<User> users = [user1, user2, user3];
/// ViewModelState<String, List<User>> state = SuccessState<String, List<User>>(users);
/// ```
class SuccessState<E, S> extends ViewModelState<E, S> {
  SuccessState(S success) : super(success, null);

  /// Gets the success value. This getter is safe to use since [SuccessState]
  /// guarantees that the success value is not null.
  S get success => _success!;
}

/// Represents an error state containing the error information.
///
/// This state indicates that an operation failed and contains
/// the error details.
///
/// Example:
/// ```dart
/// String errorMessage = 'Failed to load users from server';
/// ViewModelState<String, List<User>> state = ErrorState<String, List<User>>(errorMessage);
/// ```
class ErrorState<E, S> extends ViewModelState<E, S> {
  ErrorState(E error) : super(null, error);

  /// Gets the error value. This getter is safe to use since [ErrorState]
  /// guarantees that the error value is not null.
  E get error => _error!;
}
