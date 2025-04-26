import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zdrasti_flutter/backend/service/user_service.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;
import 'package:zdrasti_flutter/screens/zdrasti_shell.dart';
import 'package:zdrasti_flutter/widgets/translation_bubble.dart';
import 'package:confetti/confetti.dart';

class LoginInputScreen extends StatefulWidget {
  final local.User user;

  const LoginInputScreen({super.key, required this.user});

  @override
  State<LoginInputScreen> createState() => _LoginInputScreenState();
}

class _LoginInputScreenState extends State<LoginInputScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;
  final int confettiTime = 4;

  late ConfettiController _confettiController;

  static const String emailSuccess = 'Email looks good!';
  static const String passwordSuccess = 'Password looks secure!';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _confettiController = ConfettiController(duration: Duration(seconds: confettiTime));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  String? getEmailValidation(String email) {
    if (email.isEmpty) return null;
    final regex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!regex.hasMatch(email)) return 'Invalid email format.';
    if (email.length < 6) return 'Email too short.';
    return emailSuccess;
  }

  String? getPasswordValidation(String password) {
    if (password.isEmpty) return null;
    if (password.length < 6) return 'Must be at least 6 characters.';
    if (!password.contains(RegExp(r'[A-Z]')) || !password.contains(RegExp(r'[0-9]'))) {
      return 'Add uppercase and number.';
    }
    return passwordSuccess;
  }

  bool isFormValid() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    return getEmailValidation(email) == emailSuccess &&
        getPasswordValidation(password) == passwordSuccess;
  }

  Future<void> _handleSignup() async {
    setState(() => isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // Supabase Auth: Create account
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("Signup failed. No user returned.");
      }

      // Save Supabase ID
      widget.user.id = response.user!.id;
      widget.user.email = email;
      widget.user.password = password;

      // Add to Zdrasti users table
      await UserService.createUser(widget.user);

      _confettiController.play();

      // Navigate to dashboard after short delay
      await Future.delayed(Duration(seconds: confettiTime));
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => ZdrastiShell(user: widget.user)),
          (route) => false,
        );
      }
    } on AuthException catch (e) {
      debugPrint('❌ Auth error: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message.contains('User already registered!')
            ? 'This email is already registered. Try logging in instead.'
            : 'Sign-up error: ${e.message}')),
      );
    } catch (e) {
      debugPrint('❌ Signup failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final emailValidation = getEmailValidation(email);
    final passwordValidation = getPasswordValidation(password);
    final formValid = isFormValid();

    TextStyle styleFor(String? message, String success) {
      if (message == null) return const TextStyle(fontSize: 14);
      return TextStyle(
        fontSize: 14,
        color: message == success ? Colors.green : Colors.red,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2EE),
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Enter your email and password',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 24),
                  if (formValid)
                    Center(
                      child: TranslationBubble(
                        bulgarian: 'Great! You’re good to go!',
                        nativeLanguage: '',
                        bulgarianTextStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  Center(
                    child: Image.asset(
                      'assets/images/kuker/kuker_helper.png',
                      height: 140,
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'e.g. you@example.com',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (emailValidation != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(emailValidation, style: styleFor(emailValidation, emailSuccess)),
                    ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Create Password',
                      hintText: 'Must be at least 6 characters',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  if (passwordValidation != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(passwordValidation, style: styleFor(passwordValidation, passwordSuccess)),
                    ),

                  const SizedBox(height: 32),

                  Center(
                    child: ElevatedButton(
                      onPressed: formValid && !isLoading ? _handleSignup : null,
                      child: isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Create Account'),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                numberOfParticles: 30,
                gravity: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}