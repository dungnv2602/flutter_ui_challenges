import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tmdb/core/core.dart';
import 'package:flutter_tmdb/service_locator.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';
import 'package:tmdb_dart/tmdb_dart.dart';

import 'commons.dart';

// TODO(joe): use WebView controller to controll WebView instead: https://medium.com/flutter/the-power-of-webviews-in-flutter-a56234b57df2
// TODO(joe): WebView is costly
class SignInMenuItem extends StatefulWidget {
  @override
  _SignInMenuItemState createState() => _SignInMenuItemState();
}

class _SignInMenuItemState extends State<SignInMenuItem>
    with WidgetsBindingObserver {
  Completer<bool> completer;

  AccountBloc bloc;

  Widget signInWidget;
  Widget signOutWidget;

  @override
  void initState() {
    super.initState();
    // init bloc
    bloc = AccountBloc(locator<TmdbRepo>());
    // init signin widget
    signInWidget = MenuItem(
      title: 'Sign In',
      icon: Icons.ac_unit,
      onTap: () {
        // STEP 1. Create request token
        bloc.add(const RequestTokenEvent());
      },
    );
    // init signout widget
    signOutWidget = MenuItem(
      title: 'Sign Out',
      icon: Icons.ac_unit,
      onTap: () {
        // STEP 7. sign out
        bloc.add(const SignOutEvent());
      },
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (_) => bloc,
      child: BlocConsumer<AccountBloc, AccountBlocState>(
        listener: (context, state) {
          state.map(
            idle: (_) {},
            loading: (_) {},
            error: (error) {
              showToast(error.error.message);
            },
            requestTokenSuccess: (token) async {
              // STEP 2. launch tmdb to get user approve request token
              final requestToken = token.token;
              // start a new completer
              completer = Completer<bool>();
              // user now refered to webview for approving token
              UrlLauncher.launchUrl(
                  'https://www.themoviedb.org/auth/access?request_token=${requestToken.requestToken}');

              // waiting for user to review
              final isDone = await completer.future;

              if (isDone) {
                // STEP 3. get access token after user approve the request token
                bloc.add(RequestUserAccessTokenEvent(requestToken));
              }
            },
            requestUserAccessTokenSuccess: (token) {
              // STEP 4. re-assign accountId & access token in secure storage
              final accessToken = token.token;
              locator<SecureStorageDs>()
                  .setUserAccountId(accessToken.accountId);
              locator<SecureStorageDs>()
                  .setUserAccessToken(accessToken.accessToken);

              // STEP 5. convert access token to session
              bloc.add(RequestSessionEvent(accessToken));
            },
            requestSessionSuccess: (sessionState) {
              final session = sessionState.session;
              // STEP 6. re-assign sessionId in secure storage
              locator<SecureStorageDs>().setUserSessionId(session.sessionId);
            },
            signedOut: (_) {
              // STEP 8. clear all vars in secure storage
              locator<SecureStorageDs>().deleteUserAccountId();
              locator<SecureStorageDs>().deleteUserAccessToken();
              locator<SecureStorageDs>().deleteUserSessionId();
            },
          );
        },
        builder: (context, state) {
          return state.map(
            idle: (_) => locator<TmdbService>().isSignedIn
                ? signOutWidget
                : signInWidget,
            error: (_) => signInWidget,
            loading: (_) => loadingWidget,
            requestTokenSuccess: (_) => loadingWidget,
            requestUserAccessTokenSuccess: (_) => loadingWidget,
            requestSessionSuccess: (state) => signOutWidget,
            signedOut: (_) => signInWidget,
          );
        },
      ),
    );
  }

  void completeCompleter() {
    completer?.complete(true);
    completer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // complete the completer when user come back to app
    if (state == AppLifecycleState.resumed) completeCompleter();
  }

  @override
  void dispose() {
    completeCompleter();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
