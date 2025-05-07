import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zdrasti_flutter/backend/service/kuker_provider.dart';
import 'package:zdrasti_flutter/backend/supabase_client.dart';
import 'package:zdrasti_flutter/backend/service/user_service.dart';
import 'package:zdrasti_flutter/screens/welcome_screen.dart';
import 'package:zdrasti_flutter/models/user.dart' as local;
import 'package:zdrasti_flutter/screens/zdrasti_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();

  // Flutter error logging
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    debugPrint('🔥 FLUTTER ERROR: ${details.exception}');
    debugPrintStack(stackTrace: details.stack);
  };

  runApp(
    ChangeNotifierProvider(
      create: (_) => KukerProvider()..load(),
      child: const ZdrastiApp(),
    ),
  );

}

class ZdrastiApp extends StatefulWidget {
  const ZdrastiApp({super.key});

  @override
  State<ZdrastiApp> createState() => _ZdrastiAppState();
}

class _ZdrastiAppState extends State<ZdrastiApp> {
  local.User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final loadedUser = await UserService.fetchCurrentUser();
    setState(() {
      user = loadedUser;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zdrasti',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : user != null
              ? ZdrastiShell(user: user!) // ✅ Pass full user object
              : const WelcomeScreen(),
    );
  }
}