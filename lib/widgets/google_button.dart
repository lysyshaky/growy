import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:growy/consts/firebase_consts.dart';
import 'package:growy/fetch_screen.dart';
import 'package:growy/widgets/text_widget.dart';

import '../screens/btm_bar.dart';
import '../services/global_methods.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        try {
          final authResult = await authInstance.signInWithCredential(
            GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            ),
          );
          if (authResult.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set({
              'id': authResult.user!.uid,
              'fullName': authResult.user!.displayName,
              'email': authResult.user!.email,
              'shipping-address': '',
              'userWishList': [],
              'userCart': [],
              'createdAt': DateTime.now(),
              'updatedAt': DateTime.now(),
            });
          }
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const FetchScreen()));
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              subtitle: '${error.message}', context: context);
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
        } finally {
          await Firebase.initializeApp();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue.withOpacity(0.7),
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Image.asset(
                'assets/images/google.png',
                width: 40.0,
              ),
            ),
            const SizedBox(
              width: 12.0,
            ),
            TextWidget(
              color: Colors.white,
              text: AppLocalizations.of(context)!.google_sign_in,
              textSize: 18,
              isTitle: false,
            )
          ],
        ),
      ),
    );
  }
}
