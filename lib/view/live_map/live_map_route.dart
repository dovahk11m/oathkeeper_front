import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'live_map_page.dart';

final GoRoute liveMapRoute = GoRoute(
  path: '/live-map/:planId',
  name: 'live-map',
  pageBuilder: (context, state) {
    final idStr = state.pathParameters['planId']!;
    final planId = int.tryParse(idStr) ?? 0;
    return const NoTransitionPage(
      child: SizedBox.shrink(), // placeholder, 아래 builder 사용
    );
  },
  builder: (context, state) {
    final idStr = state.pathParameters['planId']!;
    final planId = int.tryParse(idStr) ?? 0;
    return LiveMapPage(planId: planId);
  },
);
