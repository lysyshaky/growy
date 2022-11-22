import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:growy/consts/firebase_consts.dart';
import 'package:growy/screens/auth/forget_pass_screen.dart';
import 'package:growy/screens/auth/register_screen.dart';
import 'package:growy/screens/btm_bar.dart';
import 'package:growy/screens/loading_manager.dart';
import 'package:growy/widgets/text_widget.dart';

import '../../consts/consts.dart';
import '../../services/global_methods.dart';
import '../../widgets/auth_button.dart';
import 'package:growy/fetch_screen.dart';
import '../../widgets/google_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextController = TextEditingController();
  final _passTextController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _sumbitFromOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();

      try {
        await authInstance.signInWithEmailAndPassword(
            email: _emailTextController.text.toLowerCase().trim(),
            password: _passTextController.text.trim());
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: ((context) => const FetchScreen()),
          ),
        );
        //print('Succefully registered');
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              duration: 800,
              autoplayDelay: 4000,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Consts.authImagesPaths[index],
                  fit: BoxFit.cover,
                );
              },
              itemCount: Consts.authImagesPaths.length,
              autoplay: true,
            ),
            //contoller buttons for ImagesSlider
            //control: SwiperControl(),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 120.0),
                    TextWidget(
                      text: AppLocalizations.of(context)!.welcome_back,
                      color: Colors.white,
                      textSize: 30,
                      isTitle: true,
                    ),
                    const SizedBox(height: 8.0),
                    TextWidget(
                      text: AppLocalizations.of(context)!.sign_in_continue,
                      color: Colors.white,
                      textSize: 18,
                      isTitle: false,
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passFocusNode),
                            controller: _emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty || !value.contains('@')) {
                                return AppLocalizations.of(context)!
                                    .valid_email;
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!.email,
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.done,
                            onEditingComplete: () {
                              _sumbitFromOnLogin();
                            },
                            controller: _passTextController,
                            focusNode: _passFocusNode,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return AppLocalizations.of(context)!
                                    .valid_password;
                              } else {
                                return null;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.white,
                                  )),
                              hintText: AppLocalizations.of(context)!.password,
                              hintStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, ForgetPasswordScreen.routeName);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forget_password,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                              fontStyle: FontStyle.italic,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    AuthButton(
                      fct: () {
                        _sumbitFromOnLogin();
                      },
                      buttonText: AppLocalizations.of(context)!.login_btn,
                      primary: Colors.green.withOpacity(0.6),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    GoogleButton(),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        TextWidget(
                            text: AppLocalizations.of(context)!.or,
                            color: Colors.white,
                            textSize: 18),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.white,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    AuthButton(
                      fct: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const FetchScreen()));
                      },
                      buttonText:
                          AppLocalizations.of(context)!.continue_guest_btn,
                      primary: Colors.black.withOpacity(0.6),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    RichText(
                      text: TextSpan(
                          text: AppLocalizations.of(context)!.dont_have_account,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18),
                          children: [
                            TextSpan(
                                text: AppLocalizations.of(context)!.sign_up,
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    GlobalMethods.navigateToRegister(
                                        ctx: context,
                                        routeName: RegisterScreen.routeName);
                                  }),
                          ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
