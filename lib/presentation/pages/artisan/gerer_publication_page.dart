// lib/presentation/pages/artisan/gerer_publication_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/commerce_provider.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/theme/app_theme.dart';

class GererPublicationPage extends ConsumerStatefulWidget {
  final String commerceId;
  final bool estPublieActuel;
  const GererPublicationPage({super.key, required this.commerceId, required this.estPublieActuel});

  @override
  ConsumerState<GererPublicationPage> createState() => _GererPublicationPageState();
}

class _GererPublicationPageState extends ConsumerState<GererPublicationPage> {
  late bool _estPublie;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _estPublie = widget.estPublieActuel;
  }

  Future<void> _sauvegarder() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(togglePublicationUsecaseProvider).call(
        commerceId: widget.commerceId, publier: _estPublie);
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_estPublie ? 'Commerce publié !' : 'Commerce retiré de l\'annuaire.'),
        backgroundColor: _estPublie ? AppTheme.primaryContainer : AppTheme.terracottaClay,
      ));
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur : ${e.toString()}'),
        backgroundColor: AppTheme.error,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final commerceAsync = ref.watch(commerceDetailProvider(widget.commerceId));

    return Scaffold(
      backgroundColor: AppTheme.neutralSand,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceContainerLow,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.primary),
          onPressed: () => context.pop(),
        ),
        title: Row(children: [
          Container(width: 32, height: 32,
            decoration: BoxDecoration(color: AppTheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.handyman_rounded, color: AppTheme.onPrimaryContainer, size: 18)),
          const SizedBox(width: 10),
          const Text('Artisan Core', style: TextStyle(fontFamily: 'Hanken Grotesk', fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 18)),
        ]),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gérer la publication', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 26, fontWeight: FontWeight.w700, color: AppTheme.primary)),
            const SizedBox(height: 6),
            const Text('Contrôlez la visibilité de vos commerces. Les éléments "Publié" sont visibles par tous les citoyens.',
              style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 14, height: 1.5)),
            const SizedBox(height: 20),

            // Info banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.info_rounded, color: AppTheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Text.rich(TextSpan(
                  style: const TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 13, height: 1.4),
                  children: [
                    const TextSpan(text: 'Un commerce en '),
                    const TextSpan(text: 'Brouillon', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
                    const TextSpan(text: ' est uniquement visible par vous. Une fois '),
                    const TextSpan(text: 'Publié', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary)),
                    const TextSpan(text: ', votre visibilité est instantanée.'),
                  ],
                ))),
              ]),
            ),
            const SizedBox(height: 24),

            // Card commerce
            commerceAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
              error: (_, __) => const SizedBox.shrink(),
              data: (commerce) => _buildCommerceCard(commerce),
            ),

            const SizedBox(height: 16),

            // CTA nouveau commerce
            GestureDetector(
              onTap: () => context.push('/artisan/creer'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.outlineVariant, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(children: [
                  Icon(Icons.add_rounded, color: AppTheme.primary, size: 32),
                  SizedBox(height: 8),
                  Text('Nouveau commerce', style: TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.primary)),
                  SizedBox(height: 4),
                  Text('Créez une nouvelle fiche pour augmenter votre visibilité.',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant)),
                ]),
              ),
            ),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity, height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sauvegarder,
                child: _isLoading
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: AppTheme.onPrimary, strokeWidth: 2))
                    : const Text('Enregistrer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildCommerceCard(dynamic commerce) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.05), blurRadius: 12)],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          SizedBox(
            height: 180, width: double.infinity,
            child: commerce.photos.isNotEmpty
                ? Image.network(commerce.photos.first, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder())
                : _imagePlaceholder(),
          ),
          Positioned(top: 12, left: 12,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: _estPublie ? AppTheme.primary : AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 6, height: 6,
                  decoration: BoxDecoration(
                    color: _estPublie ? AppTheme.inversePrimary : AppTheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 6),
                Text(_estPublie ? 'Publié' : 'Brouillon',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                    color: _estPublie ? AppTheme.onPrimary : AppTheme.onSurfaceVariant)),
              ]),
            )),
        ]),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(commerce.nom, style: const TextStyle(fontFamily: 'Hanken Grotesk', fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.primary)),
            const SizedBox(height: 2),
            Text(commerce.categorie, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.terracottaClay)),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Expanded(child: Text(commerce.descriptionAdresse ?? 'Localisation non renseignée',
                style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant), overflow: TextOverflow.ellipsis)),
            ]),
            const Divider(height: 24, color: AppTheme.outlineVariant),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('État de visibilité', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.onSurface)),
              Row(children: [
                Text(_estPublie ? 'Publié' : 'Privé',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    color: _estPublie ? AppTheme.primary : AppTheme.onSurfaceVariant)),
                const SizedBox(width: 10),
                Switch(
                  value: _estPublie,
                  onChanged: _isLoading ? null : (v) => setState(() => _estPublie = v),
                  activeThumbColor: AppTheme.onPrimary,
                  activeTrackColor: AppTheme.primary,
                  inactiveThumbColor: AppTheme.onSurfaceVariant,
                  inactiveTrackColor: AppTheme.surfaceVariant,
                ),
              ]),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 180, width: double.infinity,
      color: AppTheme.surfaceContainerHigh,
      child: Center(child: Icon(Icons.storefront_rounded, size: 48,
        color: _estPublie ? AppTheme.primary.withValues(alpha: 0.4) : AppTheme.outlineVariant)),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final items = [
      (Icons.dashboard_rounded, 'Dashboard', false, '/artisan/dashboard'),
      (Icons.add_circle_outline_rounded, 'Ajouter', false, '/artisan/creer'),
      (Icons.inventory_2_outlined, 'Mes Offres', false, ''),
      (Icons.visibility_rounded, 'Visibilité', true, ''),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.outlineVariant.withValues(alpha: 0.5))),
        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, -4))],
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) => GestureDetector(
          onTap: () { if (item.$4.isNotEmpty) context.go(item.$4); },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: item.$3 ? AppTheme.primaryContainer.withValues(alpha: 0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(item.$1, color: item.$3 ? AppTheme.primary : AppTheme.onSurfaceVariant, size: 22),
              const SizedBox(height: 2),
              Text(item.$2, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                color: item.$3 ? AppTheme.primary : AppTheme.onSurfaceVariant)),
            ]),
          ),
        )).toList(),
      ),
    );
  }
}
