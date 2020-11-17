import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nuvigator/next.dart';
import 'package:nuvigator/src/deeplink.dart';
import '../screen_route.dart';
import 'nu_route_match.dart';
import 'v1/nu_module.dart';

abstract class NuRoute<T extends NuModule, A extends Object, R extends Object> {
  String get path;

  // TBD
  bool get prefix => false;
  T _module;

  T get module => _module;

  NuvigatorState get nuvigator => module.nuvigator;

  DeepLinkParser get parser => DeepLinkParser(path, prefix: prefix);

  A parseParameters(Map<String, dynamic> map);

  void install(T module) {
    _module = module;
  }

  Future<bool> init(BuildContext context) {
    return SynchronousFuture(true);
  }

  NuRouteMatch<A> getRouteMatch(
    String deepLink, {
    Map<String, dynamic> extraParameters,
  }) {
    return NuRouteMatch(
      args: parseParameters(
        parser.getParams(deepLink),
      ),
      pathTemplate: path,
      extraParameter: extraParameters,
      pathParameters: parser.getPathParams(deepLink),
      queryParameters: parser.getQueryParams(deepLink),
      path: deepLink,
    );
  }

  Widget wrapper(BuildContext context, Widget child) => child;

  ScreenType get screenType;

  Widget build(BuildContext context, NuRouteMatch<A> match);

  ScreenRoute<R> getRoute(NuRouteMatch<A> match) => ScreenRoute(
        builder: (context) => build(context, match),
        screenType: screenType,
        wrapper: wrapper,
      );
}
