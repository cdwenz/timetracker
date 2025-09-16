import 'package:flutter/material.dart';
import 'package:ihadi_time_tracker/widgets/custom_drawer.dart';
import 'package:ihadi_time_tracker/screens/reports_screen.dart';
import 'package:ihadi_time_tracker/screens/account_screen.dart';
import 'package:ihadi_time_tracker/screens/tracking_steps_screens/step_01_screen.dart';

// helper local, mismo patrón que el Drawer
void _go(BuildContext context, Widget page, {bool replace = false}) {
  if (replace) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  } else {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      drawerEnableOpenDragGesture: true,
      appBar: AppBar(
        title: const Text('Panel'),
        centerTitle: false,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // 2 columnas en móvil, 3 si hay ancho grande
            final crossAxisCount = constraints.maxWidth >= 900
                ? 3
                : constraints.maxWidth >= 600
                    ? 3
                    : 2;

            return GridView.count(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.35, // parecido a tu mock
              children: [
                _DashboardTile(
                  title: 'Tracking',
                  subtitle: 'Iniciar y detener',
                  icon: Icons.timer_outlined,
                  onTap: () =>
                      _go(context, const StepOneScreen(), replace: true),
                ),
                _DashboardTile(
                  title: 'Reports',
                  subtitle: 'Tiempos y métricas',
                  icon: Icons.bar_chart_rounded,
                  onTap: () =>
                      _go(context, const ReportsScreen(), replace: true),
                ),
                _DashboardTile(
                  title: 'Account',
                  subtitle: 'Perfil y sesión',
                  icon: Icons.person_rounded,
                  onTap: () =>
                      _go(context, const AccountScreen(), replace: true),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? routeName; // opcional (fallback)
  final VoidCallback? onTap; // NUEVO

  const _DashboardTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.routeName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surface;
    final primary = theme.colorScheme.primary;
    final textTheme = theme.textTheme;
    final tap = onTap ??
        (routeName != null
            ? () => Navigator.of(context).pushReplacementNamed(routeName!)
            : null);

    return InkWell(
      onTap: tap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: kElevationToShadow[1],
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.35),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: theme.colorScheme.onSurface),
              const SizedBox(height: 12),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              // línea acento bajo el título, como en tu imagen
              Container(
                  width: 28,
                  height: 3,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(2),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
