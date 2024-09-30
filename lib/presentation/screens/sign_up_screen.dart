import 'package:bank_application/data/api.dart';
import 'package:bank_application/presentation/screens/otp_screen.dart';
import 'package:bank_application/presentation/screens/sign_in_screen.dart';
import 'package:bank_application/presentation/utils/assets.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/model/users.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isCheckbox = false;

  Future<void> _registerUser() async {
    Users users = Users(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    var result = await ApiService.register(users);

    if (result['status'] == 'success') {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            email: _emailController.text,
          ),
        ),
      );
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: result['status'] == 'success'
          ? Text(result['message'])
          : Text(result),
      backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
    ));
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
    return Stack(
      //mainAxisAlignment: MainAxisAlignment.center,
      //alignment: Alignment.bottomCenter,
      children: [
        SvgPicture.asset(
          Assets.imagesBackground,
        ),
        Positioned(
          top: 128,
          left: 40,
          child: Column(
            children: [
              Text(
                'Get Started',
                style: textTheme.displaySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'by creating a free account.',
                style: textTheme.titleSmall?.copyWith(color: Colors.black54),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSingInForm() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Full name',
                suffixIcon: Icon(Iconsax.profile_circle),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                suffixIcon: Icon(Iconsax.sms),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Phone Number',
                suffixIcon: Icon(Iconsax.mobile),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Phone Number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: _isCheckbox,
          onChanged: (bool? value) {
            setState(() {
              _isCheckbox = value ?? false;
            });
          },
        ),
        RichText(
            textScaler: TextScaler.noScaling,
            text: const TextSpan(
              text: 'By checking the box you agree to our ',
              style: TextStyle(color: Colors.black, fontSize: 11),
              children: [
                TextSpan(
                    text: 'Teram',
                    style: TextStyle(color: Colors.red),
                    children: [
                      TextSpan(
                          text: ' and ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Conditions',
                              style: TextStyle(color: Colors.red),
                            )
                          ])
                    ])
              ],
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
                if (_formkey.currentState!.validate()) {
                  _registerUser();
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next',
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
              text: 'Already a member? ',
              style: const TextStyle(color: Colors.black),
              children: [
                TextSpan(
                  text: 'Login in',
                  style: const TextStyle(color: Colors.red),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
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
