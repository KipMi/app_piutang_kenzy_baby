import 'package:app_piutang_kenzy_baby/user/user_auth/firebase_auth_implementation/firebase_auth_service.dart';
import 'package:app_piutang_kenzy_baby/widgets/NavigationButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

final _loginKey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplikasi Piutang'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _loginKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'User Login',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) =>
                        value!.isEmpty ? 'Email cannot be empty' : null,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          validator: (value) => value!.isEmpty
                              ? 'Password cannot be empty'
                              : null,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: SizedBox(
                    width: currentWidth,
                    child: ElevatedButton(
                      onPressed: signIn,
                      child: const Text('Login'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signIn() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final FirebaseAuthService _auth = FirebaseAuthService();

    try {
      final User? user =
          await _auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        context.goNamed('home');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
