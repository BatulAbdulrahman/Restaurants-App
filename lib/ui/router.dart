import 'package:auto_route/auto_route.dart';
import 'package:nearby_restaurants_app/ui/homepage/homepage.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MyHomeRoute.page, initial: true),
      ];
}
