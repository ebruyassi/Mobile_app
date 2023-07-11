import 'package:bitirme_prejem/models/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bitirme_prejem/services/auth_service.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController allergieTypeController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();

  final Auth _authService = Auth();
  bool _showPassword = true;
  double padding = 20.0;

  var phoneMaskFormater = MaskTextInputFormatter(mask: '#### ### ## ##');
  var birthdayMaskFormater = MaskTextInputFormatter(mask: '####-##-##');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ThemeText.themColor,
          title: const Text('Hesap Oluştur'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: padding),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Lütfen Adınızı Giriniz.';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[a-z A-Z]")),
                          ],
                          controller: fnameController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ThemeText.themColor),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            icon: Icon(
                              FontAwesomeIcons.solidUser,
                              size: 25,
                              color: ThemeText.themColor,
                            ),
                            hintText: 'Ad',
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Lütfen Soyadınızı Giriniz.';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-z A-Z]")),
                            ],
                            controller: lnameController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: ThemeText.themColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              hintText: 'Soyad',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: padding),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen doğum tarihinizi giriniz.';
                      }
                      return null;
                    },
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    controller: birthdayController,
                    inputFormatters: [birthdayMaskFormater],
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeText.themColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      icon: Icon(
                        FontAwesomeIcons.cakeCandles,
                        size: 25,
                        color: ThemeText.themColor,
                      ),
                      hintText: 'Doğum Tarihi',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: padding),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen Emaila adresinizi giriniz.';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-z A-Z 0-9 @ . _]")),
                    ],
                    controller: emailController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeText.themColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      icon: Icon(
                        Icons.mail,
                        size: 25,
                        color: ThemeText.themColor,
                      ),
                      hintText: 'E-mail',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: padding),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen telefon numaranızı giriniz.';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [phoneMaskFormater],
                    controller: phoneNoController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeText.themColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      icon: Icon(
                        FontAwesomeIcons.mobile,
                        size: 25,
                        color: ThemeText.themColor,
                      ),
                      hintText: 'Telefon Numarası',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: padding),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen adres bilginizi giriniz.';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-z A-Z 0-9]"))
                    ],
                    keyboardType: TextInputType.streetAddress,
                    controller: addressController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeText.themColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      icon: Icon(
                        FontAwesomeIcons.locationArrow,
                        size: 25,
                        color: ThemeText.themColor,
                      ),
                      hintText: 'Adres',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: padding),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen şifrenizi giriniz.';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("[a-z A-Z 0-9]")),
                    ],
                    obscureText: _showPassword,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeText.themColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      icon: Icon(
                        FontAwesomeIcons.lock,
                        size: 20,
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
                  padding: EdgeInsets.only(bottom: padding),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Varsa belirtmek istediğiniz sağlık verinizi giriniz';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                    ],
                    controller: allergieTypeController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ThemeText.themColor),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      icon: Icon(
                        FontAwesomeIcons.disease,
                        size: 20,
                        color: ThemeText.themColor,
                      ),
                      hintText:
                          'Sağlık verisi: Süt, Balık vb. alerjisi, kolestrol, diyabet',
                    ),
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
                    validateAndSave();
                  },
                  child: const Text("Kaydet"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      _authService.createUser(
          context,
          fnameController.text,
          lnameController.text,
          emailController.text,
          addressController.text,
          phoneNoController.text,
          passwordController.text,
          allergieTypeController.text,
          birthdayController.text);
    } else {}
  }
}
