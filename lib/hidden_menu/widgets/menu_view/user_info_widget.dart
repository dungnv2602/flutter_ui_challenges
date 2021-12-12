import 'package:flutter/material.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';
import 'package:flutter_tmdb/views/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_dart/tmdb_dart.dart';

import '../../menu_notifier.dart';
import 'commons.dart';

class UserInfoWidget extends StatelessWidget {
  Widget buildUserInfo(String name, String username, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 32),
      child: Column(
        children: <Widget>[
          Text(
            name,
            style: context.darkHeadline5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              username,
              style: context.darkCaption,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MenuNotifier>(
      builder: (context, notifier, child) {
        return Opacity(
          // TODO(joe): be creative when it comes to opacity
          opacity: interval.transform(notifier.menuProgress),
          child: notifier.isSignedIn
              ? BaseTmdbBlocView(
                  onBlocReady: (service) => service.accountDetails(),
                  child: TmdbBlocBuilder<Account>(
                    loadingIndicator: loadingWidget,
                    successBuilder: (state) => buildUserInfo(
                      state.result.name,
                      state.result.username,
                      context,
                    ),
                    errorBuilder: (_) => const SizedBox.shrink(),
                  ),
                )
              : buildUserInfo('Guest', 'guest', context),
        );
      },
    );
  }
}
