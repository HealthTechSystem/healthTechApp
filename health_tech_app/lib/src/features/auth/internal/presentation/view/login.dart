import 'package:flutter/material.dart';
import 'package:health_tech_app/src/features/auth/internal/presentation/login_state.dart';
import 'package:health_tech_app/src/features/auth/internal/presentation/view_model/login_view_model.dart';

/// login_page.dart
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<LoginViewModel>();

    return UiEventHandler(
      listenable: viewModel.uiEvents,
      child: Scaffold(
        body: ValueListenableBuilder<LoginState>(
          valueListenable: viewModel.state,
          builder: (_, state, __) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: viewModel.emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: state.emailError,
                        ),
                        onChanged: viewModel.cacheEmail,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: viewModel.passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          errorText: state.passwordError,
                        ),
                        onChanged: viewModel.cachePassword,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: state.rememberMe,
                            onChanged: viewModel.toggleRememberMe,
                          ),
                          const Text('Lembrar-me'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.onLoginPressed(),
                        child: const Text('Entrar'),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: viewModel.onLoginWithGoogle,
                        child: const Text('Entrar com Google'),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: viewModel.onLoginWithApple,
                        child: const Text('Entrar com Apple'),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () {
                          viewModel.emitUiEvent(const UiEvent.navigate("forgot_password"));
                        },
                        child: const Text('Esqueceu a senha?'),
                      )
                    ],
                  ),
                ),

                if (state.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}