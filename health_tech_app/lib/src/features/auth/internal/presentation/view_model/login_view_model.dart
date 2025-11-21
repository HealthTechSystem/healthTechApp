import 'package:health_tech_app/src/core/infra/services/router/router_services.dart';
import 'package:health_tech_app/src/core/presentation/view_model/base_view_model.dart';
import 'package:health_tech_app/src/features/auth/external/domain/use_cases/login_patient_uc.dart';
import 'package:health_tech_app/src/features/auth/external/domain/use_cases/login_with_apple_uc.dart';
import 'package:health_tech_app/src/features/auth/external/domain/use_cases/login_with_google_uc.dart';
import 'package:health_tech_app/src/features/auth/internal/presentation/login_state.dart';

class LoginViewModel extends BaseViewModel<LoginState> {
  final LoginPatientUc _loginUc;
  final LoginWithGoogleUc _loginGoogleUc;
  final LoginWithAppleUc _loginAppleUc;
  final RouterService _router; // do core/infra/services/router

  LoginViewModel(
    this._loginUc,
    this._loginGoogleUc,
    this._loginAppleUc,
    this._router,
  ) : super(const LoginState());

  Future<void> onLoginPressed(String email, String password) async { ... }
  Future<void> onGoogleLogin() async { ... }
  Future<void> onAppleLogin() async { ... }
}
