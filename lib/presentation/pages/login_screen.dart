import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory/presentation/utils/input_validators.dart';
import 'package:mobile_inventory/presentation/utils/styles.dart';
import 'package:mobile_inventory/presentation/widgets/input_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? email;
  String? password;

  void login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      print("Email: $email, Password: $password");
      print("Current User: ${_auth.currentUser}");
      Navigator.restorablePushNamedAndRemoveUntil(
          context, '/dashboard', ModalRoute.withName('/dashboard'));
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Login",
                      style: headerStyle(level: 2),
                    ),
                    Container(
                      child: const Text(
                        "Login to your account",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            InputLayout(
                              "Email",
                              TextFormField(
                                onChanged: (String value) => setState(() {
                                  email = value;
                                }),
                                validator: notEmptyString,
                                decoration:
                                    customInputDecoration("email@email.com"),
                              ),
                            ),
                            InputLayout(
                              "Password",
                              TextFormField(
                                onChanged: (String value) => setState(() {
                                  password = value;
                                }),
                                validator: notEmptyString,
                                obscureText: true,
                                decoration: customInputDecoration(""),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: double.infinity,
                              child: FilledButton(
                                style: buttonStyle,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    login();
                                  }
                                },
                                child: Text(
                                  "Login",
                                  style: headerStyle(level: 3, dark: false),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum punya akun? "),
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: const Text(
                            "Daftar disini",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
