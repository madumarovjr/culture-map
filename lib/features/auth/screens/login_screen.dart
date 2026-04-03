import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/app_theme.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final loginFormProvider = StateNotifierProvider<LoginFormNotifier, LoginFormState>(
  (ref) => LoginFormNotifier(ref),
);

class LoginFormState {
  final String email;
  final String password;
  final bool isLoading;
  final String? error;
  final bool isSignUp;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.error,
    this.isSignUp = false,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? error,
    bool? isSignUp,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSignUp: isSignUp ?? this.isSignUp,
    );
  }
}

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Ref ref;

  LoginFormNotifier(this.ref) : super(const LoginFormState());

  void setEmail(String email) => state = state.copyWith(email: email, error: null);
  void setPassword(String password) => state = state.copyWith(password: password, error: null);
  void toggleMode() => state = state.copyWith(isSignUp: !state.isSignUp, error: null);

  Future<bool> submit() async {
    if (state.email.isEmpty || state.password.isEmpty) {
      state = state.copyWith(error: 'Please fill in all fields');
      return false;
    }
    if (state.password.length < 6) {
      state = state.copyWith(error: 'Password must be at least 6 characters');
      return false;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final auth = ref.read(firebaseAuthProvider);
      if (state.isSignUp) {
        await auth.createUserWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
      } else {
        await auth.signInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
      }
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Authentication failed';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email is already registered';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak';
          break;
      }
      state = state.copyWith(isLoading: false, error: errorMessage);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'An error occurred. Please try again.');
      return false;
    }
  }

  Future<bool> signInAnonymously() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final auth = ref.read(firebaseAuthProvider);
      await auth.signInAnonymously();
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Anonymous sign-in failed');
      return false;
    }
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormProvider);
    final formNotifier = ref.read(loginFormProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.account_balance,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'CultureMap',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preserve. Explore. Connect.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.sdgOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '11',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Aligned with SDG 11',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          formState.isSignUp ? 'Create Account' : 'Welcome Back',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _emailController,
                          onChanged: formNotifier.setEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          onChanged: formNotifier.setPassword,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outlined),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (formState.error != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.error.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppTheme.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    formState.error!,
                                    style: const TextStyle(
                                      color: AppTheme.error,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: formState.isLoading
                              ? null
                              : () async {
                                  await formNotifier.submit();
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.white,
                          ),
                          child: formState.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  formState.isSignUp ? 'Sign Up' : 'Sign In',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: formNotifier.toggleMode,
                          child: Text(
                            formState.isSignUp
                                ? 'Already have an account? Sign In'
                                : "Don't have an account? Sign Up",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        const Divider(height: 32),
                        OutlinedButton.icon(
                          onPressed: formState.isLoading
                              ? null
                              : () async {
                                  final success = await formNotifier.signInAnonymously();
                                  if (!success && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(formState.error ?? 'Sign in failed'),
                                        backgroundColor: AppTheme.error,
                                      ),
                                    );
                                  }
                                },
                          icon: const Icon(Icons.person_outline),
                          label: const Text('Continue as Guest'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}