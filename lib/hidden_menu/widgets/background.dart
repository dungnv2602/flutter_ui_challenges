import 'package:flutter/foundation.dart' show shortHash;
import 'package:flutter/material.dart';
import 'package:flutter_tmdb/constants.dart';
import 'package:flutter_tmdb/service_locator.dart';
import 'package:flutter_tmdb/ui_toolkit/ui_toolkit.dart';
import 'package:flutter_tmdb/views/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:tmdb_dart/tmdb_dart.dart';

import '../menu_notifier.dart';

class MenuBackground extends StatelessWidget {
  const MenuBackground({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseTmdbBlocView(
      onBlocReady: (service) => service.getMovieById(
        475557, // TODO(joe): get user preferences
        locator<SingleGetSettings>(),
      ),
      child: TmdbBlocBuilder<Movie>(
        successBuilder: (state) {
          final imageUrls = locator<AssetResolver>().getAssetPaths(
            collection: state.result.appendToResponse.images,
            assetType: AssetType.poster,
          );

          return Consumer<MenuNotifier>(
            builder: (_, notifier, child) {
              // TODO(joe): be creative when it comes to opacity
              return Opacity(
                opacity: notifier.menuProgress * 0.2,
                child: child,
              );
            },
            child: NetworkAutomatedCarousel(
              key: ValueKey(shortHash(this)), // avoid duplicate widget
              gapDuration: const Duration(minutes: 1),
              isDarkTheme: true,
              aspectRatio: moviePosterAspectRatio,
              imageUrls: imageUrls,
            ),
          );
        },
        errorBuilder: (_) => const SizedBox.shrink(),
      ),
    );
  }
}
