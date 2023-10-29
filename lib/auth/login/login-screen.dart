import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/auth/register/register-screen.dart';
import 'package:to_do/dialog-utils.dart';
import 'package:to_do/firebase-utils.dart';
import 'package:to_do/home/home-screen.dart';

import '../../component/custom-text-form-field.dart';
import '../../providers/auth-provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController(text: 'mira@gmail.com');

  var passwordController = TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/SIGN IN – 1.png',
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.33,
                      ),
                      CustomTextFormField(
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter email address';
                          }
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(text);
                          if (!emailValid) {
                            return "please enter valid email";
                          }
                          return null;
                        },
                      ),
                      CustomTextFormField(
                        label: 'Password',
                        keyboardType: TextInputType.number,
                        controller: passwordController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter password';
                          }
                          if (text.length < 6) {
                            return 'password must be at least 6 chars';
                          }
                          return null;
                        },
                        isPassword: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            login();
                          },
                          child: Text(
                            'Login',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10)),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                          Text(
                            "Don't have an account ?",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RegisterScreen.routeName);
                              },
                              child: Text(
                                'SignUp',
                                style: TextStyle(fontSize: 18),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void login() async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context, 'loading...');
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? '');
        if (user == null) {
          return;
        }
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(user);

        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'login successfully',
            posActionName: 'ok', posAction: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }, title: 'success');
        print('success');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context, 'No user found for that email.',
              title: 'Error', posActionName: 'ok');
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context, 'Wrong password provided for that user.',
              title: 'Error', posActionName: 'ok');
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, '${e.toString()}',
            title: 'Error', posActionName: 'ok');
        print(e.toString());
      }
    }
  }
}
