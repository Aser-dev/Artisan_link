// lib/presentation/widgets/skeletons.dart
// Squelettes de chargement animés pour toutes les listes et cartes
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ─── Shimmer générique ──────────────────────────────────────
class ShimmerLoading extends StatefulWidget {
  final Widget child;

  const ShimmerLoading({super.key, required this.child});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ShimmerWidget(
      animation: _animation,
      child: widget.child,
    );
  }
}

class _ShimmerWidget extends AnimatedWidget {
  final Widget child;

  const _ShimmerWidget({
    required Animation<double> animation,
    required this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [
            Color(0xFF1A1A1A),
            Color(0xFF2A2A2A),
            Color(0xFF1A1A1A),
          ],
          stops: [
            animation.value.clamp(0.0, 0.5),
            (animation.value + 0.5).clamp(0.0, 1.0),
            (animation.value + 1.0).clamp(0.0, 1.0),
          ],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}

// ─── Skeleton Card pour les listes de commerces ─────────────
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.bordureSubtile),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16, width: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12, width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12, width: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Skeleton pour la carte ──────────────────────────────
class SkeletonMap extends StatelessWidget {
  const SkeletonMap({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }
}

// ─── Skeleton pour les détails d'un commerce ─────────────
class SkeletonDetail extends StatelessWidget {
  const SkeletonDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: ShimmerLoading(
            child: Container(color: const Color(0xFF2A2A2A)),
          ),
        ),
        Expanded(
          flex: 4,
          child: ShimmerLoading(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 14, width: 80,
                    decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 12),
                  Container(height: 22, width: 200,
                    decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 12),
                  Container(height: 14, width: 160,
                    decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 20),
                  Container(height: 100,
                    decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(16))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}