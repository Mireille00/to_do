import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/auth/login/login-screen.dart';
import 'package:to_do/dialog-utils.dart';
import 'package:to_do/firebase-utils.dart';
import 'package:to_do/home/home-screen.dart';
import 'package:to_do/model/my-class.dart';
import 'package:to_do/providers/auth-provider.dart';

import '../../component/custom-text-form-field.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register-screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController(text: 'mira');

  var emailController = TextEditingController(text: 'mira@gmail.com');

  var passwordController = TextEditingController(text: '123456');

  var confirmPasswordController = TextEditingController(text: '123456');

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
                        label: 'User Name',
                        controller: nameController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter userName';
                          }
                          return null;
                        },
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
                      CustomTextFormField(
                        label: 'Confirm Password',
                        keyboardType: TextInputType.number,
                        controller: confirmPasswordController,
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return 'please enter confirm password';
                          }
                          if (text != passwordController.text) {
                            return "password doesn't match";
                          }
                          return null;
                        },
                        isPassword: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            register();
                          },
                          child: Text(
                            'register',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10)),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          },
                          child: Text('Already have an account')),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context, 'loading...');
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser = MyUser(
          id: credential.user?.uid ?? '',
          name: nameController.text,
          email: emailController.text,
        );
        await FirebaseUtils.addUserToFireStore(myUser);
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(myUser);

        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, 'register successfully..',
            title: 'success', posActionName: 'ok', posAction: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });

        print('success');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        //e error
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(context, 'The password provided is too weak.',
              title: 'error', posActionName: 'ok');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessage(
              context, 'The account already exists for that email.',
              title: 'error', posActionName: 'ok');
          print('The account already exists for that email.');
        }
      } catch (e) {
        DialogUtils.hideLoading(context);
        DialogUtils.showMessage(context, '${e.toString()}',
            posActionName: 'ok', title: 'error');
        print(e);
      }
    }
  }
}
