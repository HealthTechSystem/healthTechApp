import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

/// A type alias that represents the response from an API call.
///
/// This type uses the `Either` monad from the `dartz` package to handle
/// success and failure states in a functional programming style.
///
/// **Usage:**
/// - `Left(Failure)`: Represents an error state containing failure information
/// - `Right(T)`: Represents a success state containing the expected data of type `T`
///
/// **Example:**
/// ```dart
/// // Function that returns an ApiResponse
/// ApiResponse<User> fetchUser(String id) async {
///   try {
///     final user = await userRepository.getUser(id);
///     return Right(user); // Success case
///   } catch (e) {
///     return Left(ServerFailure(message: e.toString())); // Error case
///   }
/// }
///
/// // Handling the response
/// final result = await fetchUser('123');
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (user) => print('Success: ${user.name}'),
/// );
/// ```
///
/// **Benefits:**
/// - **Type Safety**: Compile-time guarantee that both success and error cases are handled
/// - **Functional Approach**: Eliminates the need for try-catch blocks and null checks
/// - **Consistent Error Handling**: Standardized way to handle failures across the application
/// - **Composability**: Can be easily chained and transformed using functional operations
///
/// **Type Parameter:**
/// - `T`: The type of data expected on successful API response
///
/// **See also:**
/// - [Either] from `dartz` package for more functional operations
/// - [Failure] for understanding the error types that can be returned

typedef ApiResponse<T> = Either<Failure, T>;
