import 'package:bank_application/presentation/screens/main_screen.dart';
import 'package:bank_application/presentation/screens/sign_up_screen.dart';
import 'package:bank_application/presentation/utils/assets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/api.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isCheckbox = false;

  Future<void> _loginUser() async {
    String email = _emailController.text;
    String pass = _passwordController.text;

    String result = await ApiService.login(email, pass);

    if (result == 'success') {
      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result),
        backgroundColor: Colors.teal,
        behavior: SnackBarBehavior.floating,
      ));
    }

    // ignore: use_build_context_synchronously

    //print(result);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _headTitle(textTheme),
              const SizedBox(height: 30),
              _buildSingInForm(),
              _buildRemeberRow()
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  Widget _headTitle(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Stack(
        //mainAxisAlignment: MainAxisAlignment.center,
        //alignment: Alignment.bottomCenter,
        children: [
          SvgPicture.asset(
            Assets.imagesBackground,
          ),
          Positioned(
            top: 130,
            left: 40,
            child: Column(
              children: [
                Text(
                  'Welcome back',
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'sign in to access your account',
                  style: textTheme.titleSmall?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSingInForm() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
                suffixIcon: Icon(Iconsax.sms),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Password',
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Password';
                }
                return null;
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRemeberRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _isCheckbox,
              onChanged: (bool? value) {
                setState(() {
                  _isCheckbox = value ?? false;
                });
              },
            ),
            const Text('Remember me')
          ],
        ),
        TextButton(
            onPressed: () {},
            child: const Text(
              'Forget password ?',
              style: TextStyle(color: Color(0xFF4596FF)),
            ))
      ],
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _loginUser();
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign In',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: 5),
                  Icon(Iconsax.arrow_right_3)
                ],
              ),
            ),
            const SizedBox(height: 16),
            RichText(
                text: TextSpan(
              text: 'New member ? ',
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: 'Register now',
                  style: const TextStyle(color: Colors.red),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
