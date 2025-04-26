import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;
import 'package:zdrasti_flutter/backend/service/auth_service.dart';
import 'package:zdrasti_flutter/backend/service/user_service.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;
import 'package:zdrasti_flutter/screens/zdrasti_shell.dart';

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _attemptLogin() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authUser = await AuthService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (authUser != null) {
        final local.User? appUser = await UserService.fetchCurrentUser();

        if (appUser != null && mounted) {
          Navigator.of(context).pop(); // Close dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ZdrastiShell(user: appUser),
            ),
          );
        } else {
          setState(() => _error = 'Failed to load user data from the database.');
        }
      } else {
        setState(() => _error = 'Invalid email or password.');
      }
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('invalid login credentials')) {
       setState(() => _error =  'Oops! That email or password is incorrect.');
      } else if (msg.contains('email not confirmed')) {
        setState(() => _error = 'Please check your email and confirm your account before logging in.');
      } else {
        setState(() => _error = e.message);
      }      
    } catch (e) {
      setState(() => _error = 'Something went wrong. Please try again.');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Log In'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _loading ? null : _attemptLogin,
          child: _loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Log In'),
        ),
      ],
    );
  }
}
