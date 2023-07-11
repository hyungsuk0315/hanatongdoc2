// // Copyright 2022, the Chromium project authors.  Please see the AUTHORS file
// // for details. All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.
//
import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' hide ProfileScreen;
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hanatongdoc2/screen/books_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';

import 'screen/profile_screen.dart';
import 'screen/books_screen.dart';
import 'decorations.dart';
import 'firebase_options.dart';

final actionCodeSettings = ActionCodeSettings(
  url: 'https://flutterfire-e2e-tests.firebaseapp.com',
  handleCodeInApp: true,
  androidMinimumVersion: '1',
  androidPackageName: 'io.flutter.plugins.firebase_ui.firebase_ui_example',
  iOSBundleId: 'io.flutter.plugins.fireabaseUiExample',
);
final emailLinkProviderConfig = EmailLinkAuthProvider(
  actionCodeSettings: actionCodeSettings,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),

  ]);

  runApp(const FirebaseAuthUIExample());
}

// Overrides a label for en locale
// To add localization for a custom language follow the guide here:
// https://flutter.dev/docs/development/accessibility-and-localization/internationalization#an-alternative-class-for-the-apps-localized-resources
class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'Enter your email';
}

class FirebaseAuthUIExample extends StatelessWidget {
  const FirebaseAuthUIExample({super.key});

  String get initialRoute {
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return '/';
    }


    return '/profile';
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    final mfaAction = AuthStateChangeAction<MFARequired>(
          (context, state) async {
        final nav = Navigator.of(context);

        await startMFAVerification(
          resolver: state.resolver,
          context: context,
        );

        nav.pushReplacementNamed('/profile');
      },
    );

    var locale = const Locale('en', 'US');


    return StatefulBuilder(
        builder: (context, setState) {
          setState(() => locale = const Locale('ko', 'KR'));
          return MaterialApp(
            theme: ThemeData(
              brightness: Brightness.light,
              visualDensity: VisualDensity.standard,
              useMaterial3: true,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
              textButtonTheme: TextButtonThemeData(style: buttonStyle),
              outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
            ),
            initialRoute: initialRoute,
            routes: {
              '/': (context) {
                return SignInScreen(

                  actions: [
                    ForgotPasswordAction((context, email) {
                      Navigator.pushNamed(
                        context,
                        '/forgot-password',
                        arguments: {'email': email},
                      );
                    }),
                    VerifyPhoneAction((context, _) {
                      Navigator.pushNamed(context, '/phone');
                    }),
                    AuthStateChangeAction<SignedIn>((context, state) {
                        Navigator.pushReplacementNamed(context, '/profile');
                    }),
                    AuthStateChangeAction<UserCreated>((context, state) {
                      Navigator.pushReplacementNamed(context, '/profile');
                    }),
                    AuthStateChangeAction<CredentialLinked>((context, state) {
                      Navigator.pushReplacementNamed(context, '/profile');
                    }),
                    mfaAction,
                    EmailLinkSignInAction((context) {
                      Navigator.pushReplacementNamed(
                          context, '/email-link-sign-in');
                    }),
                  ],
                  styles: const {
                    EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
                  },
                  headerBuilder: headerImage('images/lalab_logo.png'),
                  sideBuilder: sideImage('images/lalab_logo.png'),

                  footerBuilder: (context, action) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          action == AuthAction.signIn
                              ? 'By signing in, you agree to our terms and conditions.'
                              : 'By registering, you agree to our terms and conditions.',
                          style: const TextStyle(color: Colors.grey),

                        ),
                      ),
                    );
                  },
                );
              },
              '/verify-email': (context) {
                return EmailVerificationScreen(
                  headerBuilder: headerIcon(Icons.verified),
                  sideBuilder: sideIcon(Icons.verified),
                  actionCodeSettings: actionCodeSettings,
                  actions: [
                    EmailVerifiedAction(() {
                      Navigator.pushReplacementNamed(context, '/profile');
                    }),
                    AuthCancelledAction((context) {
                      FirebaseUIAuth.signOut(context: context);
                      Navigator.pushReplacementNamed(context, '/');
                    }),
                  ],
                );
              },
              '/phone': (context) {
                return PhoneInputScreen(
                  actions: [
                    SMSCodeRequestedAction((context, action, flowKey, phone) {
                      Navigator.of(context).pushReplacementNamed(
                        '/sms',
                        arguments: {
                          'action': action,
                          'flowKey': flowKey,
                          'phone': phone,
                        },
                      );
                    }),
                  ],
                  headerBuilder: headerIcon(Icons.phone),
                  sideBuilder: sideIcon(Icons.phone),
                );
              },
              '/sms': (context) {
                final arguments = ModalRoute
                    .of(context)
                    ?.settings
                    .arguments
                as Map<String, dynamic>?;

                return SMSCodeInputScreen(
                  actions: [
                    AuthStateChangeAction<SignedIn>((context, state) {
                      Navigator.of(context).pushReplacementNamed('/profile');
                    })
                  ],
                  flowKey: arguments?['flowKey'],
                  action: arguments?['action'],
                  headerBuilder: headerIcon(Icons.sms_outlined),
                  sideBuilder: sideIcon(Icons.sms_outlined),
                );
              },
              '/forgot-password': (context) {
                final arguments = ModalRoute
                    .of(context)
                    ?.settings
                    .arguments
                as Map<String, dynamic>?;

                return ForgotPasswordScreen(
                  email: arguments?['email'],
                  headerMaxExtent: 200,
                  headerBuilder: headerIcon(Icons.lock),
                  sideBuilder: sideIcon(Icons.lock),
                );
              },
              '/email-link-sign-in': (context) {
                return EmailLinkSignInScreen(
                  actions: [
                    AuthStateChangeAction<SignedIn>((context, state) {
                      Navigator.pushReplacementNamed(context, '/');
                    }),
                  ],
                  provider: emailLinkProviderConfig,
                  headerMaxExtent: 200,
                  headerBuilder: headerIcon(Icons.link),
                  sideBuilder: sideIcon(Icons.link),
                );
              },
              '/profile': (context) {
                return ProfileScreen();
              },
              '/books': (context) {
                return BooksScreen();
              },
            },
            title: 'Firebase UI demo',
            debugShowCheckedModeBanner: false,
            supportedLocales: const [
              Locale('en'),
              Locale('ko'),
            ],
            locale: locale,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              FirebaseUILocalizations.delegate,
            ],
            // locale: const Locale('ko', 'KR'),
            // localizationsDelegates: [
            //   FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   FirebaseUILocalizations.delegate,
            // ],
          );
        }
    );
  }
}

