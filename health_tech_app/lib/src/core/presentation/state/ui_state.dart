/// Abstract base class for UI events in the application.
///
/// This class serves as the foundation for all UI-related events that can be
/// triggered throughout the application. Extend this class to create specific
/// UI event types that can be handled by the UI event system.
///
/// Example usage:
/// ```dart
/// class CustomEvent extends UiEvent {
///   // Your custom event implementation
/// }
///
/// // In your ViewModel:
/// class MyViewModel extends BaseViewModel {
///   void triggerCustomEvent() {
///     emit(CustomEvent());
///   }
/// }
/// ```
abstract class UiEvent {}

/// Event to trigger a page change in a paginated or tabbed interface.
///
/// This event is used when you need to programmatically change the current
/// page index in components like PageView, TabBarView, or custom pagination.
///
/// Example usage:
/// ```dart
/// // In your ViewModel:
/// class MyViewModel extends BaseViewModel {
///   void goToPage(int index) {
///     emit(ChangePageEvent(index));
///   }
/// }
/// ```
///
/// Parameters:
/// - [pageIndex]: The zero-based index of the target page
class ChangePageEvent extends UiEvent {
  ChangePageEvent(this.pageIndex);

  /// The zero-based index of the page to navigate to.
  /// Must be a valid index within the available pages range.
  final int pageIndex;
}

/// Event to trigger navigation to a specific route in the application.
///
/// This event handles both push navigation (adding to navigation stack) and
/// go navigation (replacing current route). Use this for programmatic
/// navigation throughout your Flutter application.
///
/// Example usage:
/// ```dart
/// // In your ViewModel:
/// class MyViewModel extends BaseViewModel {
///   void navigateToProfile() {
///     emit(NavigateToRouteEvent('/profile')); // Push navigation
///   }
///
///   void replaceWithLogin() {
///     emit(NavigateToRouteEvent('/login', true)); // Go navigation
///   }
/// }
/// ```
///
/// Parameters:
/// - [route]: The route path to navigate to
/// - [isGo]: Whether to use go navigation instead of push (optional, defaults to false)
class NavigateToRouteEvent extends UiEvent {
  NavigateToRouteEvent(this.route, [this.isGo = false]);

  /// The route path to navigate to (e.g., '/home', '/profile/123').
  /// Should be a valid route defined in your app's routing configuration.
  final String route;

  /// Determines the navigation behavior:
  /// - `false` (default): Push navigation - adds route to the navigation stack
  /// - `true`: Go navigation - replaces the current route
  final bool isGo;
}

/// Event to display a snackbar message to the user.
///
/// This event is used to show temporary messages, notifications, or feedback
/// to users through a snackbar component. Ideal for success messages, errors,
/// or informational alerts.
///
/// Example usage:
/// ```dart
/// // In your ViewModel:
/// class MyViewModel extends BaseViewModel {
///   void saveProfile() async {
///     try {
///       await profileService.save();
///       emit(ShowSnackBarEvent('Profile updated successfully!'));
///     } catch (e) {
///       emit(ShowSnackBarEvent('Failed to save changes. Please try again.'));
///     }
///   }
/// }
/// ```
///
/// Parameters:
/// - [message]: The text message to display in the snackbar
class ShowSnackBarEvent extends UiEvent {
  ShowSnackBarEvent(this.message);

  /// The message text to be displayed in the snackbar.
  /// Keep it concise and user-friendly for better UX.
  final String message;
}

/// Event to trigger a back navigation action.
///
/// This event pops the current route from the navigation stack, effectively
/// going back to the previous screen. Equivalent to pressing the back button
/// or calling Navigator.pop().
///
/// Example usage:
/// ```dart
/// // In your ViewModel:
/// class MyViewModel extends BaseViewModel {
///   void goBack() {
///     emit(PopRouteEvent());
///   }
/// }
/// ```
///
/// Note: This event will only work if there are routes in the navigation stack
/// to pop. If called on the root route, the behavior depends on your app's
/// navigation configuration.
class PopRouteEvent extends UiEvent {}

/// Event to show a loading indicator/spinner to the user.
///
/// This event displays a loading overlay or progress indicator to provide
/// visual feedback during asynchronous operations like API calls, file uploads,
/// or data processing.
///
/// Example usage:
/// ```dart
/// // In your ViewModel:
/// class MyViewModel extends BaseViewModel {
///   void saveData() async {
///     emit(ShowLoadingEvent('Saving changes...'));
///     try {
///       await dataService.save();
///       emit(HideLoadingEvent());
///       emit(ShowSnackBarEvent('Data saved successfully!'));
///     } catch (e) {
///       emit(HideLoadingEvent());
///       emit(ShowSnackBarEvent('Failed to save data'));
///     }
///   }
/// }
/// ```
///
/// Parameters:
/// - [message]: Optional message to display with the loading indicator
class ShowLoadingEvent extends UiEvent {
  ShowLoadingEvent([this.message]);

  /// Optional message to display alongside the loading indicator.
  /// If null, a default loading message will be shown.
  final String? message;
}

/// Event to hide the loading indicator.
///
/// This event removes the loading overlay or progress indicator that was
/// previously shown with [ShowLoadingEvent]. Always call this after
/// completing asynchronous operations.
///
/// Example usage:
/// ```dart
/// // In your ViewModel:
/// class MyViewModel extends BaseViewModel {
///   void completeOperation() {
///     emit(HideLoadingEvent());
///   }
/// }
/// ```
class HideLoadingEvent extends UiEvent {}

/// Event to show a dialog to the user.
///
/// This event displays various types of dialogs including alerts, confirmations,
/// or custom content dialogs. Use this for important user interactions that
///
/// Enumeration of dialog types for [ShowDialogEvent].
///
/// Defines different types of dialogs with varying button configurations:
/// - [alert]: Single "OK" button
/// - [confirmation]: "Cancel" and "Confirm" buttons
/// - [custom]: Custom button configuration
enum DialogType {
  /// Alert dialog with a single "OK" button.
  alert,

  /// Confirmation dialog with "Cancel" and "Confirm" buttons.
  confirmation,

  /// Custom dialog with user-defined button configuration.
  custom,
}

/// Event to refresh/reload the current screen or data.
///
/// This event triggers a refresh operation on the current view, typically
/// reloading data from APIs or updating the UI state. Use this for pull-to-refresh
/// functionality or manual refresh actions.
///
/// Example usage:
/// ```dart
/// // Refresh current data
/// eventBus.fire(RefreshEvent());
///
/// // Refresh with specific target
/// eventBus.fire(RefreshEvent('user_profile'));
/// ```
///
/// Parameters:
/// - [target]: Optional target identifier for specific refresh operations
class RefreshEvent extends UiEvent {
  RefreshEvent([this.target]);

  /// Optional identifier for targeting specific refresh operations.
  /// Can be used to refresh only certain parts of the UI or specific data sets.
  final String? target;
}

/// Event to update the application theme.
///
/// This event changes the app's theme mode between light, dark, or system.
/// Useful for implementing theme switching functionality in settings.
///
/// Example usage:
/// ```dart
/// // Switch to dark theme
/// eventBus.fire(ChangeThemeEvent(ThemeMode.dark));
///
/// // Switch to system theme
/// eventBus.fire(ChangeThemeEvent(ThemeMode.system));
/// ```
///
/// Parameters:
/// - [themeMode]: The new theme mode to apply
class ChangeThemeEvent extends UiEvent {
  ChangeThemeEvent(this.themeMode);

  /// The theme mode to switch to.
  /// Can be light, dark, or system (follows device setting).
  final ThemeMode themeMode;
}

/// Flutter's ThemeMode for theme switching.
enum ThemeMode {
  /// Light theme mode.
  light,

  /// Dark theme mode.
  dark,

  /// System theme mode (follows device setting).
  system,
}

/// Event to update the UI with new data.
///
/// This event carries data updates that should be reflected in the UI.
/// Use this for real-time updates, WebSocket data, or any dynamic content changes.
///
/// Example usage:
/// ```dart
/// // Update user data
/// eventBus.fire(UpdateDataEvent({'userId': 123, 'name': 'John Doe'}));
///
/// // Update with specific identifier
/// eventBus.fire(UpdateDataEvent(newData, 'user_profile'));
/// ```
///
/// Parameters:
/// - [data]: The new data to update in the UI
/// - [identifier]: Optional identifier for targeting specific UI components
class UpdateDataEvent extends UiEvent {
  UpdateDataEvent(this.data, [this.identifier]);

  /// The new data to be reflected in the UI.
  /// Can be any type of data structure (Map, List, custom objects, etc.).
  final dynamic data;

  /// Optional identifier for targeting specific UI components or data sections.
  /// Helps in updating only relevant parts of the interface.
  final String? identifier;
}

/// Event to trigger form validation.
///
/// This event initiates validation for forms or input fields.
/// Use this to programmatically trigger validation outside of normal
/// form submission flow.
///
/// Example usage:
/// ```dart
/// // Validate entire form
/// eventBus.fire(ValidateFormEvent());
///
/// // Validate specific form section
/// eventBus.fire(ValidateFormEvent('profile_section'));
/// ```
///
/// Parameters:
/// - [formId]: Optional form identifier for targeting specific forms
class ValidateFormEvent extends UiEvent {
  ValidateFormEvent([this.formId]);

  /// Optional identifier for targeting a specific form.
  /// If null, validates the currently active form.
  final String? formId;
}

/// Event to clear form data or reset form state.
///
/// This event resets form fields to their initial state, clearing user input
/// and validation errors. Useful for "Reset" or "Clear" buttons.
///
/// Example usage:
/// ```dart
/// // Clear entire form
/// eventBus.fire(ClearFormEvent());
///
/// // Clear specific form
/// eventBus.fire(ClearFormEvent('registration_form'));
/// ```
///
/// Parameters:
/// - [formId]: Optional form identifier for targeting specific forms
class ClearFormEvent extends UiEvent {
  ClearFormEvent([this.formId]);

  /// Optional identifier for targeting a specific form.
  /// If null, clears the currently active form.
  final String? formId;
}

/// Event to display an error snackbar message to the user.
///
/// This event is specifically for showing error messages in a snackbar with
/// appropriate error styling (typically red color). Use this for error
/// notifications, validation failures, or operation failures.
///
/// Example usage:
/// ```dart
/// // In your ViewModel:
/// class MyViewModel extends BaseViewModel {
///   void saveProfile() async {
///     try {
///       await profileService.save();
///       emit(ShowSnackBarEvent('Profile updated successfully!'));
///     } catch (e) {
///       emit(ShowErrorSnackBarEvent('Failed to save profile. Please try again.'));
///     }
///   }
/// }
/// ```
///
/// Parameters:
/// - [message]: The error message to display in the snackbar
class ShowErrorSnackBarEvent extends UiEvent {
  ShowErrorSnackBarEvent(this.message);

  /// The error message text to be displayed in the snackbar.
  /// Should be clear and actionable for better user experience.
  final String message;
}

/// Event to display a warning snackbar message to the user.
///
/// This event is for showing warning messages in a snackbar with
/// appropriate warning styling (typically orange/yellow color). Use this for
/// non-critical alerts, deprecation notices, or cautionary information.
///
/// Example usage:
/// ```dart
/// // In your ViewModel:
/// class MyViewModel extends BaseViewModel {
///   void checkDataLimit() {
///     if (dataUsage > 0.8) {
///       emit(ShowWarningSnackBarEvent('You are approaching your data limit.'));
///     }
///   }
///
///   void validateInput(String input) {
///     if (input.length > maxLength) {
///       emit(ShowWarningSnackBarEvent('Input is too long and will be truncated.'));
///     }
///   }
/// }
/// ```
///
/// Parameters:
/// - [message]: The warning message to display in the snackbar
class ShowWarningSnackBarEvent extends UiEvent {
  ShowWarningSnackBarEvent(this.message);

  /// The warning message text to be displayed in the snackbar.
  /// Should inform users of potential issues or important information.
  final String message;
}

/// Event to trigger a tab change in a tabbed interface.
///
/// This event is used when you need to programmatically change the current
/// tab index in components like TabBar, TabBarView, or custom tab navigation.
///
/// Example usage:
/// ```dart
/// // In your ViewModel:
/// class MyViewModel extends BaseViewModel {
///   void switchToTab(int index) {
///     emit(ChangeTabEvent(index));
///   }
/// }
/// ```
///
/// Parameters:
/// - [tabIndex]: The zero-based index of the target tab
class ChangeTabEvent extends UiEvent {
  ChangeTabEvent(this.tabIndex);

  /// The zero-based index of the tab to navigate to.
  /// Must be a valid index within the available tabs range.
  final int tabIndex;
}

// ===================================================================UI=============
// ATENÇÃO: Novos eventos de UI devem ser adicionados aqui!
// você NÃO precisa adicionar documentação para os novos eventos, não se preocupe com isso.
// Basta criar a classe do evento que estende UiEvent e adicionar aqui.
// caso você precise de ajuda, consulte a documentação dos eventos existentes como exemplo,
// ou peça ajuda a um colega de equipe, se achar necessário que um evento específico tenha documentação
// ou arquivo separado sinta-se à vontade para criá-la normalmente, mas tente manter a simplicidade possível,
// e por favor, comunique à equipe sobre a necessidade de um novo evento documentado ou em arquivo separado.
// =================================================================================
