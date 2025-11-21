class LoginState {
  final bool isLoading;
  final String? emailError;
  final String? passwordError;
  final String? generalError;

  const LoginState({
    this.isLoading = false,
    this.emailError,
    this.passwordError,
    this.generalError,
  });

  LoginState copyWith({
    bool? isLoading,
    String? emailError,
    String? passwordError,
    String? generalError,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      emailError: emailError,
      passwordError: passwordError,
      generalError: generalError,
    );
  }
}
