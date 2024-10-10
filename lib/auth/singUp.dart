import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/auth/signIn.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class MyFormSignUp extends StatefulWidget {
  const MyFormSignUp({super.key});

  @override
  State<MyFormSignUp> createState() => _MyFormSignUpState();
}

class _MyFormSignUpState extends State<MyFormSignUp> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureTextVerify = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'enter a valid mail')
  ]);
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Passwords must have at least one special character'),
  ]);

  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sign Up ',
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
                                hintText: 'enter your email',
                                prefixIcon: Icon(Icons.email_outlined),
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color:
                                        const Color.fromARGB(255, 56, 56, 56)),
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
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.key_outlined),
                                border: OutlineInputBorder(),
                                hintText: 'enter your password',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color:
                                        const Color.fromARGB(255, 56, 56, 56)),
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
                        SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verify password',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 56, 56, 56),
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              obscureText: _obscureTextVerify,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.key_outlined),
                                border: OutlineInputBorder(),
                                hintText: 'enter your password',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100,
                                    color:
                                        const Color.fromARGB(255, 56, 56, 56)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureTextVerify
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureTextVerify = !_obscureTextVerify;
                                    });
                                  },
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Verify password is required';
                                } else if (val != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 216, 132, 5))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              try {
                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('User is added with success!'),
                                  ),
                                );
                              } on FirebaseAuthException catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Register Failed!'),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 253, 251, 251),
                            ),
                          ),
                        ),
                        SizedBox(height: 80),
                        OutlinedButton(
                          style: ButtonStyle(),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyFormSignIn()),
                            );
                          },
                          child: Text('already have a account ?'),
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
