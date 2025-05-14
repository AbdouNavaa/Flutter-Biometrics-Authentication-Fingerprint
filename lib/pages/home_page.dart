import 'package:biometrics_demo/constants.dart';
import 'package:biometrics_demo/localization/app_localization.dart';
import 'package:biometrics_demo/resources/app_strings.dart';
import 'package:biometrics_demo/ui/widgets/AppWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/biometrics_helper.dart';
import '../ui/pages/notes_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showManualLogin = false;
  bool _showBiometricButton = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authenticateBiometric(); // 🔥 Lancement biométrique au démarrage
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/t5_login.png',
                width: width / 2.5,
                height: width / 2.5,
              ),
              text(
                context.tr(AppStrings.biometricAuthentication),
                textColor: appStore.textPrimaryColor,
                fontSize: 22.0,
              ),

              _isLoading
                  ? const CircularProgressIndicator()
                  : Container(
                    margin: EdgeInsets.all(24),
                    // decoration: boxDecoration(
                    //   bgColor: Theme.of(context).scaffoldBackgroundColor,
                    //   showShadow: false,
                    //   radius: 4,
                    // ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // 🔥 Formulaire de login manuel
                        EditText(
                          hint: context.tr(AppStrings.userName),
                          isPassword: false,
                          mController: _usernameController,
                        ),
                        const SizedBox(height: 16),
                        EditText(
                          hint: context.tr(AppStrings.password),
                          isPassword: false,
                          mController: _passwordController,
                          isSecure: true,
                        ),

                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            // toasty(context, t5_forgot_pswd);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                              right: 10,
                            ),
                            child: text(
                              context.tr(AppStrings.forgotPassword),
                              textColor: ColorPrimary,
                              fontSize: textSizeLargeMedium,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: GestureDetector(
                                onTap: _loginWithCredentials,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right:
                                        Directionality.of(context) ==
                                                TextDirection.rtl
                                            ? 0
                                            : 16,
                                    left:
                                        Directionality.of(context) ==
                                                TextDirection.rtl
                                            ? 16
                                            : 0,
                                  ),
                                  alignment: Alignment.center,
                                  height: width / 8,
                                  child: text(
                                    context.tr(AppStrings.login),
                                    textColor: White,
                                    isCentered: true,
                                  ),
                                  decoration: boxDecoration(
                                    bgColor: ColorPrimary,
                                    radius: 8,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _authenticateBiometric,
                              child: SvgPicture.asset(
                                'assets/images/finger.svg',
                                width: width / 8.2,
                                color: ViewColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticateBiometric() async {
    setState(() {
      _isLoading = true;
      _showBiometricButton = false;
    });

    if (!await BiometricHelper.isBiometricSupported()) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: context.tr(AppStrings.biometricNotSupported));
      return;
    }

    final availableBiometrics = await BiometricHelper.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: context.tr(AppStrings.noBiometrics));
      return;
    }

    final bool didAuthenticate = await BiometricHelper.authenticate(context);
    setState(() {
      _isLoading = false;
    });

    if (didAuthenticate && mounted) {
      // ✅ Sauvegarde l'état de connexion
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);

      // ✅ Redirection vers la page Notes
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (ctx) => const NotesPage()));
    } else {
      // ❌ Si l'utilisateur annule, on affiche le bouton pour retenter
      setState(() {
        _showBiometricButton = true;
      });
      Fluttertoast.showToast(msg: context.tr(AppStrings.biometricFailed));
    }
  }

  Future<void> _loginWithCredentials() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      // 🔒 Exemple de vérification (à remplacer par un backend)
      await Future.delayed(const Duration(seconds: 2));
      if (username == 'admin' && password == 'admin') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);

        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const NotesPage()),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: context.tr(AppStrings.invalidCredentials));
      }
    } else {
      Fluttertoast.showToast(msg: context.tr(AppStrings.fillAllFields));
    }
  }
}
