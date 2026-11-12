import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_flow.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/product/presentation/product_page.dart';
import '../../features/rewards/presentation/rewards_page.dart';
import '../providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  return GoRouter(initialLocation: '/start', routes: [
    GoRoute(
        path: '/start',
        redirect: (context, state) async =>
            (await auth.isLoggedIn) ? '/home' : '/onboarding'),
    GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage()),
    GoRoute(
        path: '/auth/register',
        builder: (context, state) => const AuthFlowPage(isLogin: false)),
    GoRoute(
        path: '/auth/login',
        builder: (context, state) => const AuthFlowPage(isLogin: true)),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomePage()),
    ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (context, state) => const HomePage()),
          GoRoute(
              path: '/rewards',
              builder: (context, state) => const RewardsPage()),
          GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage()),
          GoRoute(
              path: '/cart',
              builder: (context, state) =>
                  const PlaceholderPage(title: 'Cart')),
          GoRoute(
              path: '/explore',
              builder: (context, state) =>
                  const PlaceholderPage(title: 'Explore'))
        ]),
    GoRoute(
        path: '/product/:id',
        builder: (context, state) =>
            ProductPage(id: state.pathParameters['id']!))
  ]);
});

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    const paths = ['/home', '/rewards', '/explore', '/cart', '/settings'];
    return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
            selectedIndex: paths.indexOf(location).clamp(0, 4),
            onDestinationSelected: (index) => context.go(paths[index]),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined), label: 'Home'),
              NavigationDestination(
                  icon: Icon(Icons.workspace_premium_outlined),
                  label: 'Reward'),
              NavigationDestination(
                  icon: Icon(Icons.explore_outlined), label: 'Explore'),
              NavigationDestination(
                  icon: Icon(Icons.shopping_bag_outlined), label: 'Cart'),
              NavigationDestination(
                  icon: Icon(Icons.settings_outlined), label: 'Settings')
            ]));
  }
}

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) =>
      Center(child: Text('$title coming soon'));
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Log out'),
          onTap: () async {
            await ref.read(authRepositoryProvider).logout();
            if (context.mounted) context.go('/onboarding');
          }));
}
