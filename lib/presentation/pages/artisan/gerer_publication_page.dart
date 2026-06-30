// lib/presentation/pages/artisan/gerer_publication_page.dart
// Gestion du statut Publié/Brouillon avec toggle animé et haptique
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/commerce_provider.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/design_system.dart';
import '../../widgets/skeletons.dart';
import '../../../domain/entities/commerce_entity.dart';

class GererPublicationPage extends ConsumerStatefulWidget {
  final String commerceId;
  final bool estPublieActuel;
  const GererPublicationPage(
      {super.key, required this.commerceId, required this.estPublieActuel});

  @override
  ConsumerState<GererPublicationPage> createState() =>
      _GererPublicationPageState();
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
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);
    try {
      await ref.read(togglePublicationUsecaseProvider).call(
            commerceId: widget.commerceId,
            publier: _estPublie,
          );
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_estPublie
            ? 'Commerce publié !'
            : "Commerce retiré de l'annuaire."),
        backgroundColor: _estPublie
            ? AppTheme.accentSecondaire
            : AppTheme.texteTertiaire,
      ));
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur : ${e.toString()}'),
        backgroundColor: AppTheme.erreur,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final commerceAsync =
        ref.watch(commerceDetailProvider(widget.commerceId));

    return Scaffold(
      backgroundColor: AppTheme.fondPrincipal,
      appBar: AppBar(
        title: Text('Artisan BF',
            style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: AppTheme.textePrimaire)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppTheme.textePrimaire),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gérer la publication',
              style: GoogleFonts.inter(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppTheme.textePrimaire,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Contrôlez la visibilité de vos commerces.',
              style: GoogleFonts.inter(
                  fontSize: 14, color: AppTheme.texteSecondaire),
            ),
            const SizedBox(height: 20),

            // Info banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentSecondaire.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppTheme.accentSecondaire
                        .withValues(alpha: 0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_rounded,
                      color: AppTheme.accentPrimaire, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: GoogleFonts.inter(
                          color: AppTheme.texteSecondaire,
                          fontSize: 13,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(
                              text: 'Un commerce en '),
                          TextSpan(
                            text: 'Brouillon',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.texteTertiaire,
                            ),
                          ),
                          const TextSpan(
                              text:
                                  ' est uniquement visible par vous. Une fois '),
                          TextSpan(
                            text: 'Publié',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accentPrimaire,
                            ),
                          ),
                          const TextSpan(
                              text:
                                  ', votre visibilité est instantanée.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Card commerce
            commerceAsync.when(
              loading: () => const SkeletonCard(),
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
                  border: Border.all(
                      color: AppTheme.bordureSubtile, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.add_rounded,
                        color: AppTheme.accentPrimaire, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Nouveau commerce',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accentPrimaire,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Créez une nouvelle fiche.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.texteSecondaire),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            PrimaryButton(
              label: 'Enregistrer',
              isLoading: _isLoading,
              onPressed: _sauvegarder,
              icon: Icons.save_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommerceCard(CommerceEntity commerce) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.bordureSubtile),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 180,
                width: double.infinity,
                child: commerce.photos.isNotEmpty
                    ? Image.network(commerce.photos.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _imagePlaceholder())
                    : _imagePlaceholder(),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: _estPublie
                        ? AppTheme.accentPrimaire
                        : AppTheme.surfaceCardHover,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _estPublie
                              ? const Color(0xFF0F0F0F)
                              : AppTheme.texteTertiaire,
                          borderRadius:
                              BorderRadius.circular(99),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _estPublie ? 'PUBLIÉ' : 'BROUILLON',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: _estPublie
                              ? const Color(0xFF0F0F0F)
                              : AppTheme.texteTertiaire,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  commerce.nom,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textePrimaire,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  commerce.categorie,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentPrimaire,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 14,
                        color: AppTheme.texteSecondaire),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        commerce.descriptionAdresse ??
                            'Localisation non renseignée',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.texteSecondaire,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Divider(
                    height: 24, color: AppTheme.bordureSubtile),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "État de visibilité",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textePrimaire,
                      ),
                    ),
                    Row(
                      children: [
                        AnimatedDefaultTextStyle(
                          duration:
                              const Duration(milliseconds: 250),
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _estPublie
                                ? AppTheme.accentPrimaire
                                : AppTheme.texteTertiaire,
                          ),
                          child:
                              Text(_estPublie ? 'Publié' : 'Privé'),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(
                                () => _estPublie = !_estPublie);
                          },
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 250),
                            width: 52,
                            height: 30,
                            decoration: BoxDecoration(
                              color: _estPublie
                                  ? AppTheme.accentPrimaire
                                  : AppTheme.surfaceCardHover,
                              borderRadius:
                                  BorderRadius.circular(99),
                              border: Border.all(
                                color: _estPublie
                                    ? AppTheme.accentPrimaire
                                    : AppTheme.bordureSubtile,
                              ),
                            ),
                            child: AnimatedAlign(
                              duration:
                                  const Duration(milliseconds: 250),
                              alignment: _estPublie
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 24,
                                height: 24,
                                margin:
                                    const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: _estPublie
                                      ? const Color(0xFF0F0F0F)
                                      : AppTheme.texteTertiaire,
                                  borderRadius:
                                      BorderRadius.circular(99),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: AppTheme.surfaceCardHover,
      child: Center(
        child: Icon(Icons.storefront_rounded,
            size: 48,
            color: _estPublie
                ? AppTheme.accentPrimaire.withValues(alpha: 0.3)
                : AppTheme.texteTertiaire),
      ),
    );
  }
}