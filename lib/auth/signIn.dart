import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyFormSignIn extends StatefulWidget {
  const MyFormSignIn({super.key});

  @override
  _MyFormSignInState createState() => _MyFormSignInState();
}

class _MyFormSignInState extends State<MyFormSignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _obscureText = true;

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(
      errorText: 'Invalid email',
    ),
  ]);
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8,
        errorText: 'Password must be at least 8 characters long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Password must have at least one special character'),
  ]);

  String password = '';
  final _auth = FirebaseAuth.instance;

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 650,
              height: screenHeight *
                  0.8, // Utilisation dynamique de la taille de l'écran
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 56, 56, 56),
                          ),
                        ),
                        SizedBox(height: 50),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 56, 56, 56),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                                prefixIcon: Icon(Icons.email_outlined),
                                hintStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w100),
                                border: OutlineInputBorder(),
                              ),
                              validator: emailValidator,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 56, 56, 56),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.key_outlined),
                                border: OutlineInputBorder(),
                                hintText: 'Enter your password',
                                hintStyle: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w100),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                              onChanged: (val) => password = val,
                              validator: passwordValidator,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 216, 132, 5))),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _emailController.text,
                                            password: password);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Logged in as ${userCredential.user!.email}'),
                                  ),
                                );
                              } on FirebaseAuthException catch (e) {
                                String errorMessage = '';
                                if (e.code == 'user-not-found') {
                                  errorMessage =
                                      'No user found for that email.';
                                } else if (e.code == 'wrong-password') {
                                  errorMessage = 'Wrong password provided.';
                                } else {
                                  errorMessage = 'Error: ${e.message}';
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMessage)),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 253, 251, 251),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        OutlinedButton(
                          style: ButtonStyle(),
                          onPressed: () async {
                            await loginWithGoogle();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  'assets/images/Google_Icons.webp',
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 216, 132, 5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
