import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../generated/app_localizations.dart';
import '../providers/calculation_provider.dart';
import '../widgets/history_item_card.dart';
import '../widgets/breakdown_bottom_sheet.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Rect _shareOriginFor(BuildContext context) {
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox && renderObject.hasSize) {
      final size = renderObject.size;
      if (size.width > 0 && size.height > 0) {
        final origin = renderObject.localToGlobal(Offset.zero);
        return origin & size;
      }
    }

    final mediaSize = MediaQuery.sizeOf(context);
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalculationProvider>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<CalculationProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern gradient app bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                l10n.history,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.headerGradient,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: -30,
                      top: -20,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -20,
                      bottom: -30,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              if (provider.history.isNotEmpty)
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (value) async {
                    if (value == 'export_csv') {
                      final path = await provider.exportHistoryToCsv();
                      if (path != null && context.mounted) {
                        await Future<void>.delayed(
                          const Duration(milliseconds: 150),
                        );
                        final isShared = await provider.shareFile(
                          path,
                          subject: l10n.profitReport,
                          sharePositionOrigin: _shareOriginFor(context),
                        );
                        if (context.mounted) {
                          if (isShared) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.exportSuccess)),
                            );
                          } else {
                            final errorText =
                                provider.errorMessage ?? l10n.error;
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(errorText)));
                          }
                        }
                      }
                    } else if (value == 'clear_all') {
                      _showClearHistoryDialog();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'export_csv',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.file_download_rounded,
                              size: 18,
                              color: AppTheme.accentColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(l10n.exportCsv),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'clear_all',
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.dangerColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.delete_sweep_rounded,
                              size: 18,
                              color: AppTheme.dangerColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.clearHistory,
                            style: const TextStyle(color: AppTheme.dangerColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Content
          if (provider.isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              ),
            )
          else if (provider.history.isEmpty)
            SliverFillRemaining(child: _buildEmptyState(l10n))
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  // Statistics header
                  if (index == 0) {
                    return Column(
                      children: [
                        _buildStatsCard(provider),
                        const SizedBox(height: 16),
                        HistoryItemCard(
                          result: provider.history[index],
                          onTap: () => BreakdownBottomSheet.show(
                            context,
                            provider.history[index],
                          ),
                          onDelete: () {
                            HapticFeedback.mediumImpact();
                            provider.deleteCalculationById(
                              provider.history[index].id!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.calculationDeleted)),
                            );
                          },
                          onExportPdf: () async {
                            final path = await provider.exportToPdf(
                              provider.history[index],
                              title: l10n.profitReport,
                            );
                            if (path != null && context.mounted) {
                              await provider.shareFile(
                                path,
                                subject: l10n.profitReport,
                                sharePositionOrigin: _shareOriginFor(context),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: HistoryItemCard(
                      result: provider.history[index],
                      onTap: () => BreakdownBottomSheet.show(
                        context,
                        provider.history[index],
                      ),
                      onDelete: () {
                        HapticFeedback.mediumImpact();
                        provider.deleteCalculationById(
                          provider.history[index].id!,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.calculationDeleted)),
                        );
                      },
                      onExportPdf: () async {
                        final path = await provider.exportToPdf(
                          provider.history[index],
                          title: l10n.profitReport,
                        );
                        if (path != null && context.mounted) {
                          await provider.shareFile(
                            path,
                            subject: l10n.profitReport,
                            sharePositionOrigin: _shareOriginFor(context),
                          );
                        }
                      },
                    ),
                  );
                }, childCount: provider.history.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(CalculationProvider provider) {
    final history = provider.history;
    final totalProfit = history.fold<double>(0, (sum, r) => sum + r.netProfit);
    final profitableCount = history.where((r) => r.isProfitable).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Row(
        children: [
          _buildStatItem('Toplam', '${history.length}', Icons.receipt_rounded),
          _buildStatDivider(),
          _buildStatItem(
            'Karlı',
            '$profitableCount',
            Icons.trending_up_rounded,
          ),
          _buildStatDivider(),
          _buildStatItem(
            'Net',
            '₺${totalProfit.toStringAsFixed(0)}',
            Icons.account_balance_wallet_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.noHistory,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Hesaplamalarınız burada görünecek',
              style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearHistoryDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.dangerColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_sweep_rounded,
                color: AppTheme.dangerColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(l10n.clearHistory),
          ],
        ),
        content: Text(l10n.confirmClearHistory),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final provider = context.read<CalculationProvider>();
              final messenger = ScaffoldMessenger.of(context);
              await provider.clearAllHistory();
              messenger.showSnackBar(
                SnackBar(content: Text(l10n.historyCleared)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}
