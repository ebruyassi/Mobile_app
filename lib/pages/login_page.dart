import 'package:bitirme_prejem/models/style.dart';
import 'package:flutter/material.dart';
import 'package:bitirme_prejem/pages/forget_password.dart';
import 'package:bitirme_prejem/pages/signin_page.dart';
import 'package:bitirme_prejem/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Auth _authservice = Auth();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool _showPassword = true;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Kullanıcı adınızı giriniz';
                      }
                      return null;
                    },
                    controller: _emailcontroller,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeText.themColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      icon: Icon(
                        Icons.mail,
                        size: 30,
                        color: ThemeText.themColor,
                      ),
                      hintText: 'Mail',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Şifrenizi giriniz';
                        }
                        return null;
                      },
                      obscureText: _showPassword,
                      controller: _passwordcontroller,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ThemeText.themColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        icon: Icon(
                          Icons.lock,
                          size: 30,
                          color: ThemeText.themColor,
                        ),
                        hintText: 'Şifre',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _togglevisibility();
                          },
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextButton(
                      child: const Text(
                        'Şifremi Unuttum.',
                        style: TextStyle(
                            fontSize: 15, color: Color.fromARGB(162, 0, 0, 0)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const ForgetPassword(),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeText.themColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 20),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      _authservice.signIn(_emailcontroller.text,
                          _passwordcontroller.text, context);
                    },
                    child: const Text("Giriş"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Hesabın yok mu? ',
                        style: TextStyle(
                            fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      TextButton(
                        child: const Text(
                          'Hesap Oluştur.',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(162, 0, 0, 0)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const SignInPage(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
