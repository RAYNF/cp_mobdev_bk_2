import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_inventory/presentation/utils/input_validators.dart';
import 'package:mobile_inventory/presentation/utils/styles.dart';
import 'package:mobile_inventory/presentation/widgets/input_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? nama;
  String? email;
  String? noHp;

  final TextEditingController _password = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      CollectionReference akunCollection = _db.collection('akun');

      final password = _password.text;
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password);

      final docId = akunCollection.doc().id;
      await akunCollection.doc(docId).set({
        'uid': _auth.currentUser!.uid,
        'nama': nama,
        'email': email,
        'noHP': noHp,
        'docId': docId,
        'role': 'user',
      });

      Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('/login'));
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      'Register',
                      style: headerStyle(level: 1),
                    ),
                    Container(
                      child: const Text(
                        "Create Your Profile",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            InputLayout(
                              "Nama",
                              TextFormField(
                                onChanged: (String value) => setState(() {
                                  nama = value;
                                }),
                                validator: notEmptyString,
                                decoration:
                                    customInputDecoration("Nama Lengkap"),
                              ),
                            ),
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
                              "No. Handphone",
                              TextFormField(
                                onChanged: (String value) => setState(() {
                                  noHp = value;
                                }),
                                validator: notEmptyInt,
                                decoration: customInputDecoration("08xxxxxx"),
                              ),
                            ),
                            InputLayout(
                              "Password",
                              TextFormField(
                                controller: _password,
                                validator: notEmptyString,
                                obscureText: true,
                                decoration: customInputDecoration(""),
                              ),
                            ),
                            InputLayout(
                              "Konfirmasi Password",
                              TextFormField(
                                validator: (value) =>
                                    passConfirmationValidator(value, _password),
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
                                    register();
                                  }
                                },
                                child: Text(
                                  "Register",
                                  style: headerStyle(level: 2),
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
                        const Text("Sudah punya akun? "),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            "Login di sini",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ));
  }
}
