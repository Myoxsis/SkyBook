import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

/// A [TileProvider] that caches tiles to disk so previously viewed
/// areas remain available offline.
class CachedTileProvider extends TileProvider {
  const CachedTileProvider();

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer tileLayer) {
    var url = tileLayer.urlTemplate
        .replaceFirst('{x}', '${coordinates.x}')
        .replaceFirst('{y}', '${coordinates.y}')
        .replaceFirst('{z}', '${coordinates.z}');
    if (tileLayer.subdomains.isNotEmpty) {
      final subdomain = tileLayer
          .subdomains[(coordinates.x + coordinates.y) % tileLayer.subdomains.length];
      url = url.replaceFirst('{s}', subdomain);
    }
    return CachedNetworkImageProvider(url);
  }
}
